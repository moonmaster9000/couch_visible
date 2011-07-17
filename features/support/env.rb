$LOAD_PATH.unshift './lib'

require 'couch_visible'
require 'couchrest_model_config'
require 'memories'

class Document < CouchRest::Model::Base
  include CouchVisible
end

CouchRest::Model::Config.edit do
  server do
    default "http://admin:password@localhost:5984"
  end

  database do
    default "couch_visible_test"
  end
end

Before do
  Document.database.recreate!
  CouchVisible.reset!
end
