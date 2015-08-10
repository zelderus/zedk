

class ShcoderController < ApplicationController



	def index
		# page
		set_title(t('shcoder_headers_title'))
		set_headers(t('shcoder_headers_keyword'), t('shcoder_headers_desc'))
		add_js('shcoder')
		set_menu([ ['Shcoder'] ])
		
		# client
		client = ShcoderHelper::ShcoderManager.new
		# get articles
		pageSize = 10
		@lastArticles = client.get_last_articles(pageSize)
		
		
	end
	
	
	
	
	
	def article
		# client
		client = ShcoderHelper::ShcoderManager.new
		# get article
		articleIdName = params[:idname]
		@article = client.get_article_by_idname(articleIdName)

		if (@article.nil?)
			raise ActionController::RoutingError.new('Not Found')
			return
		end
	
		# page
		set_title(@article.title)
		set_headers(@article.title, @article.teaser)
		add_js('shcoder')
		set_menu([ ['Shcoder', '/shcoder'], [@article.title, ''] ])
		
	end
	
	
	


end
