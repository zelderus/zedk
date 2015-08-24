

class ProjectorController < ApplicationController



	def index
		# page
		set_title(t('projector_headers_title'))
		set_headers(t('projector_headers_keyword'), t('projector_headers_desc'))
		#add_js('shcoder')
		set_menu([ ['Projector'] ])


	end
	
	

	
	
	


end
