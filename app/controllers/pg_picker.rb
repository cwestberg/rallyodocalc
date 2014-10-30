class PGPickerView < UIView
  attr_accessor :minutes,:seconds,:minute,:second
  
  def initWithFrame frame
    super
    @minutes = []
    @seconds = []


    60.times do |n|
      @minutes << n
    end
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      100.times do |n|
        # @minutes << n
        @seconds << n
        n += 1
      end
    else
      60.times do |n|
        # @minutes << n
        @seconds << n
        n += 1
      end
    end

    @minute = 0
    @second = 0
    make_picker
    self
  end
  
  # def selected_time
  #   if NSUserDefaults.standardUserDefaults["cents_timing"] == true
  #     select_time = @minute * 100 + @second
  #   else
  #     select_time = @minute * 100 + @second
  #   end
  #   puts "sec #{sec} #{@second }"
  #   select_time = @minute, sec
  #   # puts "select_time #{select_time} "
  #   select_time
  # end
  
  def make_picker
    @pickerView = UIPickerView.alloc.initWithFrame([[0,0], [130, 60]])
    @pickerView.backgroundColor = 0xd1eefc.uicolor
    
    @pickerView.dataSource = self
    @pickerView.delegate = self
    @pickerView.showsSelectionIndicator = 0
    @pickerView.selectRow(0, inComponent:0, animated:0)
    @pickerView.selectRow(0, inComponent:1, animated:0)
    # @pickerView.backgroundColor = UIColor.blueColor
    self.addSubview @pickerView
  end
  
  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    puts "did select row #{row} #{pickerView.inspect} component: #{component}" 
    case component
    when 0
      @minute = row
    when 1
      @second = row
    end
  end
  
  # this seems to return the view for the row
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    # puts "row: #{row} #{pickerView.inspect} #{component.class} #{component.inspect}"
    case component
    when 0
      "%02d" % @minutes[row]
    when 1
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        ".%02d" % @seconds[row]
      else
        ":%02d" % @seconds[row]
      end
    end
  end
  def numberOfComponentsInPickerView(pickerView)
    2
  end
  def pickerView(pickerView, numberOfRowsInComponent: rows)
    # puts "pickerView numberOfRowsInComponent #{rows}"
    case rows
    when 0
      @minutes.size
    when 1
      @seconds.size
    end
  end

  
  # def fix_row_for_minute_selection(a_row)
  #   if a_row >= 60 && a_row < 120
  #     return a_row - 60
  #   end
  #   if a_row > 120
  #     return a_row - 120
  #   end
  #   return a_row
  # end
  # 
  # def fix_row_for_second_selection(a_row)
  #   if a_row >= @seconds.size && a_row < (@seconds.size * 2)
  #     return a_row - @seconds.size
  #   end
  #   if a_row > @seconds.size
  #     return a_row - @seconds.size * 2
  #   end
  #   return a_row
  # end

end

