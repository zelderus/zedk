require "auth/auth_user"
require "clients/auth_client"

module AuthHelper

	#
	# Манагер пользователями
	#
	class UserManager

		def initialize(onError)
			@client = Clients::AuthClient.new 
			@onError = onError
		end

		# определение пользователя
		def authenticate userName, userPass
			userId = @client.authenticate(userName, pass_to_hash(userPass), method(:on_error))
			user = find_by userId
			return user;
		end

		# пользователь
		def find_by id
			if (id.nil?) then return nil end
			entity = @client.find_by(id, method(:on_error))
			user = entity_user_to_model entity
			return user
		end


		private

			# ошибка запрсоа
			def on_error ex
				@onError.call(ex.to_s)
			end

			# hash пароля
			def pass_to_hash pass
				ph = Digest::SHA256.base64digest(pass)
				return ph
			end

			# данные пользователя в модель
			def entity_user_to_model entity
				if (entity.nil?) then return nil end
				user = AuthHelper::SiteUser.new
				user.from_entity entity;
				return user
			end


	end


end