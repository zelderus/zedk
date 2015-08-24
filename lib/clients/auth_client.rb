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




	end



end
