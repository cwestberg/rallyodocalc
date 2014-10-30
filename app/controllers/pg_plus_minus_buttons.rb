# create plus and minus buttons for 1, 0.1 and 0.01 and update target when pressed
class PGPlusMinusButtonsView < UIView
  attr_accessor :model,:seconds_or_cents
  PLUSBACKGROUNDCOLOR = 0xd7d7d7
  MINUSBACKGROUNDCOLOR = 0x4CD964  
  def initWithFrame frame
    super
    make_minus_one_button
    make_minus_tenth_button
    make_minus_cent_button
    make_plus_one_button
    make_plus_tenth_button
    make_plus_cent_button
    is_seconds = false
    
    self
  end
 
  def set_labels_and_values
    if NSUserDefaults.standardUserDefaults["cents_timing"] == true
      @one_minute_title = "1"
      @one_tenth_title = "0.1"
      @one_minute_title = "0.01"
      @one_tenth_value = 1
      @one_cent_value = 0.1
      @one_cent_value = 0.01
    else
      @one_minute_title = "60"
      @one_tenth_title = "10"
      @one_cent_title = "1"
      @one_minute_value = 1
      @one_tenth_value = 16.6667
      @one_cent_value = 1.6667
    end
  end
  
  # if NSUserDefaults.standardUserDefaults["cents_timing"] == true
  #   @model.model.calc(0.01)
  # else
  #   @model.model.calc(0.016667)
  # end
  
  def make_plus_one_button
    @plus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_one_button.setTitle("1", forState:UIControlStateNormal)
    @plus_one_button.sizeToFit
    @plus_one_button.frame = [[0,0],[60,60]]
    @plus_one_button.font = UIFont.fontWithName('Helvetica', size:32)
    @plus_one_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_one_button
    @plus_one_button.when(UIControlEventTouchUpInside) do
      @model.model.calc(1.0)
      @model.update_view
    end
  end
  
  def make_plus_tenth_button
    @plus_tenth_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_tenth_button.setTitle(".1", forState:UIControlStateNormal)
    @plus_tenth_button.frame = [[60,0],[60,60]]
    @plus_tenth_button.font = UIFont.fontWithName('Helvetica', size:32) 
    @plus_tenth_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    
    self.addSubview @plus_tenth_button
    @plus_tenth_button.when(UIControlEventTouchUpInside) do
      # @model.model.calc(0.1)
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        @model.model.calc(0.1)
      else
        @model.model.calc(0.16667)
      end
      @model.update_view    
    end
  end
  def make_plus_cent_button
    @plus_cent_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_cent_button.setTitle(".01", forState:UIControlStateNormal)
    @plus_cent_button.frame = [[120,0],[60,60]]
    @plus_cent_button.font = UIFont.fontWithName('Helvetica', size:32)  
    @plus_cent_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_cent_button
    @plus_cent_button.when(UIControlEventTouchUpInside) do
      # @model.model.calc(0.01)
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        @model.model.calc(0.01)
      else
        @model.model.calc(0.016667)
      end
      @model.update_view
    end
  end
  def make_minus_one_button
    @minus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_one_button.setTitle("1", forState:UIControlStateNormal)
    @minus_one_button.sizeToFit
    @minus_one_button.frame = [[0,60],[60,60]]
    @minus_one_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_one_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.addSubview @minus_one_button
    @minus_one_button.when(UIControlEventTouchUpInside) do
      @model.model.calc(-1.0)
      @model.update_view      
    end
  end
  
  def make_minus_tenth_button
    @minus_tenth_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_tenth_button.setTitle(".1", forState:UIControlStateNormal)
    @minus_tenth_button.frame = [[60,60],[60,60]]
    @minus_tenth_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_tenth_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_tenth_button
    @minus_tenth_button.when(UIControlEventTouchUpInside) do
      # @model.model.calc(-0.1)
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        @model.model.calc(-0.1)
      else
        @model.model.calc(-0.16667)
      end
      @model.update_view
    end
  end
  def make_minus_cent_button
    @minus_cent_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_cent_button.setTitle(".01", forState:UIControlStateNormal)
    @minus_cent_button.frame = [[120,60],[60,60]]
    @minus_cent_button.backgroundColor = MINUSBACKGROUNDCOLOR.uicolor
    @minus_cent_button.font = UIFont.fontWithName('Helvetica', size:32)    
    self.addSubview @minus_cent_button
    @minus_cent_button.when(UIControlEventTouchUpInside) do
      # @model.model.calc(-0.01)
      if NSUserDefaults.standardUserDefaults["cents_timing"] == true
        @model.model.calc(-0.01)
      else
        @model.model.calc(-0.016667)
      end
      @model.update_view
    end
  end
  

end

