class ChangeSpeed < UIView
  attr_accessor :next_speed_view, :current_speed_view
  
  def initWithFrame frame
    super
    make_view
    self
  end
  
  def make_view
    @change_speed_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @change_speed_button.setTitle("<", forState:UIControlStateNormal)
    @change_speed_button.sizeToFit
    @change_speed_button.frame = [[0,50],[40,32]]
    @change_speed_button.font = UIFont.fontWithName('Helvetica', size:40)
    @change_speed_button.backgroundColor = UIColor.redColor
    self.addSubview @change_speed_button
    puts "added dubview"
    @change_speed_button.when(UIControlEventTouchUpInside) do
      puts "update cast #{@next_speed_view.speed}"
      @current_speed_view.cast(@next_speed_view.speed)
    end
    puts "done"
  end
  
end