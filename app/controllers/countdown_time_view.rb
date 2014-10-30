class CoundownTimeView < UIView
  attr_accessor :clock, :due_time
  
  def initWithFrame frame
    super
 
    make_countdown_view
    start_clock
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

  def clockHandler(userInfo)
    if @due_time.nil?
      @due_time = Time.now
    end
    diff = @due_time - Time.now
    if diff < 0 
      diff = 9
    end
    counter_text(diff.to_s)
  end
  
  def counter_text(count_text)
    @counter_label.text = count_text
  end
  
  def make_countdown_view
    @counter_label = UILabel.alloc.initWithFrame [[0,0],[100,40]]
    @counter_label.font = UIFont.fontWithName('Helvetica', size:64)
    self.counter_text('0')
    self.addSubview(@counter_label)
  end
end

