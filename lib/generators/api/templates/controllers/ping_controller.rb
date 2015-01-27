
class PingController < ActionController::Base
  skip_before_action :authenticate

  def index
    render json: 'pong'.to_json, status: 200
  end

end

