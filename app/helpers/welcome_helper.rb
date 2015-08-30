require "site/service"
require "clients/site_client"



module WelcomeHelper


	#
	# => Управление сайтом
	#
	class SiteManager

		def initialize(onError)
			@client = Clients::SiteClient.new 
			@onError = onError
		end



		# данные по сервисам
		def get_services()
			dts = @client.get_services(method(:on_error))
			services = []
			if (dts.nil?) then return services end
			dts.each do |e| 
				ss = SiteService.new
				ss.from_entity e
				services.push ss
			end
			return services
		end



		private

			# ошибка запрсоа
			def on_error ex
				@onError.call(ex.to_s)
			end



	end


end
