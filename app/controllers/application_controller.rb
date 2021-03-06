# encoding: utf-8

require "protocols/json"
require "helpers/string_helper"

class ApplicationController < AuthController
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	# установка заголовка странице
	def set_title(title)
		@maintitle = title
	end
	# метатег автор
	def set_autor(name)
		@autor = name
	end
	# метатеги
	def set_headers(keyword, desc)
		@keyword = keyword
		@desc = desc
	end
	
	# меню
	def set_menu(hashMenu)
		@menus = hashMenu #Hash.new
		
	end

	# подключение стилей на страницу
	def add_css(cssname, isExcplicitLink=false)
		@csss ||= []
		cssname = cssname.downcase
		if (!isExcplicitLink && !cssname.start_with?("widgets/")) then cssname = 'widgets/' + cssname end
		if (@csss.include?(cssname)) then return end
		@csss.push(cssname)
	end
	# подключение скриптов на страницу
	def add_js(jsname, isExcplicitLink=false)
		@jss ||= []
		jsname = jsname.downcase
		if (!isExcplicitLink && !jsname.start_with?("widgets/")) then jsname = 'widgets/' + jsname end
		if (@jss.include?(jsname)) then return end
		@jss.push(jsname)
	end


	# отправка JSON ответа
	def send_json(json)
		if (!json.is_a? JsonResponse) then raise "Object is not a JsonResponse" end
		respond_to do |format|
		  format.json { render json: { JsonZedk: json.JsonZedk, Success: json.Success, Model: json.Model, Message: json.Message  } }
		end
	end

end
