

class AuthController < BaseController
	before_filter :authorize
	

	# Авторизация пользователя
	def user_login
		data = get_auth_params()
		@user = get_user_manager().authenticate(data[:name], data[:pass])
		if !@user.nil?
			flash['user_logined_now'] = t('auth_welcome_text', :name => @user.name);
			current_user_to_session()
			current_user_to_cookie()
			redirect_to root_url
			return
		end
		flash['user_logined_now'] = t('auth_welcome_err');
		flash['user_logined_error'] = 1;
		redirect_to root_url
	end
	# Выход пользователя
	def user_destroy
		user_session_clear()
		user_cookie_clear()
		redirect_to root_url
	end

	


	protected

		# манагер пользователями
		def get_user_manager
			if (@userManager.nil?) 
				@userManager = AuthHelper::UserManager.new method(:log_auth)
			end
			return @userManager
		end



	private

		# в сессию
		def current_user_to_session
			session[:current_user_id] = @user.id
		end
		# текущий пользователь из сессии
		def current_user_from_session
			return nil
			@user ||= session[:current_user_id] && get_user_manager().find_by(session[:current_user_id])
			return @user
		end
		# очистка сессии
		def user_session_clear
			@user = session[:current_user_id] = nil
		end

		# в куки
		def current_user_to_cookie
			if (!@user || @user.nil?) then return end
			cook_user = cookie_user_parse_to()
			cookies.signed[:zka] = { 
				value: cook_user, 
				expires: 1.year.from_now,
				domain: :all
			}
		end
		# текущий пользователь из кук
		def current_user_from_cookie
			cook = cookie_user_parse_from()
			if (cook.nil?) then return nil end
			@user ||= get_user_manager().find_by(cook[:userId])
			if (!@user.nil?)
				# проверяем дату создания куки
				cookDateStr = cook[:cookDate]
				if (cookDateStr.nil?) 
					user_cookie_clear()
					return nil 
				end
				# сверяем дату
				begin
					if (!@user.check_cookdate(cookDateStr))
						user_cookie_clear()
						return nil
					end
				rescue => e
					user_cookie_clear()
					return nil
				end
			end
			return @user
		end
		# очистка куков
		def user_cookie_clear
			cookies.delete :zka
		end
		# id пользователя для кук
		def cookie_user_parse_to
			userId = @user.id
			dd = Time.now.strftime("%d.%m.%Y")
			cook_user = "#{userId}||#{dd}"
			return cook_user
		end
		# id пользователя из кук
		def cookie_user_parse_from
			if (!cookies.signed[:zka]) then return nil end
			userId = nil
			cookDate = nil
			begin
				cook_user = cookies.signed[:zka]
				u = cook_user.split("||")
				userId = u[0]
				cookDate = u[1] #дата создания куки
			rescue
				userId = nil
				cookDate = nil
			end
			return { userId: userId, cookDate: cookDate };
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
			ub = params[:ub];
			un2 = params[:un2];
			up2 = params[:up2];

			#flash['unns'] = "un: #{un}; up: #{up}; un2: #{un2}; up2: #{up2}; ub: #{ub}";
			# TODO: расшифровка после скрипта
			if (un2 && up2)
				un = un2
				up = up2
			end

			return { name: un, pass: up };
		end

end