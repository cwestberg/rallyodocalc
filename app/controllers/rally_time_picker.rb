class RallyTimePickerView < UIView
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
    # 60.times do |n|
    #   @minutes << n
    #   @seconds << n
    #   n += 1
    # end
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
    @pickerView = UIPickerView.alloc.initWithFrame([[0,0], [130, 60]])
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
  
  def pickerView(pickerView, didSelectRow: row, inComponent: component)
    puts "did select row #{row} #{pickerView.inspect} component: #{component}" 
    case component
    when 0
      @hour = row
    when 1
      @minute = row
    when 2
      @second = row
    end
  end
  
  # this seems to return the view for the row
  def pickerView(pickerView, titleForRow:row, forComponent:component)
    # puts "row: #{row} #{pickerView.inspect} #{component.class} #{component.inspect}"
    case component
    when 0
      "%02d" % @hours[row]
    when 1
      "%02d" % @minutes[row]
    when 2
      "%02d" % @seconds[row]
    end
  end
  def numberOfComponentsInPickerView(pickerView)
    3
  end
  def pickerView(pickerView, numberOfRowsInComponent: rows)
    # puts "pickerView numberOfRowsInComponent #{rows}"
    case rows
    when 0
      @hours.size
    when 1
      @minutes.size
    when 2
      @seconds.size
    end
  end

end

