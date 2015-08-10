

class ShcoderController < ApplicationController



	def index
		# page
		set_title(t('shcoder_headers_title'))
		set_headers(t('shcoder_headers_keyword'), t('shcoder_headers_desc'))
		add_js('shcoder')
		set_menu([ ['Shcoder'] ])
		
		# get articles
		pageSize = 10
		client = ShcoderHelper::ShcoderManager.new
		@lastArticles = client.get_last_articles(pageSize)
		
		
	end
	
	
	
	
	
	def article
		# params
		articleIdName = params[:idname]
		# get article
		client = ShcoderHelper::ShcoderManager.new
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
