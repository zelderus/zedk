
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

		# Самый главный админ
		def have_grand_access
			# TODO: права пользователя на сайт (админ)
			return false
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
			# services data to model
			entity.each do |r| 
				rid = r['ServiceId']
				sd = @services.find {|s| s.id == rid}
				if (sd.nil?)
					sd = SiteUserServiceData.new
					sd.id = rid
					sd.code = r['ServiceCode']
					sd.title = r['ServiceName']
					@services.push sd
				end
				sd.flags = sd.flags | r['ServiceRoleFlag'].to_i
			end
			@size = @services.count
		end

		# Флаги сервиса (Conventions::ServiceNames::)
		def get_flags serviceCode
			sd = @services.find { |s| s.code == serviceCode }
			if (sd.nil?) then return 0 end
			return sd.flags
		end
		# Есть права на чтение (Conventions::ServiceNames::)
		def have_read serviceCode
			flags = get_flags serviceCode
			return (flags & Conventions::ServiceRoles::READ) == Conventions::ServiceRoles::READ
		end
		# Есть права на запись (Conventions::ServiceNames::)
		def have_write serviceCode 
			flags = get_flags serviceCode
			return (flags & Conventions::ServiceRoles::WRITE) == Conventions::ServiceRoles::WRITE
		end




	end


	#
	# Данные сервиса пользователя
	#
	class SiteUserServiceData
		attr_accessor :id, :code, :title, :flags

		def initialize()
			@flags = 0
		end

		

	end



end