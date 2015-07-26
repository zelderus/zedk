require "datalayer/baseclient"
require "models/shcoder/shcoder_article"

module Clients


	class ShcoderClient < DataLayer::BaseClient

		def initialize()
			init('some_raw_data');
		end


		def get_last_articles(count = 10, onError=nil)
			lastArticles = Hash.new
			#lastArticles['Arttt1'] = 'Article 1'
			#lastArticles['Arttt2'] = 'Article 2'
			#lastArticles['Arttt3'] = 'Article 3'
			
			sql = 'SELECT z.* FROM "Shcoder_Article" z order by "Name" desc limit @top'
			req = DataLayer::Request.new
			req.set sql
			req.set_int("top", count)
			dts = raw_sql(req, onError)
			
			# to model
			dts.each {|r| lastArticles[r['IdName']] = r['Name'] }
			lastArticles
		end
		
		
		def get_article_by_idname(idname, onError=nil)
			articleIdName = idname
			# sql
			sql = 'SELECT z.* FROM "Shcoder_Article" z Where z."IdName" = @idname limit 1;'
			req = DataLayer::Request.new
			req.set sql
			req.set_str("idname", articleIdName)
			dts = raw_sql(req, onError)
			if (dts.nil? || dts.count <= 0) then return nil end
			entity = dts[0]
			
			# to model
			article = ::ShcoderArticle.new
			article.name = entity['Name']
			article.teaser = entity['Teaser']
			
			
			return article
		end




	end



end
