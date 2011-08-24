module CouchVisible
  class ByShown
    include CouchView::Map
    
    def map
      "
        function(doc){
          if (#{conditions} && doc.couch_visible == true){
            emit(doc['_id'], null);
          }
        }
      "
    end
  end
end
