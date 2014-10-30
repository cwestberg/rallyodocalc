class CircularSpeedPicker
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
      @tenth = fix_row_for_selection(row)
    when 1
      @one = fix_row_for_selection(row)
    when 2
      @decimal = fix_row_for_selection(row)
    end
    # @speed = @tenths + @ones
    # @model.cast = @speed
  end
  
  # this seems to return the view for the row
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    # puts "row: #{row} #{pickerView.inspect} #{component.class} #{component.inspect}"
    case component
    when 0
      "#{@tenths[fix_row_for_selection(row)]}"
    when 1
      "#{@ones[fix_row_for_selection(row)]}"
    when 2
      ".#{@decimals[fix_row_for_selection(row)]}"
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
    30
  end
  
  def fix_row_for_selection(a_row)
    if a_row >= 10 && a_row < 20
      return a_row - 10
    end
    if a_row > 10
      return a_row - 20
    end
    return a_row
  end

end

