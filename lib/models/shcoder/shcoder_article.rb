
########################
#
# 		Тизер статьи
#
########################
class ShcoderArticleTeaser
	attr_accessor 	:id, 
					:title, 
					:teaser, 
					:idname, 
					:category, :categoryIdname,
					:autor, :lastAutor,
					:dateDate, :date, :lastDateDate, :lastDate, 
					:creatorId, :lastModificatorId

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

		# TODO
		@category = "cat";
		@categoryIdname = "cattest";

		@autor = entity['UserName']
		@lastAutor = entity['LastUserName']

		@dateDate = Date.parse(entity['CreateDate']);
		@date = @dateDate.strftime('%d.%m.%Y')

		@lastDateDate = entity['ModificateDate'].nil? ? nil : Date.parse(entity['ModificateDate']);
		@lastDate = @lastDateDate.nil? ? '' : @lastDateDate.strftime('%d.%m.%Y')
	end

	# ссылка на статью внутри сайта
	def get_link
		Rails.application.routes.url_helpers.url_for(controller: 'shcoder', action: 'article', idname: @idname, only_path: true) 
	end
	def get_category_link
		Rails.application.routes.url_helpers.url_for(controller: 'shcoder', action: 'category', idname: @categoryIdname, only_path: true) 
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
