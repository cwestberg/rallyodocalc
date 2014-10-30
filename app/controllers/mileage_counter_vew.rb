class MileageCounterView < UIView
  attr_accessor :odo_model,:odometer_label,:odometer
  
  def initWithFrame frame
    super
    @odometer = 0.00
    make_odometer_label
    unless UIDevice.currentDevice.model.include?("iPad")
      make_plus_1_button
      make_plus_tenth_button
      make_plus_cent_button
      make_minus_1_button
      make_minus_tenth_button
      make_minus_cent_button
    end
    self
  end
  
  def add_one
    @odo_model.mileage += 1.0.round(3)
    # (@odo_model.mileage += 1.0).round(3)
    update_mileage_view
  end
  def add_one_tenth
    @odo_model.mileage += 0.1.round(3)
    # (@odo_model.mileage += 0.1).round(3)
    update_mileage_view
  end
  def add_one_cent
    @odo_model.mileage += 0.01.round(3)
    # (@odo_model.mileage += 0.01).round(3)
    update_mileage_view
  end
  def minus_one
    if (@odo_model.mileage - 1.0) < 0.0
      @odo_model.mileage = 0.0
    else
      @odo_model.mileage -= 1.0.round(3)
    end
    update_mileage_view
  end
  def minus_one_tenth
    if (@odo_model.mileage - 0.1) < 0.0
      @odo_model.mileage = 0.0
    else
      @odo_model.mileage -= 0.1.round(3)
    end
    update_mileage_view
  end
  def minus_one_cent
    if (@odo_model.mileage - 0.01) < 0.0
      @odo_model.mileage = 0.0
    else
      @odo_model.mileage -= 0.01.round(3)
    end
    update_mileage_view
  end
  
  
  def zero_mileage
    @odo_model.zero_mileage
    update_mileage_view
  end
  def make_odometer_label
    @odometer_label = UILabel.alloc.initWithFrame [[2,24],[220,64]]
    @odometer_label.text = "#{format("%7.2f",0.00)}"
    @odometer_label.font = UIFont.fontWithName('Helvetica', size:64)
    @odometer_label.backgroundColor = UIColor.blackColor
    @odometer_label.textColor = UIColor.whiteColor
    @odometer_label.textAlignment = UITextAlignmentRight
    self.addSubview @odometer_label
  end

  def update_mileage_view
    @odometer_label.text = "#{format("%7.2f",@odo_model.mileage)}"
  end
  def set_odometer_text(mileage)
    @odo_model.mileage = mileage unless @odo_model.nil?  
    # @odometer_label.text = "#{format("%7.3f",mileage)}"
    update_mileage_view
  end
  def make_plus_1_button
    @plus_1_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_1_button.setTitle("+.", forState:UIControlStateNormal)
    # @plus_1_button.backgroundColor = UIColor.greenColor
    
    @plus_1_button.frame = [[30,0],[60,42]]
    @plus_1_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.addSubview @plus_1_button
    @plus_1_button.when(UIControlEventTouchUpInside) do
      (@odo_model.mileage += 1.0).round(3)
      update_mileage_view
    end
  end
  def make_plus_tenth_button
    @plus_tenth_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_tenth_button.setTitle(".+", forState:UIControlStateNormal)
    @plus_tenth_button.frame = [[90,0],[60,42]]
    @plus_tenth_button.font = UIFont.fontWithName('Helvetica', size:32)
    # @plus_tenth_button.backgroundColor = UIColor.greenColor
    
    self.addSubview @plus_tenth_button
    @plus_tenth_button.when(UIControlEventTouchUpInside) do
      (@odo_model.mileage += 0.1).round(3)
      update_mileage_view
    end
  end
  def make_plus_cent_button
    @plus_cent_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_cent_button.setTitle(".++", forState:UIControlStateNormal)
    @plus_cent_button.frame = [[150,0],[60,42]]
    @plus_cent_button.font = UIFont.fontWithName('Helvetica', size:32)
    # @plus_cent_button.backgroundColor = UIColor.greenColor
    
    self.addSubview @plus_cent_button
    @plus_cent_button.when(UIControlEventTouchUpInside) do
      (@odo_model.mileage += 0.01).round(3)
      update_mileage_view
    end
  end
  def make_minus_1_button
    @minus_1_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_1_button.setTitle("-.", forState:UIControlStateNormal)
    @minus_1_button.sizeToFit
    @minus_1_button.frame = [[30,60],[60,48]]
    @minus_1_button.font = UIFont.fontWithName('Helvetica', size:40)
    # @minus_1_button.backgroundColor = UIColor.greenColor
    
    self.addSubview @minus_1_button
    @minus_1_button.when(UIControlEventTouchUpInside) do
      if (@odo_model.mileage - 1.0) < 0.0
        @odo_model.mileage = 0.0
      else
        @odo_model.mileage -= 1.0
      end
      update_mileage_view
    end
  end
  def make_minus_tenth_button
    @minus_tenth_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_tenth_button.setTitle(".-", forState:UIControlStateNormal)
    @minus_tenth_button.frame = [[90,60],[60,48]]
    @minus_tenth_button.font = UIFont.fontWithName('Helvetica', size:32)
    # @minus_tenth_button.backgroundColor = UIColor.greenColor
    
    self.addSubview @minus_tenth_button
    @minus_tenth_button.when(UIControlEventTouchUpInside) do
      if (@odo_model.mileage - 0.1) < 0.0
        @odo_model.mileage = 0.0
      else
        @odo_model.mileage -= 0.1
      end
      update_mileage_view
    end
  end
  def make_minus_cent_button
    @minus_cent_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_cent_button.setTitle(".--", forState:UIControlStateNormal)
    @minus_cent_button.frame = [[150,60],[60,48]]
    @minus_cent_button.font = UIFont.fontWithName('Helvetica', size:32)
    # @minus_cent_button.backgroundColor = UIColor.greenColor
    
    self.addSubview @minus_cent_button
    @minus_cent_button.when(UIControlEventTouchUpInside) do
      if (@odo_model.mileage - 0.01) < 0.0
        @odo_model.mileage = 0.0
      else
        @odo_model.mileage -= 0.01
      end
      update_mileage_view
    end
  end
end