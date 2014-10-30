class GeofenceModel
  PROPERTIES = [:lat,:long,:radius,:identifier,:region]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
    @lat = 44.854
    @long = -93.375
    @center = CLLocationCoordinate2DMake(@lat,@long)
    @radius = 50.0
    @identifier = "Home"
    # @region = CLRegion.alloc.initCircularRegionWithCenter(@center,radius: @radius,identifier: @identifier)
    @region = CLCircularRegion.alloc.initCircularRegionWithCenter(@center,radius: @radius,identifier: @identifier)

  end
end