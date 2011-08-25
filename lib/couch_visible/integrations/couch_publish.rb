module CouchVisible
  module CouchPublish
    def self.included(base)
      base.couch_view :by_hidden do
        map CouchVisible::ByHidden
        conditions CouchVisible::Conditions::Published, CouchVisible::Conditions::Unpublished
      end

      base.couch_view :by_shown do
        map CouchVisible::ByShown
        conditions CouchVisible::Conditions::Published, CouchVisible::Conditions::Unpublished
      end
    end
  end
end
