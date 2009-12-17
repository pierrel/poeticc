(ns poeticc
  (:use compojure)
  (:use com.ashafa.clutch)
  (:require [org.danlarkin.json :as json]))

;; set up db definition
(def db
     (-> (json/decode-from-str (slurp "../config.json")) :couch))

;; Some helper functions
(defn alpha-split
     "splits the sequence into sequences in which the first letter of each sequence is a particular letter
      for example (andy brandy blandy candy) -> ((andy) (brandy blandy) (candy))"
     [rows row-key]
     (let [letters '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")]
       (map ((fn [rows row-key] 
	       (fn [letter] (filter (fn [row] (.matches (-> row row-key) (str "^" letter ".*"))) rows))) rows row-key) letters)))

(defn main-list
  []
  (with-db db
		(let [rows (-> (get-view "couch" :poets {:group true
							 :group_level 1}) :rows)]
		  (html [:ul {:id "home" :title "Poeticc" :selected "true"}
			 (reduce html (map (fn [row]
					     [:li [:a
						   {:href (str "/poet/" (-> row :key) ".html") }
						   (str (-> row :key) " (" (-> row :value) ")")]]) rows))]))))

(defn poet-list
  [poet-name]
  (with-db db
	   (let [rows (-> (get-view "couch" :poets {:key (.replace poet-name " " "%20")
						    :reduce false}) :rows)]
	     (html [:ul {:id "artist" :title poet-name} 
		    (reduce html (map (fn [row] 
					[:li [:a 
					      {:href (str "/poem/" (-> row :id) ".html")} 
					      (str (-> row :value))]])
				      rows))]))))

;; my routes
(defroutes app
  (GET "/*" 
    (or (serve-file (params :*)) :next))

  (GET "/"
       (html [:head 
	      [:meta {:name "viewport" :content "width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"}]
	      [:link {:rel "apple-touch-icon" :href "/iui/iui-logo-touch-icon.png"}]
	      [:meta {:name "apple-touch-fullscreen" :content "YES"}]
	      [:style {:type "text/css" :media "screen"} "@import \"/iui/iui.css\";"]
	      [:script {:type "application/x-javascript" :src "/iui/iui.js"}]]
	     
	     [:div {:class "toolbar"}
	      [:h1 {:id "pageTitle"}]
	      [:a {:id "backButton" :class "button" :href "#"}]]
	     
	     (main-list)))
  (GET #"/poet/([A-Za-z0-9.,% ]+).html"
       (poet-list ((:route-params request) 0)))

  (GET "/poem/:id.html"
       (with-db db
		(let [doc (get-document (params :id))]
		  (html [:div {:title (-> doc :title)}
			 [:div {:id "poem"} (str (-> doc :body_html))]
			 [:div {:id "author"} (str (-> doc :author))]])))))

(run-server {:port 3000}
	    "/*" (servlet app))

