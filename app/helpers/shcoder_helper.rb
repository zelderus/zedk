require "clients/shcoder_client"


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
			articles = @client.get_last_articles(count, method(:on_error))
			return articles
		end

		# статья
		def get_article_by_idname(idname)
			@client.get_article_by_idname(idname, method(:on_error))
		end
		
		
	  
	  private

		# метод при ошибке запросов
		def on_error e
			@deb = e.to_s
		end
	end


end
