require 'couchrest'
require 'yaml'

class Store
	@@db = nil

	class << self
		def init_db
			if @@db.nil?
				filename = File.expand_path( File.dirname(__FILE__) ) + '/../config/config.y'
				config = YAML.load( File.new( filename ) )
				couch = CouchRest.new( config[ :db_url ] )
				@@db = couch.database( config[ :db_name ] )
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

			if( doc.respond_to?( :to_document ) )
				doc = doc.to_document
			end

			@@db.save_doc( doc )
		end

		def view( view_name )
			init_db

			@@db.view( view_name )
		end
	end
end
