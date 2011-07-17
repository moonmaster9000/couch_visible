module CouchVisible
  module Config
    def reset!
      @visible_by_default = false
    end

    def visible_by_default?
      @visible_by_default ||= false
    end

    def visible_by_default!
      @visible_by_default = true
    end
    
    def hidden_by_default?
      !(@visible_by_default ||= false)
    end

    def hidden_by_default!
      @visible_by_default = false
    end
  end
end

CouchVisible.extend CouchVisible::Config
