require "helpers/validator_helper"
require "helpers/string_helper"

class ShcoderController < ApplicationController



	def index
		# page
		set_title(t('shcoder_headers_title'))
		set_headers(t('shcoder_headers_keyword'), t('shcoder_headers_desc'))
		add_js('shcoder')
		set_menu([ ['Shcoder'] ])
		# get articles
		pageSize = 10
		client = get_manager();
		@lastArticles = client.get_last_articles(pageSize)
	end
	
	
	
	
	#
	# => Конкретная статья
	#
	def article
		# params
		articleIdName = params[:idname]
		# get article
		client = get_manager();
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
			client = get_manager();
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
	


	#
	# => Непосредственно редактирование статьи
	#
	def edit_article_do
		response = JsonResponse.new
		response.Success = false;
		response.Model = { message: 'ok', errors: Hash.new };
		# permission
		if (!ShcoderHelper.user_access(@user))
			response.Model[:message] = 'access denied'
			send_json response
			return
		end
		client = get_manager();
		# статья из данных пришедших
		article = bind_article()
		# права на редактирование
		if (!article.isNew)
			exist = client.get_article_by_id(article.id)
			if (exist.nil?)
				response.Model[:message] = 'the article is not present'
				send_json response
				return
			end
			if (!ShcoderHelper.user_access_article(@user, exist))
				response.Model[:message] = 'access denied to the article'
				send_json response
				return
			end
		end
		# проверка пришедших данных
		response.Success = check_article(article, response.Model[:errors])
		if (!response.Success)
			response.Model[:message] = 'form error'
			send_json response
			return
		end

		# генерируем необходимые данные
		gen_article_data(article)

		# применяем в базе
		response.Success = client.edit_article(article)
		if (!response.Success)
			response.Model[:message] = 'error on submit.'
		end

		# отправляем
		send_json response
	end
	
	


	private

		# manager
		def get_manager
			if (@manager.nil?) then @manager = ShcoderHelper::ShcoderManager.new method(:log) end
			return @manager
		end

		# статья из данных пришедших через форму
		def bind_article
			article = ShcoderArticle.new
			article.id = params[:id];
			article.isNew = ValidatorHelper.stringIsNullOrEmpty(article.id);
			article.idname = params[:idname];
			article.title = params[:title];
			article.teaser = params[:teaser];
			article.text = params[:text];
			return article
		end

		# проверка статьи при редактировании
		def check_article article, errorsHash
			if (ValidatorHelper.stringIsNullOrEmpty(article.title)) then errorsHash['title'] = 'title must be' end
			if (ValidatorHelper.stringIsNullOrEmpty(article.teaser)) then errorsHash['teaser'] = 'teaser must be' end
			if (ValidatorHelper.stringIsNullOrEmpty(article.text)) then errorsHash['text'] = 'text must be' end
			return errorsHash.count <= 0
		end

		# необходимые данные для статьи
		def gen_article_data article
			if (article.isNew)
				article.id = SecureRandom.uuid;
				article.creatorId = @user.id;
				article.idname = gen_url_title(article.title)


			end
			article.lastModificatorId = @user.id;

		end

		# генерация url для статьи
		def gen_url_title articleTitle
			title = articleTitle
			urlTitle = StringHelper.translateRusToEng(title)
			urlTitle = urlTitle.gsub(" ", "")
			urlTitle = StringHelper.trimMaxSize(urlTitle, 10, '')
			urlTitle = urlTitle.downcase
			# TODO: проверить в базе на совпадение

			return urlTitle
		end

end
