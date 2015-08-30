require "datalayer/baseclient"
require "models/shcoder/shcoder_article"

module Clients


	class ShcoderClient < DataLayer::BaseClient

		def initialize()
			init('services_data');
		end


		def get_last_articles(count = 10, onError=nil)
			#lastArticles = Hash.new
			sql = 'SELECT z.* FROM "tShcoder_Article" z order by "CreateDate" desc limit @top;'
			req = DataLayer::Request.new
			req.set sql
			req.set_int("top", count)
			dts = raw_sql(req, onError)
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
			return entity;
		end

		def get_article_by_id(id, onError=nil)
			# sql
			sql = 'SELECT z.* FROM "tShcoder_Article" z Where z."Id" = @idname limit 1;'
			req = DataLayer::Request.new
			req.set sql
			req.set_str("idname", id)
			dts = raw_sql(req, onError)
			if (dts.nil? || dts.count <= 0) then return nil end
			entity = dts[0]
			return entity;
		end


		# редактирование статьи
		def edit_article(article, onError=nil)
			if (article.nil?) then return false end
			if (!article.isNew)
				# EDIT
				exist = get_article_by_id(article.id, onError)
				if (exist.nil?) then return false end
				req = DataLayer::Request.new
				req.set '
				UPDATE "tShcoder_Article"
   				SET 
   					"Title"=@title, 
   					"Teaser"=@teaser, 
   					"Text"=@text, 
       				"UserLastModificator_ID"=@modificatorId,
       				"ModificateDate"=@modificateDate
 				WHERE "Id"=@id;
				'
				req.set_str("id", article.id)
				req.set_str("modificateDate", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
				req.set_str("title", article.title)
				req.set_str("teaser", article.teaser)
				req.set_str("text", article.text)
				req.set_str("modificatorId", article.lastModificatorId)

				dts = raw_sql(req, onError)
				if (is_succ_response(dts)) then return true end
			else
				# CREATE
				req = DataLayer::Request.new
				req.set '
				INSERT INTO "tShcoder_Article"(
            		"Id", 
            		"CreateDate", 
            		"Title", 
            		"Teaser", 
            		"Text", 
            		"IdName", 
            		"UserCreator_ID", 
            		"UserLastModificator_ID")
    			VALUES (
    				@id, 
    				@createDate, 
    				@title, 
    				@teaser, 
    				@text, 
    				@idname, 
    				@creatorId, 
            		@modificatorId
            	);
				'
				req.set_str("id", article.id)
				req.set_str("createDate", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
				req.set_str("title", article.title)
				req.set_str("teaser", article.teaser)
				req.set_str("text", article.text)
				req.set_str("idname", article.idname)
				req.set_str("creatorId", article.creatorId)
				req.set_str("modificatorId", article.lastModificatorId)

				dts = raw_sql(req, onError)
				if (is_succ_response(dts)) then return true end
			end

			return false
		end

		# существующие такие названия
		def exist_article_idname(idname, onError=nil)
			# sql
			req = DataLayer::Request.new
			req.set 'SELECT "IdName" FROM "tShcoder_Article" WHERE "IdName" LIKE @idname;'
			req.set_str("idname", idname)
			dts = raw_sql(req, onError)
			return dts;
		end



	end



end
