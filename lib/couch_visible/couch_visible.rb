module CouchVisible

  def self.included(base) 
    base.extend ModelClassMethods
    base.property :couch_visible, TrueClass
    base.view_by :hidden, :map => "
      function(doc){
        if (doc['couchrest-type'] == '#{base}' && doc.couch_visible == false){
          emit(doc['_id'], null);
        }
      }
    ", :reduce => "_count"
    base.view_by :shown, :map => "
      function(doc){
        if (doc['couchrest-type'] == '#{base}' && doc.couch_visible == true){
          emit(doc['_id'], null);
        }
      }
    ", :reduce => "_count"
    
    base.before_create do |doc|
      doc.couch_visible = doc.class.show_by_default? if doc.couch_visible.nil?
      true
    end

    if defined?(Memories) && base.ancestors.include?(Memories)
      base.forget :couch_visible
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
    couch_visible == true
  end

  def hidden?
    couch_visible != true
  end

  def hide!
    self.couch_visible = false
  end

  def show!
    self.couch_visible = true
  end
end
