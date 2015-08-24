require "datalayer/baseclient"
#require "models/shcoder/shcoder_article"

module Clients


	class AuthClient < DataLayer::BaseClient

		def initialize()
			init('site_data');
		end


		# ID пользователя по авторизации
		def authenticate(userName, userPassHash, onError=nil)
			req = DataLayer::Request.new
			req.set 'SELECT z.* FROM "tAuth_User" z Where z."IdName" = @idname and z."PassHash" = @pass limit 1;'
			req.set_str("idname", userName)
			req.set_str("pass", userPassHash)
			entity = one_sql(req, onError)
			if (entity.nil?) then return nil end
			return entity["Id"];
		end

		
		# пользователь по id
		def find_by(id, onError=nil)
			req = DataLayer::Request.new
			req.set 'SELECT z.* FROM "tAuth_User" z Where z."Id" = @idname limit 1;'
			req.set_str("idname", id)
			entity = one_sql(req, onError)
			return entity;
		end

		# данные по сервисам пользователя c id
		def extra_services(id, onError=nil)
			req = DataLayer::Request.new
			req.set '
				SELECT 
					"tAuth_User"."Name" AS "UserName", 
					"tSite_Services"."Title" AS "ServiceName", 
					"tSite_Services"."Code" AS "ServiceCode",
					"tSite_ServiceRoles"."Title" AS "ServiceRole",  
					"tSite_ServiceRoles"."Flag" AS "ServiceRoleFlag",
					"tAuth_UserServices"."ServiceId" AS "ServiceId", 
					"tAuth_UserServices"."ServiceRoleId" AS "ServiceRoleId"

				FROM 
					public."tAuth_User", 
					public."tAuth_UserServices", 
					public."tSite_Services", 
					public."tSite_ServiceRoles" 
				WHERE 
					"tAuth_UserServices"."UserId" = "tAuth_User"."Id" 
					AND "tAuth_UserServices"."ServiceId" = "tSite_Services"."Id" 
					AND "tAuth_UserServices"."ServiceRoleId" = "tSite_ServiceRoles"."Id" 
					AND "tAuth_User"."Id" = @idname;
			'
			req.set_str("idname", id)
			dts = raw_sql(req, onError)
			return dts;
		end




	end



end
