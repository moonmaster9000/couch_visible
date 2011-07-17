module CouchVisible
  module Config
    def reset!
      @show_by_default = false
    end

    def show_by_default?
      @show_by_default ||= false
    end

    def show_by_default!
      @show_by_default = true
    end
    
    def hide_by_default?
      !(@show_by_default ||= false)
    end

    def hide_by_default!
      @show_by_default = false
    end
  end
end

CouchVisible.extend CouchVisible::Config
