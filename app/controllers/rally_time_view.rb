class RallyTimeView < UIView
  attr_accessor :current_speed,:next_speed,:units
  
  PLUSBACKGROUNDCOLOR = 0xd7d7d7
  MINUSBACKGROUNDCOLOR = 0x4CD964
  def initWithFrame frame
    super
    # now = Time.now + 60
    #     @current_rally_time = Time.new(now.year,now.month,now.day,now.hour,now.min,0)
    @units = 0
    next_minute
    make_rally_time_label
    make_minus_hours_button
    make_minus_minutes_button
    make_minus_units_button
    make_plus_hours_button
    make_plus_minutes_button
    make_plus_units_button
    self
  end
  
  def next_minute
    now = Time.now + 60
    @current_rally_time = Time.new(now.year,now.month,now.day,now.hour,now.min,0)    
  end
  
  def update_next_minute_view
    next_minute
    @rally_time_label.text = "#{@current_rally_time.hour}:#{"%02.0f" % @current_rally_time.min}:#{"%02.0f" % @current_rally_time.sec}"
  end
  
  def selected_time
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      sec = (@current_rally_time.sec * 0.6).to_i
    else
      sec = @current_rally_time.sec 
    end
    puts "sec #{sec} #{@current_rally_time.sec }"
    # select_time = Time.local(date.year, date.month, date.day, @hour, @minute, sec)
    # puts "select_time #{select_time} "
    # select_time
    @current_rally_time
  end
  
  # def update_rally_time(seconds)
  #   @current_rally_time = @current_rally_time + seconds
  #   # @rally_time_label.text = "#{"#{@current_rally_time.hour}:#{@current_rally_time.min}:#{@current_rally_time.sec}"}"
  #   @rally_time_label.text = "#{@current_rally_time.hour}:#{"%02.0f" % @current_rally_time.min}:#{"%02.0f" % @current_rally_time.sec}"
  # end
  
  # update_rally_units(1, 0, 0)
  # update_rally_units(0, 1, 0)
  # update_rally_units(0, 0, 1)
  def update_rally_time(seconds)
    @current_rally_time = @current_rally_time + seconds
    # @rally_time_label.text = "#{"#{@current_rally_time.hour}:#{@current_rally_time.min}:#{@current_rally_time.sec}"}"

    @rally_time_label.text = "#{@current_rally_time.hour}:#{"%02.0f" % @current_rally_time.min}:#{"%02.0f" % @current_rally_time.sec}"
    puts "#{@current_rally_time.hour}:#{"%02.0f" % @current_rally_time.min}:#{"%02.0f" % @current_rally_time.sec}"
    
  end
  

  def make_rally_time_label
    @rally_time_label = UILabel.alloc.initWithFrame [[0,0],[140,64]]
    # @rally_time_label.text = "#{"#{@current_rally_time.hour}:#{@current_rally_time.min}:#{@current_rally_time.sec}"}"
    @rally_time_label.text = "#{@current_rally_time.hour}:#{"%02.0f" % @current_rally_time.min}:#{"%02.0f" % @current_rally_time.sec}"
    
    @rally_time_label.font = UIFont.fontWithName('Helvetica', size:32)
    # @rally_time_label.backgroundColor = UIColor.blackColor
    # @rally_time_label.textColor = UIColor.whiteColor
    # @rally_time_label.textAlignment = UITextAlignmentRight
    self.addSubview @rally_time_label
    @rally_time_label.userInteractionEnabled = true
    @next_min_recognizer = UISwipeGestureRecognizer.new
    @next_min_recognizer.direction = UISwipeGestureRecognizerDirectionRight
    next_min_proc = Proc.new {|n| self.update_next_minute_view}
    @rally_time_label.on_gesture(@next_min_recognizer, {}, &next_min_proc)
  end
  
  def make_plus_hours_button
    @plus_hours_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_hours_button.setTitle("HH", forState:UIControlStateNormal)
    @plus_hours_button.sizeToFit
    @plus_hours_button.frame = [[0,60],[60,60]]
    @plus_hours_button.font = UIFont.fontWithName('Helvetica', size:32)
    @plus_hours_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_hours_button
    @plus_hours_button.when(UIControlEventTouchUpInside) do
      update_rally_time(60*60)
    end
  end
  
  def make_plus_minutes_button
    @plus_minutes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_minutes_button.setTitle("MM", forState:UIControlStateNormal)
    @plus_minutes_button.frame = [[60,60],[60,60]]
    @plus_minutes_button.font = UIFont.fontWithName('Helvetica', size:32) 
    @plus_minutes_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_minutes_button
    @plus_minutes_button.when(UIControlEventTouchUpInside) do
      update_rally_time(60)
    end
  end
  def make_plus_units_button
    @plus_units_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_units_button.setTitle("SS", forState:UIControlStateNormal)
    @plus_units_button.frame = [[120,60],[60,60]]
    @plus_units_button.font = UIFont.fontWithName('Helvetica', size:32)  
    @plus_units_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor  
    self.addSubview @plus_units_button
    @plus_units_button.when(UIControlEventTouchUpInside) do
      update_rally_time(1)
    end
  end
  def make_minus_hours_button
    @minus_hours_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_hours_button.setTitle("HH", forState:UIControlStateNormal)
    @minus_hours_button.sizeToFit
    @minus_hours_button.frame = [[0,120],[60,60]]
    @minus_hours_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_hours_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.addSubview @minus_hours_button
    @minus_hours_button.when(UIControlEventTouchUpInside) do
      update_rally_time(-60*60)
    end
  end
  
  def make_minus_minutes_button
    @minus_minutes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_minutes_button.setTitle("MM", forState:UIControlStateNormal)
    @minus_minutes_button.frame = [[60,120],[60,60]]
    @minus_minutes_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_minutes_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_minutes_button
    @minus_minutes_button.when(UIControlEventTouchUpInside) do
      update_rally_time(-60)
    end
  end
  def make_minus_units_button
    @minus_units_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_units_button.setTitle("SS", forState:UIControlStateNormal)
    @minus_units_button.frame = [[120,120],[60,60]]
    @minus_units_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_units_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_units_button
    @minus_units_button.when(UIControlEventTouchUpInside) do
      update_rally_time(-1)
    end
  end
end