
module AuthHelper

	#
	# Пользователь системы
	#
	class SiteUser
		attr_accessor :id, :idname, :name, :activated, :cookDate, :service

		def initialize()
			@cookDate = nil
			@service = SiteUserService.new

		end


		# На основе данных из базы
		def from_entity entity
			# TODO: user to model
			@id = entity["Id"];
			@idname = entity["IdName"];
			@name = entity["Name"];
			init_cookdate(entity["CookDate"]);
			
		end

		# Данные по сервисам из базы
		def from_service_entity entity
			@service.from_entity entity
		end


		
		# Возвращает true, если дата кук не устарела
		# dateStr - формата '31.12.2015'
		def check_cookdate dateStr
			if (@cookDate.nil?) then return true end
			cd = dateStr.split(".")
			compareDate = Date.parse("#{cd[0]}-#{cd[1]}-#{cd[2]}")
			return @cookDate <= compareDate
		end



		private

			# Получение даты последней возможной куки авторизации из базы
			def init_cookdate dateStr
				if (dateStr.nil?) then return end
				begin
					cd = dateStr.split(".") # 31.12.2015
					@cookDate = Date.parse("#{cd[0]}-#{cd[1]}-#{cd[2]}")
				rescue
					@cookDate = nil # в базе не может лежать неверное значение
				end
			end

	end


	#
	# Данные по сервисам к пользователю
	#
	class SiteUserService
		attr_accessor :size, :services

		def initialize()
			@size = 0
			@services = []
		end

		# На основе данных из базы
		def from_entity entity
			if (entity.nil?) then return end
			# TODO: services data to model
			@size = entity.count
			entity.each do |r| 
				sd = SiteUserServiceData.new
				# TODO
				sd.id = r['ServiceId']
				sd.title = r['ServiceName']
				sd.role = r['ServiceRoleId']

				@services.push sd
			end
		end

		def debug
			return @services[0].title
		end


	end


	#
	# Данные сервиса пользователя
	#
	class SiteUserServiceData
		attr_accessor :id, :title, :role

		def initialize()
			
		end

		

	end



end