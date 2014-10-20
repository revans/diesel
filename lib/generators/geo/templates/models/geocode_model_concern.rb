
module GeocodeAddress
  extend ::ActiveSupport::Concern

  included do
    # geocode address
    geocoded_by :full_address do |obj, results|
      if geo = results.first
        obj.latitude        = geo.latitude
        obj.longitude       = geo.longitude
        obj.geocoded_data   = {
          address:        geo.address,
          city:           geo.city,
          state:          geo.state,
          state_code:     geo.state_code,
          postal_code:    geo.postal_code,
          country:        geo.country,
          country_code:   geo.country_code,
          county:         geo.sub_state,
          route:          geo.route,
          street_number:  geo.street_number,
          types:          geo.types,
          precision:      geo.precision,
          viewport:       geo.geometry['viewport'],
        }
      end
    end

    after_validation :geocode, if: ->(obj) { obj.full_address.present? && obj.address_has_changed? && !already_geocoded? }
  end

  # Returns the complete address (street, city, state, zipcode)
  # so it can be used for geocoding.
  #
  def full_address
    [ address, city, state, zipcode, country ].compact.join(', ')
  end

  def address_has_changed?
    address_changed?    ||
      city_changed?     ||
      state_changed?    ||
      zipcode_changed?  ||
      country_changed?
  end

  def already_geocoded?
    !new_record? && geocoded_data.present?
  end

end
