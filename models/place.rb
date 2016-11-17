include Geokit::Geocoders

class Place < ActiveRecord::Base
  MAX_NUMBER_OF_RESULTS = 10
  SEARCH_RADIUS = 30 # kms

  acts_as_mappable  :default_units => :kms,
                    :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude

  before_save :find_geocoded_coordinates

  validates :name, :presence => true
  validates :address, :presence => true
  validates :email, :format => /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i, :allow_blank => true
  validates :website, :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true#, :message => "is invalid. Example format: http://www.domainname.com"


  def full_address
    full_address = ""
    unless self.address.blank?
      full_address += self.address
    end
    unless self.city.blank?
      full_address += ", " + self.city
    end
    unless self.province.blank?
      full_address += ", " + self.province
    end
    unless self.country.blank?
      full_address += ", " + self.country
    end
    unless self.postal.blank?
      full_address += ", " + self.postal
    end
    return full_address
  end

  def region
    region = ""
    unless self.city.blank?
      region += self.city
    end
    unless self.province.blank?
      region += self.province
    end
    unless self.country.blank?
      region += self.country
    end
    return region
  end

  def website_name
    if self.website.size > 50
      return "Website"
    else
      return self.website[7..-1]
    end
  end

  def geocode_from_address(search_address)

    location = MultiGeocoder.geocode(search_address)
#    location = Geokit::Geocoders::Google3Geocoder.geocode(search_address)  #this forced the provider to the new google v3 api ii sept 16th 2013
#    logger.debug( 'DEBUG >> geocode_from_address location ='+ location.inspect)
    puts "LOCATION: #{ location.lat }, #{ location.lng }, #{ location.full_address }"
    if location.success
      self.latitude = location.lat
      self.longitude = location.lng
      self.generated_address = location.full_address
      self.gmaps = true
    else
      self.gmaps = false
    end
  end

  private

  def find_geocoded_coordinates
    geocode_from_address(self.full_address)
  end

end
