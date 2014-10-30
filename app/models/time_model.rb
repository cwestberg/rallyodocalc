class TimeModel
  PROPERTIES = [:offset,:tod]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }

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
    @device_clock_label.text = "Device Clock #{current_tod_string}"
    @adjusted_clock_label.text = "#{current_tod_string_with_offset}"
    @offset_label.text = "Offset #{@offset.round(1)}"
  end
end
