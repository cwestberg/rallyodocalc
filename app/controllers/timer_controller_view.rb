class ClockController < UIView
  attr_accessor :offset, :adjusted_time,:model,:calc_controller
  
  def initWithFrame frame
    super
    @offset = 0.0
    @start_minute = Time.now + @offset
    # @offset = @defaults["offset"]
    @defaults = NSUserDefaults.standardUserDefaults
    # puts @defaults['offset']
 
    make_device_clock_label([[5,15],[285,32]])
    make_adjusted_clock_label([[5,40],[500,32]])
    make_offset_label([[5,70],[185,32]])
    make_offset_stepper([[5,120],[32,32]])
    
    # make_plus_button
    # make_minus_button
    make_split_button([[105,120],[100,32]])
    make_split_label([[25,100],[300,32]])
    @split_label.setHidden(true)
    
    # these need to be their own view
    # make_start_minute_label
    # make_plus_minute_button
    # make_minus_minute_button
    # make_plus_second_button
    # make_minus_second_button
    # make_countdown_label([[5,225],[185,28]])
    start_clock
    self
  end

  def make_offset_stepper(frame)
    @offset_stepper = UIStepper.alloc.initWithFrame(frame)
    @offset_stepper.stepValue = 0.1
    @offset_stepper.minimumValue = -30.0
    @offset_stepper.maximumValue = 30.0
    self.addSubview @offset_stepper
    @offset_stepper.addTarget(self, action: :stepper_changed,forControlEvents: UIControlEventValueChanged)
  end
  def stepper_changed
    # puts "control_stepper #{@offset_stepper.value}"
    @offset = @offset_stepper.value
    @defaults["offset"] = @offset
  end
  def my_hide
    if @offset_stepper.isHidden
      # puts "unhide"
      @offset_stepper.setHidden(false)  
      # @offset_stepper.value = @offset 
      @device_clock_label.setHidden(false)  
    else
      # puts "Hide"
      @offset_stepper.setHidden(true)
      @device_clock_label.setHidden(true)
    end
  end
  
  def make_device_clock_label(frame)
    @device_clock_label = UILabel.alloc.initWithFrame frame
    @device_clock_label.text = "Device Clock #{current_tod_string}"
    # @device_clock_label.sizeToFit
    # @device_clock_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.addSubview @device_clock_label
  end

  def make_adjusted_clock_label(frame)
    @adjusted_clock_label = UILabel.alloc.initWithFrame frame
    @adjusted_clock_label.text = "#{current_tod_string}"
    font = UIFont.fontWithName('Helvetica', size:40)
    @adjusted_clock_label.font = font
    @device_clock_label.sizeToFit
    # @device_clock_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.addSubview @adjusted_clock_label
  end
     
  def make_offset_label(frame)
    @offset_label = UILabel.alloc.initWithFrame frame
    @offset_label.text = "Offset #{@offset}"
    self.addSubview @offset_label
  end
  
  def make_countdown_label(frame)
    @countdown_label = UILabel.alloc.initWithFrame frame
    @countdown_label.text = "Countdown #{@current_tod_string}"
    self.addSubview @countdown_label
  end
  
  def make_plus_minute_button
    @plus_minute_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_minute_button.setTitle("Minute+", forState:UIControlStateNormal)
    @plus_minute_button.sizeToFit
    @plus_minute_button.center = CGPointMake(200,275)
    self.addSubview @plus_minute_button
    
    @plus_minute_button.when(UIControlEventTouchUpInside) do
      @start_minute += 60
      tod = @start_minute
      min = "%02d" % tod.min
      sec = "%02d" % tod.sec
      tod_s = "#{tod.hour}:#{min}:#{sec}"
      @start_minute_label.text = "Target Time: #{tod_s}"
    end
  end
  
  def make_minus_minute_button
    @minus_minute_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_minute_button.setTitle("Minute-", forState:UIControlStateNormal)
    @minus_minute_button.sizeToFit
    @minus_minute_button.center = CGPointMake(100,275)
    self.addSubview @minus_minute_button
    
    @minus_minute_button.when(UIControlEventTouchUpInside) do
      @start_minute -= 60
      tod = @start_minute
      min = "%02d" % tod.min
      sec = "%02d" % tod.sec
      tod_s = "#{tod.hour}:#{min}:#{sec}"
      @start_minute_label.text = "Target Time: #{tod_s}"
    end
  end
  
  def make_start_minute_label
    @start_minute_label = UILabel.alloc.initWithFrame [[5,195],[185,32]]
    @start_minute_label.text = "Target Time #{@current_tod_string}"
    self.addSubview @start_minute_label
  end

  def make_minus_second_button
    @minus_second_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_second_button.setTitle("Second-", forState:UIControlStateNormal)
    @minus_second_button.sizeToFit
    @minus_second_button.center = CGPointMake(100,325)
    self.addSubview @minus_second_button
    
    @minus_second_button.when(UIControlEventTouchUpInside) do
      @start_minute -= 1
      tod = @start_minute
      min = "%02d" % tod.min
      sec = "%02d" % tod.sec
      tod_s = "#{tod.hour}:#{min}:#{sec}"
      @start_minute_label.text = "Target Time: #{tod_s}"
    end
  end
    
  def make_plus_second_button
    @plus_second_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_second_button.setTitle("Second+", forState:UIControlStateNormal)
    @plus_second_button.sizeToFit
    @plus_second_button.center = CGPointMake(200,325)
    self.addSubview @plus_second_button
    
    @plus_second_button.when(UIControlEventTouchUpInside) do
      @start_minute += 1
      tod = @start_minute
      min = "%02d" % tod.min
      sec = "%02d" % tod.sec
      tod_s = "#{tod.hour}:#{min}:#{sec}"
      @start_minute_label.text = "Target Time: #{tod_s}"
    end
  end
  
  def make_split_label(frame)
    @split_label = UILabel.alloc.initWithFrame frame
    @split_label.text = "TOD Offset"
    self.addSubview @split_label
  end
  
  def make_split_button(frame)
    @split_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @split_button.setTitle("TOD Offset", forState:UIControlStateNormal)
    @split_button.sizeToFit
    @split_button.frame = frame
    self.addSubview @split_button
    @split_button.when(UIControlEventTouchUpInside) do
      @split_label.text = "#{current_tod_string} #{current_tod_string_with_offset}"
      my_hide
    end
  end
   
  def make_plus_button
    @plus_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_button.setTitle("C+", forState:UIControlStateNormal)
    @plus_button.sizeToFit
    @plus_button.frame = [[45,120],[32,32]]
    self.addSubview @plus_button
    
    @plus_button.when(UIControlEventTouchUpInside) do
      @offset += 0.1
      @defaults["offset"] = @offset
    end
  end
  
  def make_minus_button
    @minus_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_button.setTitle("C-", forState:UIControlStateNormal)
    @minus_button.sizeToFit
    @minus_button.frame = [[5,120],[32,32]]
    self.addSubview @minus_button
    
    @minus_button.when(UIControlEventTouchUpInside) do
      @offset -= 0.1
      @defaults["offset"] = @offset
    end
  end
  

  # def push
  #   new_controller = TapController.alloc.initWithNibName(nil, bundle: nil)
  #   self.navigationController.pushViewController(new_controller,animated: true)
  # end
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Table",image: nil, tag: 1)
    
    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
    self 
  end
  
  def start_clock
    tn = Time.now
    @clock = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                               target: self,
                                               selector: "clockHandler:",
                                               userInfo: nil,
                                               repeats: true)
  end
  
  # all this does is increment a value for display
  def clockHandler(userInfo)
    @adjusted_time = Time.now + @offset
    
    # @label.text = "#{self.current_tod_string} "
    @device_clock_label.text = "Device Clock #{current_tod_string}"
    # puts "#{current_tod_string_with_offset} #{countdown_time}"
    @adjusted_clock_label.text = "#{current_tod_string_with_offset} #{countdown_time}"
    @offset_label.text = "Offset #{@offset.round(1)}"
    # @countdown_label.text = "Countdown: #{start_time_diff}"
    
    
    if NSUserDefaults.standardUserDefaults["computerEnabled"] == true
      @calc_controller.update_calcs
    end
    if NSUserDefaults.standardUserDefaults["calcMileageEnabled"] == true
      @calc_controller.calc_model.update_units_per_minute
    end
  end
  def countdown_time
    # puts "@model.calc_tod - @adjusted_time #{(@calc_controller.calc_tod - @adjusted_time).round}"
    
      # secs = (@calc_controller.calc_tod - @adjusted_time)
      # secs = (@calc_controller.calc_tod.to_f - @adjusted_time.to_f)
      # # puts "secs #{secs} #{@calc_controller.calc_tod.sec.to_f} #{@adjusted_time.sec.to_f} #{(@calc_controller.calc_tod.min - @adjusted_time.min) - 1} #{(@calc_controller.calc_tod.sec.to_f - @adjusted_time.sec.to_f) % 60 }"
      # # secs = (@calc_controller.calc_tod.to_i - @adjusted_time.to_i)
      # # puts "secs #{secs} #{secs.round} #{secs.to_i}"
      # seconds = secs
      # t = Time.at(seconds)
      # # puts "t #{t}"
      # min = "%02d" % t.min
      # sec = "%02d" % t.sec
      # tod_s = "#{min}:#{sec}"
      # # puts "tod_s #{tod_s}"
      # if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      #   # tod_secs = ((@calc_controller.calc_tod.sec.to_i) * 0.6).to_i
      #   tod_secs = @calc_controller.calc_tod.sec
      #   # adjusted_time_secs = (@adjusted_time.hour.to_i * 3600) + (@adjusted_time.min.to_i * 60) + @adjusted_time.sec.to_i
      #   # set_tod_secs = (@calc_controller.calc_tod.hour.to_i * 3600) + (@calc_controller.calc_tod.min.to_i * 60) + tod_secs
      #   adjusted_time_secs = (@adjusted_time.hour * 6000) + (@adjusted_time.min * 100) + @adjusted_time.sec
      #   set_tod_secs = (@calc_controller.calc_tod.hour * 6000) + (@calc_controller.calc_tod.min * 100) + tod_secs
      # else
      #   tod_secs = @calc_controller.calc_tod.sec.to_i
      #   adjusted_time_secs = (@adjusted_time.hour.to_i * 3600) + (@adjusted_time.min.to_i * 60)+ @adjusted_time.sec.to_i
      #   set_tod_secs = (@calc_controller.calc_tod.hour.to_i * 3600) + (@calc_controller.calc_tod.min.to_i * 60) + tod_secs
      # end
      # 
      # adjusted_time_secs = (@adjusted_time.min.to_i * 60) + @adjusted_time.sec.to_i
      # calc_time_secs = (@calc_controller.calc_tod.min.to_i * 60) + calc_secs
      # puts "COMPARE #{adjusted_time_secs} #{set_tod_secs} #{@adjusted_time} #{@calc_controller.calc_tod}"
    # puts "#{@calc_controller.calc_tod}  #{@adjusted_time}"  
    if @calc_controller.calc_tod <= @adjusted_time
    # if (adjusted_time_secs >= set_tod_secs) 
    # if (@adjusted_time.min.to_i >= @calc_controller.calc_tod.min.to_i) & (@adjusted_time.sec.to_i >= calc_secs)
      # puts "COMPARE #{adjusted_time_secs} #{set_tod_secs} #{@adjusted_time} #{@calc_controller.calc_tod}"
      ""  
      # puts "#{@calc_controller.calc_tod} #{adjusted_time_secs} >= #{set_tod_secs}"
    else
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        # tod_s
        # puts "seconds_to_cents #{seconds_to_cents(t)}"
        cents = ((@calc_controller.calc_tod.to_f - @adjusted_time.to_f) % 60) * 1.6667
        cents = ((@calc_controller.calc_tod - (Time.now + @offset)) % 60) * 1.6667
        # secs = (@calc_controller.calc_tod.to_f - @adjusted_time.to_f)
        secs = (@calc_controller.calc_tod - (Time.now + @offset))
        tt = Time.at(secs)
        mins = tt.min
        
        # puts "#{mins}.#{"%02.0f" % cents}  #{@calc_controller.calc_tod} - #{@adjusted_time} #{secs.class}"
        # puts " #{(@calc_controller.calc_tod.min - @adjusted_time.min) - 1} #{((@calc_controller.calc_tod.sec.to_f - @adjusted_time.sec.to_f) % 60) *1.6667 }"
        
        tod_s = " (#{"%02d" % mins}.#{"%02.0f" % cents})"
        # tod_s = " (#{"%02d" % t.min}.#{"%02d" % seconds_to_cents(t)})"
        # sec_diff = (@calc_controller.calc_tod - @adjusted_time)
        # ct = Time.at(sec_diff)
        # tod_s = " (#{"%02d" % t.min}.#{"%02d" % seconds_to_cents(ct)})"
        # 
        # ms_c_tod = @calc_controller.calc_tod.to_f 
        # ms_tod = Time.now.to_f + @offset
        # ms_diff = ms_c_tod - ms_tod
        # cent_diff = (ms_diff) * (1.6667)
        # puts "cent_diff #{cent_diff}"
        # # tod_s += "  #{"%2.0f" % cent_diff
        # tod_s = " (#{"%02d" % t.min}.#{"%02.0f" % cent_diff})"
        # puts "secs #{secs} #{@calc_controller.calc_tod.sec.to_f} #{@adjusted_time.sec.to_f} #{(@calc_controller.calc_tod.min - @adjusted_time.min) - 1} #{((@calc_controller.calc_tod.sec.to_f - @adjusted_time.sec.to_f) % 60) *1.6667 }"
        # tod_s =  "#{(@calc_controller.calc_tod.min - @adjusted_time.min) - 1}.#{"%02.0f" % (((@calc_controller.calc_tod.sec.to_f - tod.sec.to_f) % 60) * 1.6667)}"
        
      else
        "(#{tod_s})"
        tod_s =  "#{(@calc_controller.calc_tod.min - @adjusted_time.min) - 1}:#{"%02.0f" % ((@calc_controller.calc_tod.sec.to_f - @adjusted_time.sec.to_f) % 60)}"
        
      end
    end
  end
  
  def start_time_diff
    td = @start_minute - (Time.now + @offset)
    # return td.round
    return td
  end
  def start_tod_string
    tod = @start_minute
    min = "%02d" % tod.min
    sec = "%02d" % tod.sec
    tod_s = "#{tod.hour}:#{min}:#{sec}"
    tod_s
  end
  def current_tod_string
    tod = Time.now
    min = "%02d" % tod.min
    sec = "%02d" % tod.sec
    tod_s = "#{tod.hour}:#{min}:#{sec}"
    tod_s
  end  
  def current_tod_string_with_offset
    tod = Time.now + @offset
    min = "%02d" % tod.min
    sec = "%02d" % tod.sec
    # tod_s = "#{tod.hour}:#{min}:#{sec}(#{seconds_to_cents(tod.sec)})"
    # tod_s
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      # tod_s = "#{tod.hour}:#{min}:#{sec}/#{seconds_to_cents(tod.sec)}"
      cents = "%02d" % seconds_to_cents(tod)
      tod_s = "#{tod.hour}:#{min}.#{cents}"
      # tos_s = "#{tod.strftime('%H:%M.')}#{seconds_to_cents(tod.strftime('%S:%M.'))}"
      
    else
      # tod_s = "#{tod.hour}:#{min}:#{sec}"
      tod_s = tod.strftime('%H:%M:%S')
    end
    tod_s
  end
  def current_tod_string_with_offset_and_car_number
    car_number = 5
    tod = Time.now + @offset - (car_number * 60)
    tod_s = "#{tod.hour}:#{tod.min}:#{tod.sec}"
    tod_s
  end
  def seconds_to_cents(tod)
    # return (seconds * ((1.6667)/100)).round(2)
    ms = tod.strftime('%3N').to_f
    cents = (tod.sec + (ms/1000)) * (1.6667)
    # puts "#{tod.strftime('%H:%M:%S')} #{cents} #{ms}"
    cents
  end
end