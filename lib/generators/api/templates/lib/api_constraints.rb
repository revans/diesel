# Example of how to use within the config/routes.rb file
# namespace :api, defaults: { format: 'json' } do
#   namespace :v1, constraints: PrivateApiConstraints.new(version: 1, default: true) do
#     ....
#   end
# end

class PrivateApiConstraints
  attr_reader :version

  # Version defaults to 1
  def initialize(options)
    @version = options.fetch(:version, 1)
    @default = options.fetch(:default, true)
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.#{company_name}.#{application_name}-v#{version}+json")
  end

  private

  def application_name
    @application_name ||= ::Rails.application.config_for(:api).app_name.downcase.gsub(/\s+/, '_')
  end

  def company_name
    @company_name ||= ::Rails.application.config_for(:api).company_name.downcase.gsub(/\s+/, '_')
  end
end
