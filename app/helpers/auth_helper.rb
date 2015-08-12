require "auth/auth_user"
#require "clients/shcoder_client"

module AuthHelper

	#
	# Манагер пользователями
	#
	class UserManager

		def initialize()

		end

		# определение пользователя
		def authenticate userName, userPass
			# TODO: определение пользователя

			return false;
		end

		# пользователь
		def find_by id
			# TODO: поиск пользователя в базе по ID
			@user = AuthHelper::SiteUser.new
			@user.name = 'user 1';

			return @user
		end


	end


end