
module ApiVersioning
  extend ::ActiveSupport::Concern

  included do
    before_action :assign_version_number, if: :json_requested?
  end

  def assign_version_number
    return if params[:api_version_number].present?
    params.store(:api_version_number, get_version_number)
  end

  protected

  # accept: application/json; version=1
  def get_version_number
    format, version = request.headers['Accept'].try(:split, ';')

    return default_version if version.blank?
    version.split('=').last
  end

  def default_version
    ::Rails.application.config_for(:api)["version"] || 1
  end

end
