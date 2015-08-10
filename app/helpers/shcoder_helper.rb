require "clients/shcoder_client"
require "shcoder/shcoder_article"

module ShcoderHelper


	class ShcoderManager
		def initialize()
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
			article = ::ShcoderArticle.new
			article.from_entity entity
			return article
		end
		
		
	  
	  private

		# метод при ошибке запросов
		def on_error e
			@deb = e.to_s
		end
	end


end
