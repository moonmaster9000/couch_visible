$LOAD_PATH.unshift './lib'

require 'couch_visible'
require 'couchrest_model_config'
require 'couch_publish'

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

  if defined? Query
    Object.class_eval do
      remove_const "Query"
    end
  end
end
