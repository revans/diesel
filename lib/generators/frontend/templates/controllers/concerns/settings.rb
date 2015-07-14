
module Settings
  extend ActiveSupport::Concern

  included do
    helper_method :app_name, :company_name, :settings, :year, :page_title, :api_name
  end

  def app_name
    @app_name ||= ''
  end

  def api_name
    @api_name ||= ''
  end

  def company_name
    @company_name ||= ''
  end

  def year
    @year ||= ::Time.now.year
  end

  def settings
    @settings ||= ::Rails.configuration.x
  end

  def page_title(title = '')
    @page_title ||= "#{app_name}: #{title}"
  end

  def set_flash(type, options = {})
    flash[type] = t("#{controller_name}.#{action_name}.#{type}", options)
  end

end
