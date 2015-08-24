require "datalayer/baseclient"
#require "models/shcoder/shcoder_article"

module Clients


	class SiteClient < DataLayer::BaseClient

		def initialize()
			init('site_data');
		end

		# данные по сервисам
		def get_services(onError=nil)
			req = DataLayer::Request.new
			req.set '
				SELECT 
					"tSite_Services"."Id" AS "Id", 
					"tSite_Services"."Title" AS "Title", 
					"tSite_Services"."SortOrder" AS "SortOrder", 
					"tSite_Services"."Code" AS "Code"
				FROM 
					public."tSite_Services"
				ORDER BY
					"tSite_Services"."SortOrder" ASC;
			'
			dts = raw_sql(req, onError)
			return dts;
		end




	end



end
