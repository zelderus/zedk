

class AuthController < BaseController
	before_filter :authorize
	

	# "Create" a login, aka "log the user in"
	def user_login
		data = get_auth_params()
		@user = get_user_manager().authenticate(data['name'], data['pass'])
		if !@user.nil?
			flash['user_logined_now'] = t('auth_welcome_text', :name => @user.name);
			current_user_to_session()
			current_user_to_cookie()
			redirect_to root_url
		end
	end
	# "Delete" a login, aka "log the user out"
	def user_destroy
		user_session_clear()
		user_cookie_clear()
		redirect_to root_url
	end

	


	protected

		# манагер пользователями
		def get_user_manager
			if (@userManager.nil?) then @userManager = AuthHelper::UserManager.new end
			return @userManager
		end



	private

		# в сессию
		def current_user_to_session
			session[:current_user_id] = @user.id
		end
		# текущий пользователь из сессии
		def current_user_from_session
			@user ||= session[:current_user_id] && get_user_manager().find_by(id: session[:current_user_id])
			to_d (session)

			@user
		end
		# очиска сессии
		def user_session_clear
			@user = session[:current_user_id] = nil
		end

		# в куки
		def current_user_to_cookie
			# TODO: пользователь в куки
			
		end
		# текущий пользователь из кук
		def current_user_from_cookie
			# TODO: текущий пользователь из кук
			@user = nil
		end
		# очиска куков
		def user_cookie_clear
			# TODO: очиска куков
			
		end


		# авторизация по кукам и сессии
		def authorize
			if (!@user.nil?) then return @user end;
			# сессия
			@user = current_user_from_session()
			if (!@user.nil?) then return @user end;
			# cookie
			@user = current_user_from_cookie()
			if (!@user.nil?)
				current_user_to_session()
			end
			return @user
		end

		# параметры аторизации присланные пользователем
		def get_auth_params
			un = params[:un];
			up = params[:up];
			# TODO: расшифровка после скрипта

			return { name: un, pass: up };
		end

end