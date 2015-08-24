

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
	
	
	
	
	#
	# => Конкретная статья
	#
	def article
		# params
		articleIdName = params[:idname]
		# get article
		client = ShcoderHelper::ShcoderManager.new
		@article = client.get_article_by_idname(articleIdName)
		if (@article.nil?)
			error_404()
			return
		end
		# page
		set_title(@article.title)
		set_headers(@article.title, @article.teaser)
		add_js('shcoder')
		set_menu([ ['Shcoder', '/shcoder'], [@article.title, ''] ])
	end


	#
	# => Форма редактирования статьи
	#
	def edit_article
		# permission
		if (!ShcoderHelper.user_access(@user))
			error_404()
			return
		end
		@article = ::ShcoderArticle.new
		# params
		articleIdName = params[:idname]
		if (!articleIdName.nil?)
			# get article
			client = ShcoderHelper::ShcoderManager.new
			@article = client.get_article_by_idname(articleIdName)
			if (@article.nil?)
				error_404()
				return
			end
			# permission
			if (!ShcoderHelper.user_access_article(@user, @article))
				error_404()
				return
			end
			set_title(@article.title)
			set_headers(@article.title, @article.teaser)
			set_menu([ ['Shcoder', '/shcoder'], [@article.title, ''] ])
		else
			set_title(t('shcoder_headers_title'))
			set_headers(t('shcoder_headers_keyword'), t('shcoder_headers_desc'))
			set_menu([ ['Shcoder', '/shcoder'], [t('shcoder_menu_add'), ''] ])
		end
		# page
		add_js('shcoder')




	end
	
	
	


end
