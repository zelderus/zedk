


#
# Сервис сайта
#
class SiteService

	attr_accessor :id, :code, :title, :sort

	def initialize()
		@sort = 99
		
	end


	# На основе данных из базы
	def from_entity entity
		if (entity.nil?) then return end
		@id = entity['Id']
		@code = entity['Code']
		@title = entity['Title']
		@sort = entity['SortOrder']

	end


end