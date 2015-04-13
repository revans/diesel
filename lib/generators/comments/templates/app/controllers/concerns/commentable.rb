
module Commentable
  module Controller
    extend ActiveSupport::Concern


    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end

      nil
    end


  end
end