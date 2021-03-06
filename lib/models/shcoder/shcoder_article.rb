
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
					:category,
					:autor, :lastAutor,
					:dateDate, :date, :lastDateDate, :lastDate, :modDate,
					:creatorId, :lastModificatorId, :creatorName

	def initialize()
		@category = ShcoderCategory.new
	end

	# на основе сущности
	def from_entity entity
		@id = entity['Id']
		@idname = entity['IdName']
		@title = entity['Title']
		@teaser = entity['Teaser']
		@creatorId = entity['UserCreator_ID']
		@creatorName = entity['UserName']
		@lastModificatorId = entity['UserLastModificator_ID']

		@category = ShcoderCategory.new entity
		
		@autor = entity['AutorName']
		if (@autor.nil?) then @autor = @creatorName end

		@lastAutor = entity['LastUserName']

		@dateDate = Date.parse(entity['CreateDate']);
		@date = @dateDate.strftime('%d.%m.%Y')

		@lastDateDate = entity['ModificateDate'].nil? ? nil : Date.parse(entity['ModificateDate']);
		@lastDate = @lastDateDate.nil? ? '' : @lastDateDate.strftime('%d.%m.%Y')
		@modDate = entity['ModificateDate'].nil? ? @dateDate : Date.parse(entity['ModificateDate']);
	end


	# ссылка на статью внутри сайта
	def get_link
		Rails.application.routes.url_helpers.url_for(controller: 'shcoder', action: 'article', idname: @idname, only_path: true) 
	end
	def get_category_link
		return @category.get_link()
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