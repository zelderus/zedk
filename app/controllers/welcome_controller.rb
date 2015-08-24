class WelcomeController < ApplicationController
  
  
	def index
		set_title(t('main_headers_title'))
		set_headers(t('main_headers_keyword'), t('main_headers_desc'))


		# сервисы
		@services = get_site_manager().get_services();

	end





	private

		# манагер
		def get_site_manager
			if (@siteManager.nil?) 
				@siteManager = WelcomeHelper::SiteManager.new method(:log)
			end
			return @siteManager
		end



	
  
  
  
  
  
end
