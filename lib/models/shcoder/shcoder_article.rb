
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
					:categoryObj,
					:autor, :lastAutor,
					:dateDate, :date, :lastDateDate, :lastDate, 
					:creatorId, :lastModificatorId

	def initialize()
		@categoryObj = ShcoderCategory.new
	end

	# на основе сущности
	def from_entity entity
		@id = entity['Id']
		@idname = entity['IdName']
		@title = entity['Title']
		@teaser = entity['Teaser']
		@creatorId = entity['UserCreator_ID']
		@lastModificatorId = entity['UserLastModificator_ID']

		@categoryObj = ShcoderCategory.new entity
		
		@autor = entity['UserName']
		@lastAutor = entity['LastUserName']

		@dateDate = Date.parse(entity['CreateDate']);
		@date = @dateDate.strftime('%d.%m.%Y')

		@lastDateDate = entity['ModificateDate'].nil? ? nil : Date.parse(entity['ModificateDate']);
		@lastDate = @lastDateDate.nil? ? '' : @lastDateDate.strftime('%d.%m.%Y')
	end

	def category
		if (@categoryObj.nil?) then @categoryObj = ShcoderCategory.new end
		return @categoryObj
	end

	# ссылка на статью внутри сайта
	def get_link
		Rails.application.routes.url_helpers.url_for(controller: 'shcoder', action: 'article', idname: @idname, only_path: true) 
	end
	def get_category_link
		return @categoryObj.nil? ? "" : @categoryObj.get_link()
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
  		super()
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


########################
#
# 	Категория
#
########################
class ShcoderCategory
	attr_accessor :id, :idname, :title

	def initialize(entity = nil)
  		if (!entity.nil?) then from_entity entity end

	end

  	# на основе сущности
	def from_entity entity
		@id = entity['CategoryId'];
		@title = entity['CategoryTitle'];
		@idname = entity['CategoryIdName'];
	end

	# ссылка на статью внутри сайта
	def get_link
		Rails.application.routes.url_helpers.url_for(controller: 'shcoder', action: 'category', idname: @idname, only_path: true) 
	end

end