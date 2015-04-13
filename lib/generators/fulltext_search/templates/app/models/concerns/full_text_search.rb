
module FullTextSearch
  extend ::ActiveSupport::Concern

  included do
  end

  module ClassMethods
    include ::PgSearch

    def search_fields(*args)

    end
  end

end