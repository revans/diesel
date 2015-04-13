
module Likable
  extend ActiveSupport::Concern

  included do
    belongs_to :likes, as: :likable, dependent: :destroy
  end
end