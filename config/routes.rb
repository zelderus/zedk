Blog2::Application.routes.draw do
    
	get     "welcome/index"
	root    'welcome#index'

	# auth
	match	"usrlog" => "auth#user_login", via: [:get, :post]
	get		"usrext" => "auth#user_destroy"


	# shcoder
	get    "shcoder" => "shcoder#index", :as => :Shcoder
	get    "shcoder/article(/:idname)" => "shcoder#article"
	get    "shcoder/category(/:idname)" => "shcoder#category"
	get    "shcoder/srv/edit(/:idname)" => "shcoder#edit_article"
	post   "shcoder/srv/editdo" => "shcoder#edit_article_do"

	# projector
	get    "projector" => "projector#index", :as => :Projector
  

  

end
