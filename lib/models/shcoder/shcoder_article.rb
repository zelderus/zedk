
########################
#
# 		Тизер статьи
#
########################
class ShcoderArticleTeaser
	attr_accessor :id, :title, :teaser, :idname, :dateDate, :date, :lastDateDate, :lastDate, :creatorId, :lastModificatorId

	def initialize()

	end

	# на основе сущности
	def from_entity entity
		@id = entity['Id']
		@idname = entity['IdName']
		@title = entity['Title']
		@teaser = entity['Teaser']
		@creatorId = entity['UserCreator_ID']
		@lastModificatorId = entity['UserLastModificator_ID']

		@dateDate = entity['CreateDate'];
		@date = Date.parse(@dateDate).strftime('%d.%m.%Y')

		@lastDateDate = entity['ModificateDate'];
		@lastDate = @lastDateDate.nil? ? '' : Date.parse(entity['ModificateDate']).strftime('%d.%m.%Y')
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
