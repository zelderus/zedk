require "datalayer/baseclient"
#require "models/shcoder/shcoder_article"

module Clients


	class ShcoderClient < DataLayer::BaseClient

		def initialize()
			init('services_data');
		end


		def get_last_articles(count = 10, onError=nil)
			#lastArticles = Hash.new
			
			sql = 'SELECT z.* FROM "tShcoder_Article" z order by "CreateDate" desc limit @top'
			req = DataLayer::Request.new
			req.set sql
			req.set_int("top", count)
			dts = raw_sql(req, onError)
			
			# to model
			#dts.each {|r| lastArticles[r['IdName']] = r['IdName'] }
			#lastArticles
			dts
		end
		
		
		def get_article_by_idname(idname, onError=nil)
			articleIdName = idname
			# sql
			sql = 'SELECT z.* FROM "tShcoder_Article" z Where z."IdName" = @idname limit 1;'
			req = DataLayer::Request.new
			req.set sql
			req.set_str("idname", articleIdName)
			dts = raw_sql(req, onError)
			if (dts.nil? || dts.count <= 0) then return nil end
			entity = dts[0]
			
			# to model
			#article = ::ShcoderArticle.new
			#article.name = entity['Title']
			#article.teaser = entity['Teaser']
			#return article
			return entity;
		end




	end



end
