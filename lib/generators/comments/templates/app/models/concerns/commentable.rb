module Commentable
  extend ActiveSupport::Concern

  included do
    belongs_to :comments, as: :commentable, dependent: :destroy
  end

end