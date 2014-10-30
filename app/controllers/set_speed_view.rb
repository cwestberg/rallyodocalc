class SetSpeedView < UIView
  attr_accessor :speed,:model
  
  def initWithFrame frame
    super
    @speed = 36
    make_speed_view(frame)
    self
  end
  
  def cast(value)
    @speed = value
    @speed_label.text = "#{@speed}"
    @model.cast = @speed
  end

  
  def make_speed_view(frame)
    @speed_label = UILabel.alloc.initWithFrame frame
    @speed_label.font = UIFont.fontWithName('Helvetica', size:64)
    @speed_label.text = "#{@speed}"
    # @speed_label.backgroundColor = UIColor.yellowColor
    
    self.addSubview(@speed_label)
    @minus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_one_button.setTitle("-", forState:UIControlStateNormal)
    @minus_one_button.sizeToFit
    [[580,270], [240, 64]]
    @minus_one_button.frame = [[0,50],[40,32]]
    @minus_one_button.font = UIFont.fontWithName('Helvetica', size:40)
    self.addSubview @minus_one_button
    @minus_one_button.when(UIControlEventTouchUpInside) do
      if (@speed - 1) < 0
        @speed = 0
      else
        @speed -= 1
      end      
      @speed_label.text = "#{@speed}"
      @model.cast = @speed unless @model.nil?
    end
    @plus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_one_button.setTitle("+", forState:UIControlStateNormal)
    @plus_one_button.sizeToFit
    @plus_one_button.frame = [[50,50],[40,32]]
    @plus_one_button.font = UIFont.fontWithName('Helvetica', size:40)
    self.addSubview @plus_one_button
    @plus_one_button.when(UIControlEventTouchUpInside) do
      @speed += 1
      @speed_label.text = "#{@speed}"
      @model.cast = @speed unless @model.nil?
    end
  end
end

