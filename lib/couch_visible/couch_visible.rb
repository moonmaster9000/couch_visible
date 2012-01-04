module CouchVisible

  def self.included(base) 
    base.send :include, ::CouchView unless base.ancestors.include?(::CouchView)
    base.extend ModelClassMethods
    base.property :couch_visible, TrueClass

    base.couch_view :by_hidden do
      map CouchVisible::ByHidden
    end

    base.couch_view :by_shown do
      map CouchVisible::ByShown
    end
    
    base.before_create do |doc|
      doc.couch_visible = doc.class.show_by_default? if doc.couch_visible.nil?
      true
    end

    if defined?(Memories) && base.ancestors.include?(Memories)
      base.forget :couch_visible
    end

    if defined?(::CouchPublish) && base.ancestors.include?(::CouchPublish)
      base.send :include, CouchVisible::CouchPublish
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
    self.save!
  end

  def hide
    self.couch_visible = false
  end

  def show!
    self.couch_visible = true
    self.save!
  end

  def show
    self.couch_visible = true
  end

end
