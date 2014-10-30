class SpeedView < UIView
  attr_accessor :current_speed,:next_speed
  
  PLUSBACKGROUNDCOLOR = 0xd7d7d7
  MINUSBACKGROUNDCOLOR = 0x4CD964
  def initWithFrame frame
    super
    @current_speed = 36.0
    @next_speed = 40.0
    make_current_speed_label
    make_next_speed_label
    make_minus_ten_button
    make_minus_one_button
    make_minus_dec_button
    make_plus_ten_button
    make_plus_one_button
    make_plus_dec_button
    self
  end
  
  def update_current_speed
    @current_speed = @next_speed
    @current_speed_label.text = "#{format("%2.1f",@current_speed)}"
  end
  
  def update_next_speed(ammount)
    unless (@next_speed + ammount) < 0.0
      @next_speed = @next_speed + ammount
      puts "update next - ammount #{ammount}"
      @next_speed_label.text = "#{format("%2.1f",@next_speed)}"
    end
  end
  def make_current_speed_label
    # @current_speed_label = UILabel.alloc.initWithFrame [[60,0],[170,60]]
    @current_speed_label = UILabel.alloc.initWithFrame [[120,172],[160,60]]
    
    @current_speed_label.text = "#{format("%2.1f",@current_speed)}"
    @current_speed_label.font = UIFont.fontWithName('Helvetica', size:64)
    @current_speed_label.backgroundColor = 0xd1eefc.uicolor
    # @current_speed_label.textColor = UIColor.whiteColor
    # @current_speed_label.textAlignment = UITextAlignmentRight
    self.addSubview @current_speed_label
  end
  
  def make_next_speed_label
    # @next_speed_label = UILabel.alloc.initWithFrame [[160,0],[140,64]]
    @next_speed_label = UILabel.alloc.initWithFrame [[60,0],[170,60]]
    
    # @next_speed_label = UILabel.alloc.initWithFrame [[120,172],[160,60]]
    @next_speed_label.text = "#{format("%2.1f",@next_speed)}"
    @next_speed_label.font = UIFont.fontWithName('Helvetica', size:48)
    # @next_speed_label.backgroundColor = UIColor.blackColor
    # @next_speed_label.textColor = UIColor.whiteColor
    # @next_speed_label.textAlignment = UITextAlignmentRight
    self.addSubview @next_speed_label
  end

  def make_plus_ten_button
    @plus_ten_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_ten_button.setTitle("10", forState:UIControlStateNormal)
    @plus_ten_button.sizeToFit
    @plus_ten_button.frame = [[60,55],[60,60]]
    @plus_ten_button.font = UIFont.fontWithName('Helvetica', size:32)
    @plus_ten_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_ten_button
    @plus_ten_button.when(UIControlEventTouchUpInside) do
      puts "10"
      update_next_speed(10.0)
    end
  end
  
  def make_plus_one_button
    @plus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_one_button.setTitle("1", forState:UIControlStateNormal)
    @plus_one_button.frame = [[120,55],[60,60]]
    @plus_one_button.font = UIFont.fontWithName('Helvetica', size:32) 
    @plus_one_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_one_button
    @plus_one_button.when(UIControlEventTouchUpInside) do
      update_next_speed(1.0)
    end
  end
  def make_plus_dec_button
    @plus_dec_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_dec_button.setTitle(".1", forState:UIControlStateNormal)
    @plus_dec_button.frame = [[180,55],[60,60]]
    @plus_dec_button.font = UIFont.fontWithName('Helvetica', size:32)  
    @plus_dec_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor  
    self.addSubview @plus_dec_button
    @plus_dec_button.when(UIControlEventTouchUpInside) do
      update_next_speed(0.1)
    end
  end
  def make_minus_ten_button
    @minus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_one_button.setTitle("-10", forState:UIControlStateNormal)
    @minus_one_button.sizeToFit
    @minus_one_button.frame = [[60,115],[60,60]]
    @minus_one_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_one_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.addSubview @minus_one_button
    @minus_one_button.when(UIControlEventTouchUpInside) do
      update_next_speed(-10.0)
    end
  end
  
  def make_minus_one_button
    @minus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_one_button.setTitle("-1", forState:UIControlStateNormal)
    @minus_one_button.frame = [[120,115],[60,60]]
    @minus_one_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_one_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_one_button
    @minus_one_button.when(UIControlEventTouchUpInside) do
      update_next_speed(-1.0)
    end
  end
  def make_minus_dec_button
    @minus_dec_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_dec_button.setTitle("-.1", forState:UIControlStateNormal)
    @minus_dec_button.frame = [[180,115],[60,60]]
    @minus_dec_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_dec_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_dec_button
    @minus_dec_button.when(UIControlEventTouchUpInside) do
      update_next_speed(-0.1)
    end
  end
end