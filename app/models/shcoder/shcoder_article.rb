
########################
#
# 		Тизер статьи
#
########################
class ShcoderArticleTeaser
	attr_accessor :title, :teaser, :idname, :date, :creatorId, :lastModificatorId

	def initialize()

	end

	# на основе сущности
	def from_entity entity
		@idname = entity['IdName']
		@title = entity['Title']
		@teaser = entity['Teaser']
		@creatorId = entity['UserCreator_ID']
		@lastModificatorId = entity['UserLastModificator_ID']
		@date = Date.parse(entity['CreateDate']).strftime('%d.%m.%Y')
	end
end

########################
#
# 	Полные данные статьи
#
########################
class ShcoderArticle < ShcoderArticleTeaser
	attr_accessor :isNew, :text
  
  	def initialize(entity = nil)
  		@isNew = true
  		if (!entity.nil?) then from_entity entity end

	end


  	# на основе сущности
	def from_entity entity
		super entity
		@isNew = false
		@text = entity['Text']
	end

	# Конкретный пользователь является создателем
	def is_user_creator user
		return @creatorId == user.id
	end


end
