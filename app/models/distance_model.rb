class DistanceModel
  PROPERTIES = [:mileage,:factor,:direction,:parked]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
    @factor = 1.0000 if @factor.nil?
    zero_mileage if @mileage.nil?
    direction_forward if @direction.nil?
    puts "#{@mileage} #{@direction} #{@factor}"
  end

  def update_mileage(distance_moved)
    puts "@parked #{@parked}"
    return if @parked == true
    case @direction
    when 'forward'
      forward_mileage(distance_moved)
    when 'reverse'
      reverse_mileage(distance_moved)
    end
    puts "#{@mileage} #{@factor} #{@direction}"
  end
  
  def direction_forward
    @direction = 'forward'
  end
  def forward_mileage(distance_moved)  
    if NSUserDefaults.standardUserDefaults["units"] == false
      @mileage += ((distance_moved * MetersToMiles) * @factor)
    else
      @mileage += ((distance_moved * MetersToKM) * @factor)
    end  
    # @mileage += ((distance_moved * 0.00062137) * @factor)
  end
  def set_reverse
    @direction = 'reverse'
  end
  def set_forward
    @direction = 'forward'
  end
  def reverse_mileage(distance_moved) 
    if NSUserDefaults.standardUserDefaults["units"] == false
      @mileage -= ((distance_moved * MetersToMiles) * @factor)
    else
      @mileage -= ((distance_moved * MetersToKM) * @factor)
    end
    # @mileage -= ((distance_moved * 0.00062137) * @factor)
    if (@mileage < 0.0)
      @mileage = 0.0
    end
  end
  
  def zero_mileage
     @mileage = 0.0
  end
end