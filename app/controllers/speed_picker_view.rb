class SpeedPickerView < UIView
  attr_accessor :speed,:model, :ones,:tenths,:one,:tenth
  
  def initWithFrame frame
    super
    @speed = 36
    @tenths = [0,1,2,3,4,5,6,7,8,9]
    @tenth = 3
    @ones = [0,1,2,3,4,5,6,7,8,9]
    @one = 6

    make_picker
    self
  end

  def selected_speed
    date = Time.new
    selected_speed = @tenths + @ones
    puts "selected_speed #{selected_speed} "
    selected_speed
  end
  
  def set_speed(aSpeed)
    tenth = aSpeed/10
    one = aSpeed - tenth
    @pickerView.selectRow(tenth, inComponent:0, animated:0)
    @pickerView.selectRow(one, inComponent:1, animated:0)
  end
  def make_picker
    @pickerView = UIPickerView.alloc.initWithFrame([[0,0], [60, 80]])
    @pickerView.delegate = self
    @pickerView.dataSource = self
    @pickerView.showsSelectionIndicator = 1
    @pickerView.selectRow(tenth, inComponent:0, animated:0)
    @pickerView.selectRow(one, inComponent:1, animated:0)
    @pickerView.backgroundColor = UIColor.yellowColor
    
    self.addSubview @pickerView
  end
  
  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    puts "did select row #{row} #{pickerView.inspect}" 
    case component
    when 0
      @tenth = row
    when 1
      @one = row
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
    end
  end
  def numberOfComponentsInPickerView(pickerView)
    2
  end
  def pickerView(pickerView, numberOfRowsInComponent: rows)
    case rows
    when 0
      10
    when 1
      10
    end
  end

end

