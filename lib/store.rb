require 'couchrest'
require 'yaml'

class Store
	@@db = nil

	class << self
		def get( name )
			if @@db.nil?
				filename = File.expand_path( File.dirname(__FILE__) ) + '/../config/config.y'
				config = YAML.load( File.new( filename ) )
				couch = CouchRest.new( config[ :db_url ] )
				@@db = couch.database( config[ :db_name ] )
			end

			@@db.get( name )
		end
	end
end
