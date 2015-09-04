class WelcomeController < ApplicationController
  
  	# корень
	def index
		set_title(t('main_headers_title'))
		set_headers(t('main_headers_keyword'), t('main_headers_desc'))
		# сервисы
		@services = get_site_manager().get_services();

	end

	# поиск
	def search
		set_title(t('main_headers_title'))
		set_headers(t('main_headers_keyword'), t('main_headers_desc'))
		@txt = params[:txt];
		# TODO: поиск
		

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
