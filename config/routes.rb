Blog2::Application.routes.draw do
    
	get     "welcome/index"
	root    'welcome#index'



	#shcoder
	get    "shcoder" => "shcoder#index"


	
	# test
	match  "do/:name(/:text)", to: "welcome#txt", as: :bot, defaults: { name: 'bote', text: 'woop' }, via: [:get, :post]
	get    "test" => "welcome#test"
	get    "testjson" => "welcome#testjson"
	get    "ss" => "welcome#ss"
  

  

end
