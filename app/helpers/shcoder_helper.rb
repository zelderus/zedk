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
	# Пользователь имеет доступ к статье
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
		def get_last_articles(count = 10)
			dts = @client.get_last_articles(count, method(:on_error))
			# to model
			lastArticles = Array.new
			dts.each do |r| 
				article = ::ShcoderArticleTeaser.new
				article.from_entity r
				lastArticles.push article
			end
			return lastArticles
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


		
	  
	  private

		# метод при ошибке запросов
		def on_error e
			@deb = e.to_s
			@onError.call(e.to_s)
		end
		
	end


end
