
module Conventions

	# Флаги ролей у сервисов
	module ServiceRoles
		READ 	= 1
		WRITE	= 2
	end

	# Сервисы
	module ServiceNames
		Shcoder 	= 'Shcoder'
		Projector	= 'Projector'

	end

	# Константные данные сервисов
	module ServiceData
		# маршрут к сервису
		def self.service_url serviceCode
			return {controller: serviceCode.downcase, action: 'index'}
		end

	end


end