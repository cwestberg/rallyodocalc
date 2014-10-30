class CalcControllerView < UIView
  attr_accessor :delta,:background_color,:model,:speed,:calc_mileage_view,:time_controller,:delta_view,:odo_model,:calc_view,:tod_view
  
  def initWithFrame frame
    super
    @speed = 36
    make_view
    self
  end

  def make_view
    @calc_view = UILabel.alloc.initWithFrame([[0,30], [200, 80]])
    @calc_view.text = "#{format("%7.2f",0.00)}"
    @calc_view.font = UIFont.fontWithName('Helvetica', size:64)
    @calc_view.textAlignment = UITextAlignmentRight
    
    self.addSubview @calc_view
    @tod_view = UILabel.alloc.initWithFrame([[0,0], [200, 40]])
    @tod_view.text = "#{format("%7.2f",0.00)}"
    @tod_view.font = UIFont.fontWithName('Helvetica', size:32)
    @tod_view.textAlignment = UITextAlignmentRight
    
    self.addSubview @tod_view
  end
  
  def update_view
    # puts "NSUserDefaults.standardUserDefaults['cents_timing'] #{NSUserDefaults.standardUserDefaults['cents_timing']}"

    tod = @model.calc_seconds
    min = "%02d" % tod.min
    sec = "%02d" % tod.sec
    @delta = (tod - @time_controller.adjusted_time)
    
    # puts "adjusted time is #{@time_controller.adjusted_time}"
    
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      # puts "cents"
      @calc_view.text = "#{format("%7.2f",@model.calc_time)}" 
      # @tod_view.text = "#{tod.hour}:#{min}:#{(sec.to_f * 1.6667).round}  #{(delta * 1.6667).round}"
      cent_part = (sec.to_f * 1.6667).round
      @tod_view.text = "#{tod.hour}:#{min}.#{format("%02d",cent_part)}"
      @delta_view.text = "#{(@delta * 1.6667).round}"
      
    else
      @calc_view.text = @model.calc_time_as_seconds
      calc_distance = nil
      if NSUserDefaults.standardUserDefaults["calcMileageEnabled"] == true
        calc_distance = @model.calc_distance.round(2)
      end
      # @tod_view.text = "#{tod.hour}:#{min}:#{sec}  #{delta.round}  #{calc_distance}"
      puts "tod.sec #{tod.sec}"
      @tod_view.text = "#{tod.hour}:#{min}:#{sec} #{calc_distance}"
      # @tod_view.text = "#{tod.hour}:#{min}:#{sec}  #{(delta*0.6).round}  #{calc_distance}"
      # puts "seconds"
      @delta_view.text = "#{@delta.round}"
    end
    
    @calc_mileage_view.update_view
  end
  # Model API
  def calc_tod
    @model.calc_tod
  end
  def update_calcs
    match(@odo_model.mileage)
  end
  def set_calc_tod(tod)
    @model.calc_tod = tod
    @model.zero
    update_view
  end
  def zero
     @model.zero
     update_view
  end
  def match(current_mileage)
     @model.crank_match(current_mileage)
     update_view
  end
  def add_one
     @model.crank(1.0)
     update_view
  end
  def add_one_tenth
   @model.crank(0.1)
   update_view
  end
  def add_one_cent
   @model.crank(0.01)
   update_view
  end
  def minus_one
   @model.crank(-1.0)
   update_view
  end
  def minus_one_tenth
   @model.crank(-0.1)
   update_view
  end
  def minus_one_cent
   @model.crank(-0.01)
   update_view
  end
end

