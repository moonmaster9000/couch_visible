module CouchVisible
  class ByHidden
    include CouchView::Map
    
    def map
      "
        function(doc){
          if (#{conditions} && doc.couch_visible == false){
            emit(doc['_id'], null);
          }
        }
      "
    end
  end
end

