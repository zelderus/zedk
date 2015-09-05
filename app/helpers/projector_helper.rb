require "site/service"
require "clients/site_client"



module ProjectorHelper


	#
	# => Управление
	#
	class ProjectorManager

		def initialize(onError)
			#@client = Clients::SiteClient.new 
			#@onError = onError
		end



		



		private

			# ошибка запрсоа
			def on_error ex
				@onError.call(ex.to_s)
			end



	end


end
