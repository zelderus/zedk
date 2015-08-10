
########################
#
# 		Тизер статьи
#
########################
class ShcoderArticleTeaser
	attr_accessor :title, :teaser, :idname, :date

	def initialize()

	end

	# на основе сущности
	def from_entity entity
		@idname = entity['IdName']
		@title = entity['Title']
		@teaser = entity['Teaser']
		@date = Date.parse(entity['CreateDate']).strftime('%d.%m.%Y')
	end
end

########################
#
# 	Плные данные статьи
#
########################
class ShcoderArticle < ShcoderArticleTeaser
	attr_accessor :text
  
  	def initialize(entity = nil)
  		if (!entity.nil?) then from_entity entity end

	end


  	# на основе сущности
	def from_entity entity
		super entity
		@text = entity['Text']
	end
end
