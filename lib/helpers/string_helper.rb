# encoding: utf-8



module StringHelper

	#
	# => Проверка строк лежит рядом в ValidatorHelper
	#


	def self.downcase str
		if (str.nil?) then return str end
		str.mb_chars.downcase;
	end

	def self.upcase str
		if (str.nil?) then return str end
		str.mb_chars.upcase;
	end
	

	
	# обрезание строки
	def self.trimMaxSize str, maxSize, omission='...'
		if (str.nil?) then return str end
		#str = truncate(str, :length => maxSize, :omission => omission)
		str = str[0, maxSize]
		return str
	end





	# Транслит строки
	def self.translateRusToEng(value)
		if (value.nil?) then return value end
        value = StringHelper.upcase value;
        value = value.gsub("А", "A");
        value = value.gsub("Б", "B");
        value = value.gsub("В", "V");
        value = value.gsub("Г", "G");
        value = value.gsub("Д", "D");
        value = value.gsub("Е", "E");
        value = value.gsub("Ё", "E");
        value = value.gsub("Ж", "ZH");
        value = value.gsub("З", "Z");
        value = value.gsub("И", "I");
        value = value.gsub("Й", "I");
        value = value.gsub("К", "K");
        value = value.gsub("Л", "L");
        value = value.gsub("М", "M");
        value = value.gsub("Н", "N");
        value = value.gsub("О", "O");
        value = value.gsub("П", "P");
        value = value.gsub("Р", "R");
        value = value.gsub("С", "S");
        value = value.gsub("Т", "T");
        value = value.gsub("У", "U");
        value = value.gsub("Ф", "F");
        value = value.gsub("Х", "H");
        value = value.gsub("Ц", "C");
        value = value.gsub("Ч", "CH");
        value = value.gsub("Ш", "SH");
        value = value.gsub("Щ", "SCH");
        value = value.gsub("Ъ", "'");
        value = value.gsub("Ы", "Y");
        value = value.gsub("Ь", "");
        value = value.gsub("Э", "E");
        value = value.gsub("Ю", "YU");
        value = value.gsub("Я", "YA");
        return value;
    end

    # Транслит строки и привод к Url формату
    def self.toUrlPath(value)
        if (value.nil?) then return value end
        value = translateRusToEng(value);
        if (value.nil?) then return value end
        value = StringHelper.downcase value;
        value = value.gsub(/[^a-z- 0-9 \/]+/, "");
        value = value.gsub(" ", "_");
        value = value.gsub(/-+/, "_");
        value = value.gsub(/^-+|-+$/, "");
        return value;
    end



    # Удаление всех тэгов
    def self.removeTags(value)
        str = value
        str = StringHelper.cleanHtmlComments(str);
        str = StringHelper.cleanHtmlBehaviour(str);
        str = str.gsub(/<[^>]+?>/, "");
        #value = value.trim();
        return str;
    end

    # Удаляет тэги
    def self.cleanHtml(value)
        value = StringHelper.cleanHtmlComments(value);
        value = StringHelper.cleanHtmlBehaviour(value);
        # Remove disallowed html tags.
        value = value.gsub(/<?(param|(no)?script|object|i?frame|body|style|font|head|link|title|h1)[^>]*?>/, "");
        # Remove disallowed attributed.
        #value = RemoveHtmlAttribute(value, "style");
        # Replace links
        value = value.gsub(/<a[^>]+href=\"?'?([^'\">]+)\"?'?[^>]*>(.*?)<\/a>/, "<a href=\"$1\" rel=\"nofollow\" target=\"_blank\">$2</a>");
        return value;
    end

    # Удаляет тэги скриптов и стилей
    def self.cleanHtmlBehaviour(value)
        value = value.gsub(/(<style.+?<\/style>)|(<script.+?<\/script>)/, "");
        return value;
    end

    # Удаляет тэги скриптов
    def self.cleanHtmlScripts(value)
        value = value.gsub(/(<script.+?<\/script>)/, "");
        return value;
    end

    #
    def  self.cleanHtmlComments(value)
        value = value.gsub(/<!--.+?-->/, "");
        return value;
    end


    # Удаляет ненужные символы
    def self.cleanBadSymbols(value)
        value = value.gsub(/[\/\,;<>']+/, "");
        return value;
    end


end