(ns pocketpoet
  (:use compojure)
  (:use com.ashafa.clutch))

(def db
     {:name "poems"
      :host "174.143.156.7"})  


(defn main-list
  []
  (with-db db
		(let [rows (-> (get-view "couch" :poets {:group true
							 :group_level 1}) :rows)]
		  (html [:ul {:id "home" :title "Pocket Poet" :selected "true"}
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

(defroutes my-app
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
  (GET "/poet/:name.html"
       (poet-list (params :name)))

  (GET "/poem/:id.html"
       (with-db db
		(let [doc (get-document (params :id))]
		  (html [:div {:title (-> doc :title)}
			 [:div {:id "poem"} (str (-> doc :body_html))]
			 [:div {:id "author"} (str (-> doc :author))]])))))

(run-server {:port 3000}
	    "/*" (servlet my-app))

