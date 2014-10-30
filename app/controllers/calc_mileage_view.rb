class CalcMileageView < UIView
  attr_accessor :model,:background_color
  
  def initWithFrame frame
    super
    @speed = 36
    make_view
    self
  end

  def make_view
    @view = UILabel.alloc.initWithFrame([[0,0], [300, 80]])
    @view.text = "#{format("%7.2f",0.00)}"
    @view.font = UIFont.fontWithName('Helvetica', size:64)
    @view.backgroundColor = @background_color unless @background_color.nil?
    self.addSubview @view
  end
  
  def update_view
    # puts "update_view #{@model.calc_mileage.round(3)} #{@model.cast}"
    @view.text = "#{format("%7.2f",@model.calc_mileage)}"
  end

end

