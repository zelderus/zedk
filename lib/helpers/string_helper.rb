

module StringHelper

	#
	# => Проверка строк лежит рядом в ValidatorHelper
	#


	# перевод строки
	def self.translateRusToEng str
		if (str.nil?) then return str end
		# TODO

		return str
	end


	# обрезание строки
	def self.trimMaxSize str, maxSize, omission='...'
		if (str.nil?) then return str end
		#str = truncate(str, :length => maxSize, :omission => omission)
		str = str[0, maxSize]
		return str
	end

end