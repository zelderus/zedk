require "clients/shcoder_client"
require "models/shcoder/shcoder_article"

module ShcoderHelper


	# Пользователь имеет права на запись в Шкодер
	def self.user_access user
		if (user.nil?) then return false end
		if (user.have_grand_access()) then return true end
		if (user.service.have_write(Conventions::ServiceNames::Shcoder)) then return true end
		return false
	end
	# Пользователь имеет доступ к статье на запись
	def self.user_access_article user, article
		if (!user_access user) then return false end
		if (user.have_grand_access()) then return true end
		return article.is_user_creator user
	end


	# Manager
	class ShcoderManager

		def initialize(onError)
			@onError = onError
			@deb = ""
			@client = Clients::ShcoderClient.new
		end
		# отладочная информация
		def get_deb
			#@client.get_errorno		
			@deb
		end


		# последние добавленные статьи
		def get_last_articles(offset=0, count=10, categoryId=nil)
			dts = @client.get_last_articles(offset, count, categoryId, method(:on_error))
			# to model
			lastArticles = Array.new
			if (dts.nil?) then return lastArticles end
			dts.each do |r| 
				article = ::ShcoderArticleTeaser.new
				article.from_entity r
				lastArticles.push article
			end
			return lastArticles
		end

		def get_last_articles_pager(page=1, pageSize=10, categoryId=nil)
			return @client.get_last_articles_pager(page, pageSize, categoryId, method(:on_error))
		end



		# статья
		def get_article_by_idname(idname)
			entity = @client.get_article_by_idname(idname, method(:on_error))
			if (entity.nil?) then return nil end
			# to model
			return ::ShcoderArticle.new entity
		end
		# статья
		def get_article_by_id(id)
			entity = @client.get_article_by_id(id, method(:on_error))
			if (entity.nil?) then return nil end
			# to model
			return ::ShcoderArticle.new entity
		end

		# редактирование статьи
		def edit_article(article)
			return @client.edit_article(article, method(:on_error))
		end

		# возвращает доступное уникальное название
		def generate_article_idname(idname)
			idname = idname.downcase;
			idnamework = idname
			ind = 1
			while true do
				names = @client.exist_article_idname(idnamework, method(:on_error))
				if (names.nil? || names.count == 0) then break end
				idnamework = "#{idname}_#{ind}"
				ind += 1
			end
			return idnamework;
		end


		# список категорий
		def get_categories()
			dts = @client.get_categories(method(:on_error))
			# to model
			categories = Array.new
			if (dts.nil?) then return categories end
			dts.each do |r| 
				category = ::ShcoderCategory.new r
				categories.push category
			end
			return categories
		end
		# категория
		def get_category id
			exist = @client.get_category(id, method(:on_error))
			if (exist.nil?) then return nil end
			return ::ShcoderCategory.new exist;
		end
		# возвращает доступное уникальное название
		def get_category_by_idname(idname)
			idname = idname.downcase;
			exist = @client.get_category_by_idname(idname, method(:on_error))
			if (exist.nil?) then return nil end
			return ::ShcoderCategory.new exist;
		end
		# создание категории
		def create_category(idname, title)
			category = ::ShcoderCategory.new;
			category.idname = idname.downcase;
			category.title = title;
			category.id = SecureRandom.uuid;
			return @client.create_category(category, method(:on_error))
		end

				
	  
	  private

		# метод при ошибке запросов
		def on_error e
			@deb = e.to_s
			@onError.call(e.to_s)
		end
		
	end


end
