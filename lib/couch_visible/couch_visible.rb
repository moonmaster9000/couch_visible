module CouchVisible

  def self.included(base) 
    base.extend ModelClassMethods
    base.property :visible, TrueClass
    base.view_by :hidden, :map => "
      function(doc){
        if (doc['couchrest-type'] == '#{base}' && doc.visible == false){
          emit(doc['_id'], null);
        }
      }
    ", :reduce => "_count"
    base.view_by :shown, :map => "
      function(doc){
        if (doc['couchrest-type'] == '#{base}' && doc.visible == true){
          emit(doc['_id'], null);
        }
      }
    ", :reduce => "_count"
    
    base.before_create do |doc|
      doc.visible = doc.class.show_by_default? if doc.visible.nil?
      true
    end
  end

  module ModelClassMethods
    def show_by_default?
      unless defined? @show_by_default
        CouchVisible.show_by_default?
      else
        @show_by_default
      end
    end

    def show_by_default!
      @show_by_default = true
    end
    
    def hide_by_default?
      !show_by_default?
    end

    def hide_by_default!
      @show_by_default = false
    end

    def count_hidden
      result = by_hidden(:reduce => true)['rows'].first
      result ? result['value'] : 0
    end

    def count_shown
      result = by_shown(:reduce => true)['rows'].first
      result ? result['value'] : 0
    end
  end
  
  def shown?
    visible == true
  end

  def hidden?
    visible != true
  end

  def hide!
    self.visible = false
  end

  def show!
    self.visible = true
  end
end
