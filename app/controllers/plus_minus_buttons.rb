# create plus and minus buttons for 1, 0.1 and 0.01 and update target when pressed
class PlusMinusButtonsView < UIView
  attr_accessor :model
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

    self
  end

  def make_plus_one_button
    @plus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_one_button.setTitle("1", forState:UIControlStateNormal)
    @plus_one_button.sizeToFit
    @plus_one_button.frame = [[0,0],[60,60]]
    @plus_one_button.font = UIFont.fontWithName('Helvetica', size:32)
    @plus_one_button.backgroundColor = PLUSBACKGROUNDCOLOR.uicolor
    self.addSubview @plus_one_button
    @plus_one_button.when(UIControlEventTouchUpInside) do
      @model.add_one
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
      @model.add_one_tenth
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
      @model.add_one_cent
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
      @model.minus_one
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
      @model.minus_one_tenth
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
      @model.minus_one_cent
    end
  end
  

end

