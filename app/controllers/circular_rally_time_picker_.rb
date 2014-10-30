class CircularRallyTimePickerView < UIView
  attr_accessor :hours,:minutes,:seconds, :hour,:minute,:second
  
  def initWithFrame frame
    super
    @hours = []
    @minutes = []
    @seconds = []
    24.times do |n|
      @hours << n
      n += 1
    end

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
    tod = Time.now
    @hour = tod.hour
    @minute = tod.min
    @second = 0
    make_picker
    self
  end
  
  def next_minute
    now = Time.now + 60
    new_time = Time.new(now.year,now.month,now.day,now.hour,now.min,0) 
    @hour = new_time.hour
    @minute = new_time.min
    @second = 0
    puts new_time
    @pickerView.selectRow(new_time.hour, inComponent:0, animated:0)
    @pickerView.selectRow(new_time.min, inComponent:1, animated:0)
    @pickerView.selectRow(0, inComponent:2, animated:0)
  end
  
  def selected_time
    date = Time.new
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      sec = (@second * 0.6).to_i
    else
      sec = @second 
    end
    puts "sec #{sec} #{@second }"
    select_time = Time.local(date.year, date.month, date.day, @hour, @minute, sec)
    # puts "select_time #{select_time} "
    select_time
  end
  
  def make_picker
    @pickerView = UIPickerView.alloc.initWithFrame([[0,0], [240, 60]])
    @pickerView.dataSource = self
    @pickerView.delegate = self
    @pickerView.showsSelectionIndicator = 0
    tod = Time.now
    @pickerView.selectRow(tod.hour, inComponent:0, animated:0)
    @pickerView.selectRow(tod.min, inComponent:1, animated:0)
    @pickerView.selectRow(0, inComponent:2, animated:0)
    # @pickerView.backgroundColor = UIColor.blueColor
    self.addSubview @pickerView
  end
  
  def pickerView(pickerView, widthForComponent:component)
    # puts "pickerView numberOfRowsInComponent #{rows}"
    case component
    when 0
      40.0
    when 1
      60.0
    when 2
      60.0
    end
  end
  
  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    puts "did select row #{row} #{pickerView.inspect} component: #{component}" 
    case component
    when 0
      @hour = fix_row_for_hour_selection(row)
    when 1
      @minute = fix_row_for_minute_selection(row)
    when 2
      @second = fix_row_for_second_selection(row)
    end
  end
  
  # this seems to return the view for the row
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    # puts "row: #{row} #{pickerView.inspect} #{component.class} #{component.inspect}"
    case component
    when 0
      "%02d" % @hours[fix_row_for_hour_selection(row)]
    when 1
      "%02d" % @minutes[fix_row_for_minute_selection(row)]
    when 2
      "%02d" % @seconds[fix_row_for_second_selection(row)]
    end
  end
  def numberOfComponentsInPickerView(pickerView)
    3
  end
  def pickerView(pickerView, numberOfRowsInComponent: rows)
    # puts "pickerView numberOfRowsInComponent #{rows}"
    case rows
    when 0
      @hours.size * 3
    when 1
      @minutes.size * 3
    when 2
      @seconds.size * 3
    end
  end
  
  def fix_row_for_hour_selection(a_row)
    if a_row >= 24 && a_row < 48
      return a_row - 24
    end
    if a_row > 24
      return a_row - 48
    end
    return a_row
  end
  
  def fix_row_for_minute_selection(a_row)
    if a_row >= 60 && a_row < 120
      return a_row - 60
    end
    if a_row > 120
      return a_row - 120
    end
    return a_row
  end
  
  def fix_row_for_second_selection(a_row)
    if a_row >= @seconds.size && a_row < (@seconds.size * 2)
      return a_row - @seconds.size
    end
    if a_row > @seconds.size
      return a_row - @seconds.size * 2
    end
    return a_row
  end

end

