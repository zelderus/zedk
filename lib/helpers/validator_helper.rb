

module ValidatorHelper



	# Строка пустая или не существует
	def self.stringIsNullOrEmpty str
		return str.to_s.strip.length == 0;
	end

	# Является числом
	def self.is_number? str
		true if Float(str) rescue false
	end



end