require "datalayer/baseclient"
require "models/shcoder/shcoder_article"
require "models/pager"
require "helpers/string_helper"

module Clients


	class ShcoderClient < DataLayer::BaseClient

		def initialize()
			init('services_data');
		end


		def get_last_articles(offset=0, count=10, categoryId=nil, onError=nil)
			#lastArticles = Hash.new
			#sql = 'SELECT z.* FROM "tShcoder_Article" z order by "CreateDate" desc limit @top;'
			sql = get_sqlbody_findarticle();
			if (!categoryId.nil?) then sql += ' AND c."Id"=@categoryId ' end
			sql += 'order by "CreateDate" desc limit @top OFFSET @offset;'

			req = DataLayer::Request.new
			req.set sql
			req.set_str("categoryId", categoryId)
			req.set_int("top", count)
			req.set_int("offset", offset)
			dts = raw_sql(req, onError)
			dts
		end

		def get_last_articles_pager(page=1, pageSize=10, categoryId=nil, onError=nil)
			pager = ::Pager.new 
			pager.init(page, pageSize);
			# всего
			total = 0;
			sql = '
			SELECT COUNT(*) AS "TotalCount" 
			FROM public."tShcoder_Article" z 
			LEFT JOIN public."tShcoder_Category" c ON z."Category_ID"= c."Id"
			'
			if (!categoryId.nil?) then sql += ' WHERE c."Id"=@categoryId; ' end
			req = DataLayer::Request.new
			req.set sql
			req.set_str("categoryId", categoryId)

			dts = one_sql(req, onError);
			if (!dts.nil?) then total = dts['TotalCount'] end
			# корректная модель
			pager.init_total(total);
			return pager
		end
		
		
		def get_article_by_idname(idname, onError=nil)
			articleIdName = idname
			# sql
			sql = get_sqlbody_findarticle(); #'SELECT z.* FROM "tShcoder_Article" z Where z."IdName" = @idname limit 1;'
			sql += 'AND z."IdName" = @idname limit 1;';
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
			#sql = 'SELECT z.* FROM "tShcoder_Article" z Where z."Id" = @idname limit 1;'
			sql = get_sqlbody_findarticle();
			sql += 'AND z."Id" = @idname limit 1;';
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
       				"ModificateDate"=@modificateDate,
       				"Category_ID"=@categoryId
 				WHERE "Id"=@id;
				'
				req.set_str("id", article.id)
				req.set_str("modificateDate", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
				req.set_str("title", article.title)
				req.set_str("teaser", article.teaser)
				req.set_str("text", article.text)
				req.set_str("modificatorId", article.lastModificatorId)
				req.set_str("categoryId", article.category.id)

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
            		"UserLastModificator_ID",
            		"Category_ID",
            		"AutorName")
    			VALUES (
    				@id, 
    				@createDate, 
    				@title, 
    				@teaser, 
    				@text, 
    				@idname, 
    				@creatorId, 
            		@modificatorId,
            		@categoryId,
            		@autor
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
				req.set_str("categoryId", article.category.id)
				req.set_str("autor", article.autor)
				
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


		# список категорий
		def get_categories(onError=nil)
			req = DataLayer::Request.new
			sql = get_sqlbody_findcategory();
			sql += 'ORDER BY c."Title" ASC;';
			req.set sql
			dts = raw_sql(req, onError)
			return dts;
		end

		# категория
		def get_category(id, onError=nil)
			req = DataLayer::Request.new
			sql = get_sqlbody_findcategory();
			sql += 'AND c."Id" = @idname;';

			req.set sql
			req.set_str("idname", id)
			dts = one_sql(req, onError)
			return dts;
		end
		# существующая категория
		def get_category_by_idname(idname, onError=nil)
			req = DataLayer::Request.new
			sql = get_sqlbody_findcategory();
			sql += 'AND c."IdName" = @idname;';

			req.set sql
			req.set_str("idname", idname)
			dts = one_sql(req, onError)
			return dts;
		end
		# создание категории
		# в случае неудачи - возвращает nil, иначе возвращает объект category
		def create_category(category, onError=nil)
			req = DataLayer::Request.new
			req.set '
			INSERT INTO "tShcoder_Category"(
			  	"Id", 
			  	"CreateDate", 
			  	"Title", 
			  	"IdName" )
			VALUES (
				@id, 
				@createDate, 
				@title, 
				@idname
        	);
			'
			req.set_str("id", category.id)
			req.set_str("createDate", Time.now.strftime('%Y-%m-%d %H:%M:%S'))
			req.set_str("title", category.title)
			req.set_str("idname", category.idname)

			dts = raw_sql(req, onError)
			if (is_succ_response(dts)) then return category end
			return nil;
		end




		# поиск статей
		def search_articles(txt, onError=nil)
			sql = get_sqlbody_findarticle();
			sql += ' AND (LOWER(z."Title") LIKE @srch OR LOWER(z."Teaser") LIKE @srch OR LOWER(z."Text") LIKE @srch)';
			sql += 'order by "CreateDate" desc;'

			req = DataLayer::Request.new
			req.set sql
			req.set_str("srch", "%#{StringHelper.downcase(txt)}%")

			dts = raw_sql(req, onError)
			return dts;
		end
		# поиск категорий статей
		def search_article_categories(txt, onError=nil)
			req = DataLayer::Request.new
			sql = get_sqlbody_findcategory();
			sql += ' AND (LOWER(c."Title") LIKE @srch)';
			sql += ' ORDER BY c."Title" ASC;';
			req.set sql
			req.set_str("srch", "%#{StringHelper.downcase(txt)}%")
			dts = raw_sql(req, onError)
			return dts;
		end



		private
			# общее начало запроса для поиска категории
			def get_sqlbody_findcategory
				sql = '
				SELECT 
				  c."CreateDate" AS "CategoryCreateDate", 
				  c."Id" AS "CategoryId",
				  c."Title" AS "CategoryTitle",
				  c."IdName" AS "CategoryIdName"
				FROM 
				  public."tShcoder_Category" c
				WHERE
				  1 = 1
				'
				return sql
			end

			# общее начало запроса для поиска статьи
			def get_sqlbody_findarticle
				sql = '
				SELECT 
				  z."CreateDate", 
				  z."Id", 
				  z."Title", 
				  z."Teaser", 
				  z."Text", 
				  z."IdName", 
				  z."UserCreator_ID", 
				  z."UserLastModificator_ID", 
				  z."ModificateDate", 
				  z."AutorName",
				  u."Name" AS "UserName",
				  mu."Name" AS "LastUserName",
				  c."Id" AS "CategoryId",
				  c."Title" AS "CategoryTitle",
				  c."IdName" AS "CategoryIdName"
				FROM 
				  public."tShcoder_Article" z
				  INNER JOIN public."tAuth_User" u ON z."UserCreator_ID" = u."Id"
				  LEFT JOIN public."tAuth_User" mu ON z."UserLastModificator_ID"= mu."Id"
				  LEFT JOIN public."tShcoder_Category" c ON z."Category_ID"= c."Id"

				WHERE 
				  1 = 1
				'
				return sql
			end



	end



end
