require "auth/auth_user"
require "clients/auth_client"

module LogHelper

	#
	# Манагер логирования
	#
	class LogManager

		def initialize()
			
		end

		# Лог общий
		def log msg
			log_to_file('errors', msg) 
		end


		# Лог при авторизации
		def log_auth msg
			log_to_file('errors_auth', msg)
		end



		private

			# Лог напрямую в файл
			def log_to_file file, msg
				file = "./log/#{file}.log"
				date = Time.now
				dateStr = date.strftime("%d.%m.%Y %H:%M:%S")
				msg = "\n--> #{dateStr}:\n#{msg}\n"
				# в файл
				File.open(file, "a") do |f|
				  f.write(msg)
				end
			end



	end


end