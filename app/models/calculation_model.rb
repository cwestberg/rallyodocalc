class CalculationModel
  PROPERTIES = [:calc_mileage,:cast,:calc_time,:calc_tod,:car_number,:calc_distance,:transit_mileage,:my_controller]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
    @cast = 36
    @calc_mileage = 0.0
    @calc_time = 0.0
    @calc_tod = Time.now
    @car_number = 0
    @calc_distance = 0.0
    @transit_mileage = 0.0
    @i = 0
  end
  
  def update_units_per_minute
    # called 10 time per second
    # compare TOD vs calc_tod
    if @cast > 0.00
      distance_increment = @cast/36000.0 
    end
    @calc_distance += distance_increment if calc_tod < Time.now
    if @i == 10
      # puts "@calc_distance #{@calc_distance.round(2)} #{@cast} #{calc_seconds} calc_tod:#{@calc_tod}"
      # puts "calc_tod > Time.now #{calc_tod > Time.now}"
      @i = 0
    end
    @i +=1
  end
  
  def calc_time_as_seconds
    cents_to_seconds(@calc_time)
  end
  
  def calc_seconds
    # puts "(@calc_time*0.6) * 100 = #{(@calc_time*0.6) * 100}  #{((@calc_time*0.6) * 100).round}"
    # puts "(@calc_time*0.6) * 100 #{(@calc_time*0.6) * 100}"
      @calc_tod + ((@calc_time*0.6) * 100).round(2)
    
    # @calc_tod + ((@calc_time*0.6) * 100).round(2)
    # @calc_tod + ((@calc_time*0.6) * 100).round
  end
  # update calc_time which is in minutes and cents
  def calc(pg_value)
    @calc_time += pg_value
    addLogEntry("P/G #{pg_value.round(2)}")
    # puts "calc_time #{calc_time}  calc_mileage #{@calc_mileage}"
  end
  def crank(crank_value)
    if @cast == 0.0
    else
      @calc_time += (crank_value * (60.0/@cast))
    end
    @calc_mileage += crank_value
    
    # puts "cast #{@cast} crank value #{crank_value} calc_time #{calc_time}  calc_mileage #{@calc_mileage}"
  end
  # Not used
  # def crank_tod
  #   puts "@calc_tod #{@calc_tod} #{@calc_time}"
  #   @calc_tod += @calc_time.round(5)
  #   puts "@calc_tod #{@calc_tod}"
  #   
  # end
  
  # take the difference between the previous crank and the current mileage and priduce the calc_time
  def crank_match(current_mileage)
    abs_mileage = (current_mileage.round(3) - @transit_mileage.round(3)).abs
    delta_mileage = abs_mileage.round(3) - @calc_mileage.round(3) 
    puts "mileages: #{@transit_mileage.round(3)} : #{current_mileage.round(3)} :  abs #{abs_mileage.round(3)} - #{@calc_mileage.round(3)}"
    
    # delta_mileage = (current_mileage.round(3) - @transit_mileage.round(3)) - @calc_mileage.round(3) 
    puts "delta #{delta_mileage}"
    # delta_mileage = current_mileage - @calc_mileage
    
    crank(delta_mileage)
  end

  def zero
    @calc_mileage = 0.0
    @calc_time = 0.0
    @calc_distance = 0.0
  end
  
  def seconds_to_cents(seconds)
    return (seconds * ((1.6667)/100)).round(2)
  end
  
  def cents_to_seconds(cents)
    raw_secs = (cents*0.6) * 100
    puts "raw_secs #{raw_secs} #{raw_secs.round(2).to_i}"
    secs = raw_secs.round(2).to_i.modulo(60)
    puts "secs #{secs}"
    # secs = raw_secs.round.modulo(60)
    mins = (raw_secs/60)
    # add insignificant ammount to account for floating point
    mins = (cents + 0.00001).to_i
    puts "mins_raw:#{mins} mins:#{mins.to_i} secs: #{secs}"
    m = "%02d" % mins
    s = "%02d" % secs
    r = "#{m}:#{s}"
    return r
  end
  
  def addLogEntry(action)
    LogEntriesStore.shared.add_entry do |log_entry|
      # We set up our new Location object here.
      log_entry.creation_date = NSDate.date
      log_entry.coordinate = "none"

      log_entry.action = action
      log_entry.split = @calc_distance.to_s
      # puts "calc time: #{@calc_controller_view.calc_view.text} #{@calc_controller_view.tod_view.text}"
      
    end
    @my_controller.table.reloadData
  end
end