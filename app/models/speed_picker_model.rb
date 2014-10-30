class SpeedPicker
  attr_accessor :speed,:model, :ones,:tenths,:one,:tenth,:decimal,:decimals
  
  def initialize 
    @speed = 36
    @tenths = [0,1,2,3,4,5,6,7,8,9]
    @tenth = 3
    @ones = [0,1,2,3,4,5,6,7,8,9]
    @one = 6
    @decimals = [0,1,2,3,4,5,6,7,8,9]
    @decimal = 0
    @decimal_mode = true
  end

  def selected_speed
    if @decimal_mode == true
      speed_selected = ((@tenth * 10 ) + @one + (@decimal * 0.1)).round(1)
      puts "selected decimal_speed #{speed_selected} #{@tenth} #{@one} #{@decimal}"
    else
      speed_selected = (@tenth * 10 ) + @one
      puts "selected_speed #{speed_selected} #{@tenth} #{@one} #{@decimal}"
    end
    speed_selected
  end
  
  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    # puts "did select row #{row} #{pickerView.inspect}" 
    case component
    when 0
      @tenth = row
    when 1
      @one = row
    when 2
      @decimal = row
    end
    # @speed = @tenths + @ones
    # @model.cast = @speed
  end
  
  # this seems to return the view for the row
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    # puts "row: #{row} #{pickerView.inspect} #{component.class} #{component.inspect}"
    case component
    when 0
      "#{@tenths[row]}"
    when 1
      "#{@ones[row]}"
    when 2
      ".#{@decimals[row]}"
    end
  end
  def numberOfComponentsInPickerView(pickerView)
    if @decimal_mode == true
      3
    else
      2
    end
  end
  def pickerView(pickerView, numberOfRowsInComponent: rows)
    case rows
    when 0
      10
    when 1
      10
    when 2
      10
    end
  end

end

