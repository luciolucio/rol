require 'couchrest'
require 'yaml'

class Store
	@@db = nil

	class << self
		def get( name )
			if @@db.nil?
				config = YAML.load( File.new( '../config/config.y' ) )
				couch = CouchRest.new( config[ :db_url ] )
				@@db = couch.database( config[ :db_name ] )
			end

			@@db.get( name )
		end
	end
end
