
module AuthHelper

	# Пользователь системы
	class SiteUser
		attr_accessor :id, :idname, :name, :activated, :cookDate

		def initialize()
			@cookDate = nil
			
		end


		# На основе данных из базы
		def from_entity entity
			# TODO: user to model
			@id = entity["Id"];
			@idname = entity["IdName"];
			@name = entity["Name"];
			init_cookdate(entity["CookDate"]);
			
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



end