module CouchVisible
  module CouchPublish
    def self.included(base)
      base.couch_view :by_hidden do
        map CouchVisible::ByHidden
        conditions ::Published, ::Unpublished
      end

      base.couch_view :by_shown do
        map CouchVisible::ByShown
        conditions ::Published, ::Unpublished
      end
    end
  end
end
