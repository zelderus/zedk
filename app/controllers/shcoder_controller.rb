

class ShcoderController < ApplicationController



	def index
		set_title(t('shcoder_headers_title'))
		set_headers(t('shcoder_headers_keyword'), t('shcoder_headers_desc'))
		add_js('shcoder')
		
		

	end


end
