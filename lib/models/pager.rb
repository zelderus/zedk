
########################
#
# 		Pager
#
########################
class Pager
	attr_accessor 	:page, 
					:pageSize, 

					:total,
					:pageCount,

					:haveNextPage,
					:havePrevPage,

					:offset

	def initialize()
		@page = 1;
		@pageSize = 10;
		@total = 0;
		@pageCount = 0;
		@offset = 0;
		@haveNextPage = false;
		@havePrevPage = false;
	end

	# инициализация
	def init(currentPage=1, pageSize=10)
		@page = currentPage.to_i;
		@pageSize = pageSize.to_i;
	end
	# установка общего количества
	def init_total(total)
		@total = total.to_i;
		update();
	end

	# обновление актуальных данных
	def update
		@pageCount = (((@total - 1) / @pageSize) + 1).to_i;
		if (@page > @pageCount) then @page = @pageCount end

		@offset = (@page-1) * @pageSize;
		@offset = @offset < 0 ? 0 : @offset;

		@havePrevPage = @page-1 > 0;
		@haveNextPage = @page < @pageCount;
	end
	

end
