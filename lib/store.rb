require 'configuration'
require 'couchrest'

class Store
	@@db = nil

	class << self
		def init_db
			if @@db.nil?
				Configuration.path = File.dirname( __FILE__ ) + "/../config"
				config = Configuration.load "config"
				db = config.db

				couch = CouchRest.new( db.url )
				@@db = couch.database( db.name )
			end
		end

		def get( name )
			init_db
			@@db.get( name )
		rescue RestClient::ResourceNotFound
			nil
		end

		def save( doc )
			init_db
			@@db.save_doc( doc )
		end

		def view( view_name )
			init_db
			@@db.view( view_name )
		end
	end
end
