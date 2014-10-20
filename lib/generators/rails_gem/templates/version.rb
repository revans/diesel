require_relative 'gem_version'

module <%= camelized %>

  # Returns the version of the currently loaded <%= camelized %> as a <tt>Gem::Version</tt>
  def self.version
    gem_version
  end

end
