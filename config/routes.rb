Blog2::Application.routes.draw do
    
	get     "welcome/index"
	root    'welcome#index'

	# auth
	match	"usrlog" => "auth#user_login", via: [:get, :post]
	get		"usrext" => "auth#user_destroy"


	# shcoder
	get    "shcoder" => "shcoder#index", :as => :Shcoder
	get    "shcoder/article(/:idname)" => "shcoder#article"
	get    "shcoder/srv/edit(/:idname)" => "shcoder#edit_article"
	
	# projector
	get    "projector" => "projector#index", :as => :Projector
  

  

end
