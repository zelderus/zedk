module ApplicationHelper
	
	# Returns the full title on a per-page basis.
	def full_title()
		base_title = "ZeDK"
		if (@maintitle.nil? || @maintitle.empty?)
			base_title
		else
			"#{base_title}. #{StringHelper.removeTags(@maintitle)}"
		end
	end
	# meta autor
	def get_autor
		html = "";
		if (!@autor.nil? && !@autor.empty?) then html += "<meta content='#{StringHelper.removeTags(@autor)}' name='author' />" end
		return html.html_safe
	end
	# headers
	def get_headers
		html = "";
		if (!@keyword.nil? && !@keyword.empty?) then html += "<meta content='#{StringHelper.removeTags(@keyword)}' name='keywords' />" end
		if (!@desc.nil? && !@desc.empty?) then html += "<meta content='#{StringHelper.removeTags(@desc)}' name='description' />" end
		
		return html.html_safe
	end

	# menu
	def has_menu
		return !@menus.nil?
	end
	def get_menus
		if (!has_menu) then return end
		@menus.each do |mn|
			yield mn
		end
	end
	
	# styles
	def get_csss
		if (@csss.nil?) then return end
		@csss.each do |css|
			yield css
		end
	end
	# scripts
	def get_jss
		if (@jss.nil?) then return end
		@jss.each do |js|
			#yield javascript_include_tag(js)
			yield js
		end
	end




  
end
