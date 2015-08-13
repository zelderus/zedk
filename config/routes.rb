Blog2::Application.routes.draw do
    
	get     "welcome/index"
	root    'welcome#index'

	# auth
	get    "usrlog" => "auth#user_login"
	get    "usrext" => "auth#user_destroy"


	#shcoder
	get    "shcoder" => "shcoder#index"
	get    "shcoder/article(/:idname)" => "shcoder#article"

	
	# test
	match  "do/:name(/:text)", to: "welcome#txt", as: :bot, defaults: { name: 'bote', text: 'woop' }, via: [:get, :post]
	get    "test" => "welcome#test"
	get    "testjson" => "welcome#testjson"
	get    "ss" => "welcome#ss"
  

  

end
