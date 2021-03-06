(ns poeticc.core
  (:use compojure.core)
  (:use hiccup.core)
  (:use com.ashafa.clutch)
  (:use ring.adapter.jetty)
  (:use ring.middleware.reload)
  (:use ring.middleware.stacktrace)
  (:require [org.danlarkin.json :as json])
  (require [compojure.route :as route]))

;; set up db definition
(def info (json/decode-from-str (slurp "../config.json")))
(def db
     (info :couch))

(def analytics
     (if (not (info :prod))
       (slurp "templates/analytics.html")))

;; Some helper functions
(defn alpha-split
     "splits the sequence into sequences in which the first letter of each sequence is a particular letter
      for example (andy brandy blandy candy) -> ((andy) (brandy blandy) (candy) () () ...)"
     [rows row-key]
     (let [letters '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")]
       ; the fn is a closure that persists the 'rows' and 'row-key' to the actual map function
       (map ((fn [rows row-key] 
	       (fn [letter] (filter (fn [row] (.matches (row row-key) (str "^" letter ".*"))) rows))) rows row-key) letters)))

(defn html-list-items
  "converts the rows into and html list
   inside-list-fn takes a row and converts it into whatever element should be inside the list element"
  [inside-list-fn rows]
  (html (map (fn [row]
	       [:li (inside-list-fn row)]) rows)))

(defn html-list-part
  "converts the rows into a partition of a list "
  [inside-list-fn rows part-name]
  (html [:li {:class "group"} part-name]
	(html-list-items inside-list-fn rows)))

(defn main-list
  "Generates the list of all poets, separated by first letter of their last name, with the count of works in parens"
  []
  (with-db db
		(let [rows ((get-view "couch" :poets {:group true}) :rows)]
		  (html [:ul {:id "home" :title "Poeticc" :selected "true"}
			 (html (map (fn [rows-part] 
				      (if (not-empty rows-part)
					(html-list-part (fn [row] [:a 
								   {:href (str "/poet/" (row :key) ".html")}
								   (str (row :key) " (" (row :value) ")")])
							rows-part
							(str (first ((first rows-part) :key)))))) (alpha-split rows :key)))]))))

(defn poet-list
  "Generates the list of works for the poet with name poet-name"
  [poet-name]
  (with-db db
    (let [rows (-> (get-view "couch" :poets {:key poet-name
					     :reduce false}) :rows)]
      (html [:ul {:id "artist" :title poet-name} 
	     (html-list-items (fn [row] 
				[:a 
				 {:href (str "/poem/" (-> row :id) ".html")} 
				 (str (-> row :value))])
			      rows)]))))

;; my routes
(defroutes handler
  (GET "/" []
       (html [:head 
	      [:meta {:name "viewport" :content "width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"}]
	      [:link {:rel "apple-touch-icon" :href "/iui/iui-logo-touch-icon.png"}]
	      [:meta {:name "apple-touch-fullscreen" :content "YES"}]
	      [:style {:type "text/css" :media "screen"} "@import \"/iui/iui.css\";"]
	      [:script {:type "application/x-javascript" :src "/iui/iui.js"}]]
	     
	     [:body
	      [:div {:class "toolbar"}
	       [:h1 {:id "pageTitle"}]
	       [:a {:id "backButton" :class "button" :href "#"}]]
	      analytics]
	     
	     (main-list)))
  (GET ["/poet/:name.html" :name #"[A-Za-z0-9.,% ]+"] [name]
       (poet-list name))

  (GET "/poem/:id.html" [id]
       (with-db db
		(let [doc (get-document id)]
		  (html [:div {:title (-> doc :title)}
			 [:div {:id "poem"} (str (-> doc :body_html))]
			 [:div {:id "author"} (str (-> doc :author))]]))))
  (route/files "/" {:root "public"})

  (GET "/all" []
       (with-db db
	 (html (get-view "couch" :poets {:group true})))))

(def app
     (-> #'handler
	 (wrap-reload '[poeticc.core])
	 (wrap-stacktrace)))