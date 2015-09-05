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
			load_extra_data(user)
			return user
		end

		# extra данные пользователя текущего
		def load_extra_data user
			if (user.nil?) then return end
			# services
			user.from_service_entity(@client.extra_services(user.id))
			# TODO: load other datas for user
		end


		private

			# ошибка запрсоа
			def on_error ex
				@onError.call(ex.to_s)
			end

			# hash пароля
			def pass_to_hash pass
				ph = Digest::SHA256.base64digest(pass)
				#sha256 = OpenSSL::Digest.new('MD5', 'digestdata')

				#secret = "sss_zld_83";
				#ph = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('md5'), secret, pass)
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