# encoding: utf-8


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
		# поиск
		@found = Array.new
		# Shcoder
		shcManager = get_shcoder_manager();
		@found.push({:title => 'Статьи', :values => shcManager.search_articles(@txt)});
		@found.push({:title => 'Категории статей', :values => shcManager.search_article_categories(@txt)});



	end





	private

		# манагер сайта
		def get_site_manager
			if (@siteManager.nil?) 
				@siteManager = WelcomeHelper::SiteManager.new method(:log)
			end
			return @siteManager
		end

		# manager шкодера
		def get_shcoder_manager
			if (@manager.nil?) then @manager = ShcoderHelper::ShcoderManager.new method(:log) end
			return @manager
		end
  
  
  
  
  
end
