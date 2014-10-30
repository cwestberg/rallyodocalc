class DistanceController < UIViewController
  # include BubbleWrap  
  include BW::KVO
  attr_accessor :taps_mode,:manual_mode,:table,:daylight_background_color,:old_location,:odo_model,:aux_odo_model,:factor,:odometer,:locationManager,:lm_started,:counter,:direction,:calc_model

  def viewDidLoad
    super
    @odometer = 0.0
    @aux_odometer = 0.0
    @direction = 'forward'
    @counter=0
    @manual_mode=false
    @taps_mode=false
    (UIApplication.sharedApplication).idleTimerDisabled = true
    
    # meters_to_km = 0.001
    #    meters_to_miles = 0.00062137
    start_stop_zero_x = 125
   
    # if NSUserDefaults.standardUserDefaults["units"] == false
    #   puts MetersToMiles
    # else
    #   puts MetersToKM
    # end    
    
    @defaults = NSUserDefaults.standardUserDefaults
    # puts @defaults['offset']
    # puts @defaults[:factor]
    if @defaults[:factor].nil?
      @factor = 1.0
    else
     @factor = @defaults[:factor]
    end
    
    # self.view.backgroundColor = UIColor.whiteColor
    # self.view.backgroundColor = 0xf7f7f7.uicolor  #very light gray
    # self.view.backgroundColor = 0xd1eefc.uicolor  #light blue
    # self.# view.backgroundColor = 0xe0f8d8.uicolor  #light green
    # self.view.backgroundColor = UIColor.lightGrayColor
    # self.view.backgroundColor = UIColor.blackColor
    self.title = "Odo"
    self.navigationItem.title = "Odo"    
    @daylight_background_color = 0xe0f8d8.uicolor  #light green
    # @daylight_background_color = 0xff1300.uicolor  #red 
    # Add code to set da/night background color
    self.view.backgroundColor = @daylight_background_color
    
    make_factor_field([[360, 70], [80, 32]])
    make_aux_odometer_label([[15,150],[220,64]])
    make_reset_aux_button([[240,160],[48,48]])
    # make_forward_button([[150,216],[70,48]])
    # make_reverse_button([[40,216],[70,48]])
    make_forward_button([[40,216],[70,48]])
    make_reverse_button([[150,216],[70,48]])
    
    make_factor_button([[330,22],[120,48]])
    make_debug_label([[10,270],[460,32]] )
    make_start_button([[240,230], [80, 32]])
    # make_stop_button([[330,216],[80,48]])
    make_zero_button([[240,60],[48,48]])
    make_units_label([[100,20], [80, 60]])
    
    @odo_model = DistanceModel.new(:mileage=>0.0)
    @mileage_view = MileageCounterView.alloc.initWithFrame(CGRectMake(10,40,230,100))
    @mileage_view.odo_model = @odo_model
    self.view.addSubview @mileage_view
    
    @speed_view = SpeedView.alloc.initWithFrame(CGRectMake(540,40,180,240))
    self.view.addSubview @speed_view
    make_change_speed_button([[530,224],[120,40]])   # CAST button
    # make_change_speed_button([[550,120],[120,40]])   # CAST button
    # make_speedometer_view([[self.view.frame.size.height - 140,600],[80,80]])
    make_speedometer_view([[900,600],[80,80]])
    
    # puts "UIDevice.currentDevice #{UIDevice.currentDevice.model}"
    if UIDevice.currentDevice.model.include?("iPad")
      make_park_switch([[260,120],[80,48]])
      make_mph_park_switch([[360,120],[80,48]])
      make_manual_switch([[360,180],[80,48]])
      make_taps_switch([[360,240],[80,48]])
      
      # make_checkpoint_button([[self.view.frame.size.height - 100,80], [80, 80]])
      # make_split_button([[self.view.frame.size.height - 20,80],[80,80]])
      make_checkpoint_button([[800,80], [80, 80]])
      make_split_button([[900,80],[80,80]])
      
      # make_split_label([[self.view.frame.size.height - 150,20],[220,48]])
      make_split_label([[690,20],[300,48]])
      # make_split_button([[self.view.frame.size.height - 140,20],[120,48]])
      # make_split_label([[self.view.frame.size.height - 250,120],[220,40]])      
      @calc_model = CalculationModel.new
      @calc_model.my_controller = self
      
      # @rally_time_picker = RallyTimePickerView.alloc.initWithFrame([[600,520],[200,100]])
      @rally_time_picker = CircularRallyTimePickerView.alloc.initWithFrame([[600,520],[200,100]])
      make_next_minute_button([[580,650],[300,100]])
      # @rally_time_picker = RallyTimePickerView.alloc.initWithFrame([[210,520], [240, 140]])
      self.view.addSubview @rally_time_picker
      
      # @rally_time_view = RallyTimeView.alloc.initWithFrame(CGRectMake(600,540,180,240))
      # self.view.addSubview @rally_time_view
      # @rally_time_picker = @rally_time_view
      
      
      # [[210,400], [240, 140]]
      
      @dist_label = UILabel.alloc.initWithFrame [[90,364], [100, 32]]
      @dist_label.text = "+/- D"
      @dist_label.font = UIFont.fontWithName('Helvetica', size:24)
      self.view.addSubview @dist_label
      
      @plus_minus_view = PlusMinusButtonsView.alloc.initWithFrame([[10,400], [240, 140]])
      @plus_minus_view.model = @mileage_view
      self.view.addSubview(@plus_minus_view)      
      
      
      @calc_mileage_view = CalcMileageView.alloc
      @calc_mileage_view.backgroundColor = @daylight_background_color
      @calc_mileage_view.initWithFrame([[10,300], [240, 64]])
      @calc_mileage_view.model = @calc_model
      self.view.addSubview(@calc_mileage_view)
      
      
      @calc_controller_view = CalcControllerView.alloc
      @calc_controller_view.backgroundColor = @daylight_background_color
      @calc_controller_view.initWithFrame([[580,270], [240, 64]])
      @calc_controller_view.model = @calc_model
      
      @calc_controller_view.calc_mileage_view = @calc_mileage_view
      self.view.addSubview(@calc_controller_view)
      
      # make_delta_view([[420,430],[180,60]])
      make_delta_view([[210,300],[180,60]])
      @calc_controller_view.delta_view = @delta_label
      
      # make_next_speed_picker([[680,60],[120,80]])
      # make_speedometer_view_2([[550,200],[200,64]])   # Speedometer
      # make_change_speed_button([[550,120],[120,40]])   # CAST button
      # make_current_speed_view([[540,60],[140,60]]) # Current CAST
      
      @cm_label = UILabel.alloc.initWithFrame [[690,364], [100, 32]]
      @cm_label.text = "+/- CM"
      @cm_label.font = UIFont.fontWithName('Helvetica', size:24)
      self.view.addSubview @cm_label

      @calc_plus_minus_view = PlusMinusButtonsView.alloc.initWithFrame([[600,400], [240, 140]])
      @calc_plus_minus_view.model = @calc_controller_view
      self.view.addSubview(@calc_plus_minus_view)
      if NSUserDefaults.standardUserDefaults["hide_cm"] == true
        @cm_label.setHidden(true)  
        @calc_plus_minus_view.setHidden(true)  
      end
      
      # @pg_label = UILabel.alloc.initWithFrame [[290,364], [100, 32]]
      # @pg_label.text = "P/G"
      # @pg_label.font = UIFont.fontWithName('Helvetica', size:24)
      # self.view.addSubview @pg_label
      
      self.make_pause_button([[220,364], [32, 32]])
      self.make_gain_button([[300,364], [32, 32]])
      # self.make_ta_button([[250,364], [32, 32]])
      
      # @pause_gain_view = PGPlusMinusButtonsView.alloc.initWithFrame([[210,400], [240, 140]])
      # @pause_gain_view.model = @calc_controller_view
      # self.view.addSubview(@pause_gain_view)
      
      @pause_gain_view = PGPickerView.alloc.initWithFrame([[210,400], [240, 140]])
      self.view.addSubview @pause_gain_view
      
      # make_match_calc_button([[self.view.frame.size.height - 140,200], [80,80]])
      make_match_calc_button([[900,200], [80,80]])
      #       make_set_calc_tod_button([[self.view.frame.size.height - 140,540], [160, 32]])
      # make_current_speed_view([[550,60],[80,60]]) # Current CAST
      # make_speedometer_view_2([[550,120],[120,64]])   # Speedometer

      # set operational options
      # if NSUserDefaults.standardUserDefaults["zero_calc"] == true
      #   make_zero_calc_button([[self.view.frame.size.height - 140,400], [160, 32]])
      # end
      # if NSUserDefaults.standardUserDefaults["set_tod"] == true
      #   make_set_calc_tod_button([[self.view.frame.size.height - 140,540], [160, 32]])
      # end
      # if NSUserDefaults.standardUserDefaults["trm_out"] == true
      # make_end_transit_button([[self.view.frame.size.height - 140,450], [80, 80]])
      make_end_transit_button([[900,450], [80, 80]])
      # end
            
      # if NSUserDefaults.standardUserDefaults["zero_out"] == true
      # make_zero_out_button([[self.view.frame.size.height - 140,300], [80, 80]])
      make_zero_out_button([[910,300], [80, 80]])
        # make_zero_out_button([[self.view.frame.size.height - 140,300], [160, 32]])
      # end
      
      # make_out_button([[self.view.frame.size.height - 140,380], [80, 80]])
            
      @clock_controller = ClockController.alloc.initWithFrame([[5,520], [285, 340]])
      self.view.addSubview(@clock_controller)
      # **********************
      @calc_controller_view.odo_model = @odo_model
      @clock_controller.calc_controller = @calc_controller_view
      
      # @clock_controller.calc_controller = @calc_model
      # **********************
      @calc_controller_view.time_controller = @clock_controller
      # make_cents_switch
      # make_computer_switch_view
      
      # make_zero_out_button([[self.view.frame.size.height - 140,250], [160, 32]])
      # make_end_transit_button([[self.view.frame.size.height - 140,300], [160, 32]])
      
      manual_switch_actions
      
      init_table
      make_delete_entries_button([[420,320], [160,64]])
      # make_email_button([[420,220], [160,64]])
      # @table = UITableView.alloc.initWithFrame([[420,400], [160,200]])
      #       self.view.addSubview @table
      #       @table.dataSource = self
      #       @table.delegate = self
      
    else
      # make_odometer_label([[15,48],[285,64]])
      # make_plus_one_button([[145,20],[80,32]])
      # make_plus_ten_button
      # make_plus_100_button
      # make_minus_100_button    
      # make_minus_one_button
      # make_minus_ten_button
      # make_speedometer_view
      # make_split_button([[330,118],[120,48]])
      # make_split_label([[360,166],[120,32]])
    end 
    init_location_manager
    @taps_switch.setOn(1, animated: 1)
    @taps_mode=true
    
    # start_gps_actions
    # @gpsfence_label = UILabel.alloc.initWithFrame([[250,620],[340,100]])
    # @gpsfence_label.text = "Gps Fence"
    # self.view.addSubview(@gpsfence_label)
    # make_geofence_stuff
  end
  
  def viewWillAppear(animated)
    NSUserDefaultsDidChangeNotification
     @foreground_observer = App.notification_center.observe NSUserDefaultsDidChangeNotification do |notification|
       # puts "viewWillAppear"
       NSUserDefaults.resetStandardUserDefaults
       # Add code to show KM
       if NSUserDefaults.standardUserDefaults["units"] == false
         @units_label.text = "Miles"
       else
         @units_label.text = "KM"
       end
       # computerEnabled
       if NSUserDefaults.standardUserDefaults["computerEnabled"] == true
         @computer_switch.setOn(true, animated: 1) unless @computer_switch.nil?
       else
         @computer_switch.setOn(false, animated: 1) unless @computer_switch.nil?
         @locationManager.stopUpdatingLocation
       end
     end
   end

   def viewWillDisappear(animated)
     App.notification_center.unobserve @foreground_observer
   end
   
   # ====================== End of Init =========================
   def make_next_minute_button(frame)
     @next_minute_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @next_minute_button.setTitle("Next Minute", forState:UIControlStateNormal)
     @next_minute_button.font = UIFont.fontWithName('Helvetica', size:32)
     @next_minute_button.frame = frame
     self.view.addSubview @next_minute_button
     UIControlEventTouchDragOutside
     @next_minute_button.when(UIControlEventTouchDragExit) do
       @rally_time_picker.next_minute
     end  
   end
   
   def manual_switch_actions
     if @manual_switch.isOn
       @manual_mode = true
       @calc_plus_minus_view.setHidden(false)
       @cm_label.setHidden(false)
     else
       @manual_mode = false
       @calc_plus_minus_view.setHidden(true)
       @cm_label.setHidden(true)
     end
   end

   # ==================
   def make_pause_button(frame)
     @pause_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @pause_button.setTitle("P", forState:UIControlStateNormal)
     @pause_button.font = UIFont.fontWithName('Helvetica', size:32)
     @pause_button.frame = frame
     self.view.addSubview @pause_button
     UIControlEventTouchDragOutside
     @pause_button.when(UIControlEventTouchDragExit) do
     # @out_button.when(UIControlEventTouchUpInside) do
       if NSUserDefaults.standardUserDefaults["cents_timing"] == true
         @calc_controller_view.model.calc((@pause_gain_view.minute * 1.0) + @pause_gain_view.second * 0.01)
       else
         @calc_controller_view.model.calc((@pause_gain_view.minute * 1.0) + @pause_gain_view.second * 0.016667)
       end
       @calc_controller_view.update_view
       beep
     end  
   end
   
   def make_gain_button(frame)
     @gain_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @gain_button.setTitle("G", forState:UIControlStateNormal)
     @gain_button.font = UIFont.fontWithName('Helvetica', size:32)
     @gain_button.frame = frame
     self.view.addSubview @gain_button
     UIControlEventTouchDragOutside
     @gain_button.when(UIControlEventTouchDragExit) do
     # @out_button.when(UIControlEventTouchUpInside) do
       if NSUserDefaults.standardUserDefaults["cents_timing"] == true
         @calc_controller_view.model.calc((@pause_gain_view.minute * -1.0) + @pause_gain_view.second * -0.01)
       else
         @calc_controller_view.model.calc((@pause_gain_view.minute * -1.0) + @pause_gain_view.second * -0.016667)
       end
       @calc_controller_view.update_view
       beep
     end  
   end
   
   # def refresh
   #   puts "refresh"
   #   @table.reloadData
   #   
   #  
   # end
   # ????
   def make_out_button(frame)
     @out_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @out_button.setTitle("Out", forState:UIControlStateNormal)
     @out_button.font = UIFont.fontWithName('Helvetica', size:24)
     @out_button.frame = frame
     self.view.addSubview @out_button
     UIControlEventTouchDragOutside
     @out_button.when(UIControlEventTouchDragExit) do
     # @out_button.when(UIControlEventTouchUpInside) do
       if @zero_out_button.isHidden
         @zero_out_button.setHidden(false) 
         @end_transit_button.setHidden(false) 
       else
         @zero_out_button.setHidden(true)
         @end_transit_button.setHidden(true) 
       end
     end  
   end
   def make_zero_out_button(frame)
     # puts "self.view.frame.size.width #{UIScreen.mainScreen.bounds.size.width}"
     # puts "self.view.frame.size.width #{UIScreen.mainScreen.bounds.size.height}"
     # @end_transit_button = UIButton.buttonWithType(UIButtonTypeSystem) 
     
     @zero_out_button = UIButton.buttonWithType(UIButtonTypeCustom) 
     @zero_out_button.setImage(UIImage.imageNamed('zero@2x.png'),forState: UIControlStateNormal)
     # @zero_out_button.setImage(UIImage.imageNamed('zero_btn@2x.png'),forState: UIControlStateNormal)
     # @zero_out_button.setImage(UIImage.imageNamed('AppIcon76x76@2x.png'),forState: UIControlStateNormal)
     # @end_transit_button.setImage(UIImage.imageNamed('testButton@2x.png'),forState: UIControlStateNormal)
         
     @zero_out_button.setTitle("Zero Out",forState:UIControlStateNormal)
     @zero_out_button.sizeToFit
     @zero_out_button.font = UIFont.fontWithName('Helvetica', size:24)
     # @match_calc_button.frame = [[750,100], [160, 32]]
     @zero_out_button.frame = frame
     self.view.addSubview @zero_out_button
     @zero_out_button.when(UIControlEventTouchDragExit) do
     # @zero_out_button.when(UIControlEventTouchUpInside) do
       @odometer = 0.0
       @mileage_view.set_odometer_text(@odometer)
       @counter = 0
       @aux_odometer = 0.0
       @odo_model.mileage = 0.0
       @calc_model.transit_mileage = 0.0              
       set_calc_tod_actions
       cast
       # AudioServicesPlaySystemSound(1005)
       addLogEntry("Zero Out")        
     end
   end
   def make_end_transit_button(frame)
     # puts "self.view.frame.size.width #{UIScreen.mainScreen.bounds.size.width}"
     # puts "self.view.frame.size.width #{UIScreen.mainScreen.bounds.size.height}"
     # @end_transit_button = UIButton.buttonWithType(UIButtonTypeSystem)
     # @end_transit_button.setTitle("TRM Out",forState:UIControlStateNormal)
     # @end_transit_button.sizeToFit
     # @end_transit_button.font = UIFont.fontWithName('Helvetica', size:24)
     @end_transit_button = UIButton.buttonWithType(UIButtonTypeCustom) 
     # @end_transit_button.setImage(UIImage.imageNamed('trm@2x.png'),forState: UIControlStateNormal)
     @end_transit_button.setImage(UIImage.imageNamed('pylon@2x.png'),forState: UIControlStateNormal)
     # @end_transit_button.setImage(UIImage.imageNamed('testButton@2x.png'),forState: UIControlStateNormal)
     
     # @match_calc_button.frame = [[750,100], [160, 32]]
     @end_transit_button.frame = frame
     self.view.addSubview @end_transit_button
     @end_transit_button.when(UIControlEventTouchDragExit) do
       # @end_transit_button.when(UIControlEventTouchUpInside) do
       # puts "End Transit #{@odo_model.mileage.round(2)}"
       @calc_model.transit_mileage = @odo_model.mileage
       set_calc_tod_actions
       cast
       addLogEntry("TRM Out") 
       # AudioServicesPlaySystemSound(1005)
     end
   end
   # ======================= Log ================================
   def hide_log
     if @table.isHidden
       @table.setHidden(false)  
     else
       # puts "Hide"
       @table.setHidden(true)
     end
   end
   
   def addLogEntry(action)
     LogEntriesStore.shared.add_entry do |log_entry|
       # We set up our new Location object here.
       log_entry.creation_date = NSDate.date
       if @old_location.nil?
         log_entry.coordinate = "none"
       else
         log_entry.coordinate = "#{@old_location.coordinate.latitude.round(5)}, #{@old_location.coordinate.longitude.round(5)}" unless @old_location.nil?
       end
       log_entry.action = action
       split_action
       log_entry.split = @split_label.text + " " + @calc_controller_view.tod_view.text
       # puts "calc time: #{@calc_controller_view.calc_view.text} #{@calc_controller_view.tod_view.text}"
       
     end
     @table.reloadData
   end
   
   def log_to_buffer
     data = LogEntriesStore.shared.log_entries
     s = ""
     # s += "#{car_number}\n"
     data.each do |ea|
       s += "#{ea.creation_date}"
       s += "\t#{ea.action}" 
       s += "\t#{ea.split}"   
       s += "\t#{ea.coordinate}\n"
     end
     # puts "s #{s}"
     return s
   end
   
   def make_delete_entries_button(frame)
     @delete_entries_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @delete_entries_button.setTitle("Log", forState:UIControlStateNormal)
     @delete_entries_button.font = UIFont.fontWithName('Helvetica', size:24)
     @delete_entries_button.frame = frame
     self.view.addSubview @delete_entries_button
     @delete_entries_button.when(UIControlEventTouchUpInside) do
       show_alert
     end  
   end
   
   def email
     BW::Mail.compose ({
             delegate: self,
             to: ["clarence.westberg@gmail.com" ],
             cc: [],
             bcc: [],
             html: false,
             subject: "Log",
             message: "#{log_to_buffer}",
             animated: false
           }) do |result, error|
             result.sent?      # => boolean
             result.canceled?  # => boolean
             result.saved?     # => boolean
             result.failed?    # => boolean
             error             # => NSError
           end

   end
   def make_email_button(frame)
     @email_button = UIButton.buttonWithType(UIButtonTypeSystem)
     @email_button.setTitle("Email", forState:UIControlStateNormal)
     @email_button.font = UIFont.fontWithName('Helvetica', size:24)
     @email_button.frame = frame
     self.view.addSubview @email_button
     @email_button.when(UIControlEventTouchUpInside) do
       email
     end
   end
   # ============= Alert ===================
   def show_alert
       alert = UIAlertView.alloc
       alert.send(:"initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:",
                  "Confirm","Delete",self, "Cancel","All","Selected","Email","Hide/Unhide", nil)
       alert.show
   end

   def alertView(alert_view, clickedButtonAtIndex:button_index)     
     # puts "button_index #{button_index}"
     case button_index
     when 0
       p "Cancel"
     when 1
       p "All"
       LogEntriesStore.shared.delete_all
     when 2
       p 'Selected'
       unless @selected_entry.nil?
         LogEntriesStore.shared.remove_entry(@selected_entry)
         @selected_entry = nil
       end
     when 3
       email
     when 4
       hide_log
     else
     end
     @table.reloadData
   end
   
   # ============ Table Stuff =============
   def init_table
     @table = UITableView.alloc.initWithFrame([[400,400], [180,250]])
     self.view.addSubview @table
     @table.dataSource = self
     @table.delegate = self
   end
   
   def tableView(tableView, numberOfRowsInSection:section)
     LogEntriesStore.shared.log_entries.size
   end
   # CellID = 'CellIdentifier'
   def tableView(tableView, cellForRowAtIndexPath:indexPath)
     @reuseIdentifier ||= "CELL_IDENTIFIER"
     # cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
     cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
     cell.textLabel.font = UIFont.fontWithName('Helvetica', size:10)
     log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
     cell.textLabel.text = "#{log_entry.action}:#{log_entry.split}"
     cell
   end
   def tableView(tableView, didSelectRowAtIndexPath:indexPath) 
     # puts "indexPath #{indexPath.inspect}" 
     log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
     # puts"#{log_entry.inspect}"
     if @selected_entry == log_entry
       tableView.deselectRowAtIndexPath(indexPath, animated:1)
       @selected_entry = nil
     else
       @selected_entry = log_entry
     end

   end
   def tableView(tableView, editingStyleForRowAtIndexPath: indexPath)
     # puts "editingStyleForRowAtIndexPath"
     UITableViewCellEditingStyleDelete
   end

   def tableView(tableView,commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
     # puts "commitEditingStyle"
     if editingStyle == UITableViewCellEditingStyleDelete
       # rows_for_section(indexPath.section).delete_at indexPath.row
       log_entry = LogEntriesStore.shared.log_entries[indexPath.row]
       LogEntriesStore.shared.remove_entry(log_entry)
       tableView.reloadData
     end 
   end
   def tableView(tableView, canMoveRowAtIndexPath:indexPath)
     return 1
   end
   # ======================= Log End ================================

  def touchesEnded(touches, withEvent:event)
    # puts "Event #{event.inspect} #{event.class}"
    touches.each do |aTouch|
      # puts "aTouch #{aTouch.tapCount}"
      if @taps_mode == true
        case aTouch.tapCount
        when 1
          if @manual_mode == true
            update_calcs_by_cent 
          else 
           update_calcs
         end
        when 2
         if @manual_mode == true
           update_calcs_by_cent 
         else 
          # cast
        end
        when 3
         update_calcs_by_cent if @manual_mode == true
        when 4
          update_calcs_by_cent if @manual_mode == true 
        else
        end
      end
      # case aTouch.tapCount
      # when 1
      #   if NSUserDefaults.standardUserDefaults["one_tap"] == true      
      #      update_calcs
      #    else
      #      update_calcs_by_cent if @manual_mode == true
      #    end
      # when 2
      #   if NSUserDefaults.standardUserDefaults["two_taps"] == true      
      #     cast
      #   else
      #     update_calcs_by_cent if @manual_mode == true
      #   end
      # when 3
      #   if NSUserDefaults.standardUserDefaults["two_taps"] == true      
      #     
      #   else
      #     update_calcs_by_cent if @manual_mode == true
      #   end
      # else
      # end
      # if aTouch.tapCount == 1
      #   if NSUserDefaults.standardUserDefaults["one_tap"] == true      
      #     update_calcs
      #   else
      #     update_calcs_by_cent
      #   end
      # elsif aTouch.tapCount >= 2
      #   if NSUserDefaults.standardUserDefaults["two_taps"] == true      
      #     cast
      #   else
      #     update_calcs_by_cent
      #   end
      # end
    end
  end
  
  def make_manual_switch(frame)
    label_frame1 = Array.new(frame[0])
    label_frame1[0] += 55
    label_frame = [label_frame1,frame[1]]
    @manual_label = UILabel.alloc.initWithFrame(label_frame)
    @manual_label.text = "Manual"
    self.view.addSubview(@manual_label)
     
    @manual_switch = UISwitch.alloc.initWithFrame(frame)
    self.view.addSubview(@manual_switch)
    @manual_switch.when(UIControlEventTouchUpInside) do
      # if @manual_switch.isOn
      #   @manual_mode = true
      #   @calc_plus_minus_view.setHidden(false)
      #   @cm_label.setHidden(false)
      # else
      #   @manual_mode = false
      #   @calc_plus_minus_view.setHidden(true)
      #   @cm_label.setHidden(true)
      # end  
      manual_switch_actions
      puts "Manual Mode #{@manual_switch.isOn}"
      addLogEntry("Manual Mode")
    end
  end
  
  def make_taps_switch(frame)
    label_frame1 = Array.new(frame[0])
    label_frame1[0] += 55
    label_frame = [label_frame1,frame[1]]
    @taps_label = UILabel.alloc.initWithFrame(label_frame)
    @taps_label.text = "Taps"
    self.view.addSubview(@taps_label)
     
    @taps_switch = UISwitch.alloc.initWithFrame(frame)
    self.view.addSubview(@taps_switch)
    
    @taps_switch.when(UIControlEventTouchUpInside) do
      if @taps_switch.isOn
        @taps_mode = true
      else
        @taps_mode = false
      end  
      puts "Taps Mode #{@taps_switch.isOn}"
      addLogEntry("Taps Mode")
    end
  end
  
  # Geofences stuff doesn't work
  def make_geofence_stuff
    @geofence_label = UILabel.alloc.initWithFrame([[250,520],[340,100]])
    @geofence_label.text = "Fence"
    self.view.addSubview(@geofence_label)
    geofence_model = GeofenceModel.new
    @locationManager.startMonitoringForRegion(geofence_model.region)
    didStartMonitoringForRegion(@locationManager,geofence_model.region)
    # puts "CLLocationManager.authorizationStatus #{CLLocationManager.authorizationStatus}"
    # puts "CLLocationManager.authorizationStatus regionMonitoringAvailable #{CLLocationManager.regionMonitoringAvailable}"
    # puts "CLLocationManager authorizationStatus enabled  #{CLLocationManager.locationServicesEnabled}"
    # puts "CLLocationManager authorizationStatus  denied #{CLLocationManager.authorizationStatus == KCLAuthorizationStatusDenied}"
    # puts "CLLocationManager authorizationStatus restricted #{CLLocationManager.authorizationStatus == KCLAuthorizationStatusRestricted}"

  end
  def make_delta_view(frame)
    @delta_label = UILabel.alloc.initWithFrame(frame)    
    @delta_label.font = UIFont.fontWithName('Helvetica', size:48)
    @delta_label.text = "0"
    @delta_label.textAlignment = UITextAlignmentRight
    @delta_label.backgroundColor = 0xd1eefc.uicolor
    self.view.addSubview(@delta_label)
  end
  # def make_current_speed_view(frame)
  #   @speed_label = UILabel.alloc.initWithFrame(frame)
  #   @speed_label.font = UIFont.fontWithName('Helvetica', size:64)
  #   puts "#{@calc_controller_view.speed.round(1)}"
  #   @speed_label.text = "#{@calc_controller_view.speed.round(1)}"
  #   @speed_label.backgroundColor = 0xd1eefc.uicolor
  #   self.view.addSubview(@speed_label)
  # end
  
  # def make_current_speed_picker
  #   @current_speed_picker_view = UIPickerView.alloc.initWithFrame([[650,225],[100,60]])
  #   @current_speed_picker_model = SpeedPicker.new
  #   @current_speed_picker_view.delegate = @current_speed_picker_model
  #   @current_speed_picker_view.dataSource = @current_speed_picker_model
  #   @current_speed_picker_view.showsSelectionIndicator = 1
  #   @current_speed_picker_view.selectRow(3, inComponent:0, animated:0)
  #   @current_speed_picker_view.selectRow(6, inComponent:1, animated:0)
  #   @current_speed_picker_view.backgroundColor = UIColor.yellowColor
  #   @current_speed_picker_model.model = @calc_model
  #   self.view.addSubview @current_speed_picker_view
  # end
  def make_next_speed_picker(frame)
    @next_speed_picker_view = UIPickerView.alloc.initWithFrame(frame)
    @next_speed_picker_model = CircularSpeedPicker.new
    # @next_speed_picker_model = SpeedPicker.new
    @next_speed_picker_view.delegate = @next_speed_picker_model
    @next_speed_picker_view.dataSource = @next_speed_picker_model
    @next_speed_picker_view.showsSelectionIndicator = 1
    @next_speed_picker_view.selectRow(3, inComponent:0, animated:0)
    @next_speed_picker_view.selectRow(6, inComponent:1, animated:0)
    # @next_speed_picker_view.backgroundColor = UIColor.whiteColor
    @next_speed_picker_model.model = @calc_model
    self.view.addSubview @next_speed_picker_view
  end
  def make_change_speed_button(frame)
    @change_speed_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @change_speed_button.setTitle("CAST", forState:UIControlStateNormal)
    @change_speed_button.sizeToFit
    @change_speed_button.frame = frame
    @change_speed_button.font = UIFont.fontWithName('Helvetica', size:40)
    # @change_speed_button.backgroundColor = UIColor.redColor
    self.view.addSubview @change_speed_button
    @change_speed_button.when(UIControlEventTouchUpInside) do
      cast
      # match
      #       new_speed = @next_speed_picker_model.selected_speed
      #       tenth = new_speed/10
      #       one = new_speed - tenth
      #       @calc_model.cast = new_speed
      #       @speed_label.text = "#{new_speed}"
      #       @calc_model.cast = new_speed
      #       addLogEntry("CAST #{new_speed}")
    end
  end
  
  def beep
    local_file = NSURL.fileURLWithPath(File.join(NSBundle.mainBundle.resourcePath, 'beep-02.mp3'))
    BW::Media.play(local_file) do |media_player|
      media_player.view.frame = [[1, 1], [10, 20]]
      self.view.addSubview media_player.view
    end
  end
  def cast
    match
    # new_speed = @next_speed_picker_model.selected_speed
    # tenth = new_speed/10
    # one = new_speed - tenth
    new_speed = @speed_view.next_speed
    @speed_view.update_current_speed
    @calc_model.cast = new_speed
    # @speed_label.text = "#{new_speed}"
    @calc_model.cast = new_speed
    addLogEntry("CAST #{new_speed}")
    beep

  end
  
  def make_units_label(frame)
    @units_label = UILabel.alloc.initWithFrame(frame)
    if NSUserDefaults.standardUserDefaults["units"] == false
      @units_label.text = "Miles"
    else
      @units_label.text = "KM"
    end
    self.view.addSubview(@units_label)
  end
  
  def make_start_switch(frame)
    @switch = UISwitch.alloc.initWithFrame(frame)
    # @switch.setOn(0, animated: 1)
    self.view.addSubview(@switch)
    # puts "switch #{@switch.state} #{@switch.state.class}"
    @switch.when(UIControlEventTouchUpInside) do
      # puts "switch touched #{@switch.state}"
      if @switch.isOn
        start_odo_actions
        # puts "on"
      else
        # puts "off"
        stop_odo_actions
        # AudioServicesPlaySystemSound(KSystemSoundID_Vibrate)  
        AudioServicesPlaySystemSound(1005)
      end  
    end
  end
  def start_odo_actions
    @switch.setOn(true, animated: 1) unless @switch.nil?
    @odometer = 0.0
    @counter = 0
    @aux_odometer = 0.0
    @mileage_view.set_odometer_text(@odometer)
    # @locationManager.startUpdatingLocation
    start_location_timer
    @start_button.tintColor = UIColor.greenColor
  end
  def stop_odo_actions
    @locationManager.stopUpdatingLocation
    @locations_timer.invalidate unless @locations_timer.nil?
    @locations_timer = nil
    @start_button.tintColor = UIColor.blueColor
    # AudioServicesPlaySystemSound(KSystemSoundID_Vibrate)  
    AudioServicesPlaySystemSound(1005)
  end
  def park_odo_actions
    # set odo state to park (Model?)
    # stop updating mileage
    # keep updating @old_location
  end
  
  # def make_cents_switch
  #   @switch = UISwitch.alloc.initWithFrame([[650,20], [80, 60]])
  #   @switch.setOn(0, animated: 1)
  #   self.view.addSubview(@switch)
  #   puts "switch #{@switch.state} #{@switch.state.class}"
  #   @switch.when(UIControlEventTouchUpInside) do
  #     puts "switch touched #{@switch.state}"
  #     if @switch.isOn
  #       puts "on = cents"
  #       # change to cents
  #     else
  #       puts "off = seconds"
  #       # change to seconds
  #     end   
  #   end
  # end
  def make_computer_switch_view
    @computer_switch = UISwitch.alloc.initWithFrame([[350,600], [80, 60]])
    self.view.addSubview(@computer_switch)
    # @computer_switch.setOn(0, animated: 1)
    # puts "computer_switch  #{@computer_switch.isOn}"
    @computer_switch.when(UIControlEventTouchUpInside) do
      if @computer_switch.isOn
        # puts "on = computer #{@computer_switch.isOn}"
        NSUserDefaults.standardUserDefaults["computerEnabled"] = true
        @computer_switch.setOn(false, animated: 1)
        # change to cents
      else
        # puts "off = manual #{@computer_switch.isOn}"  
        NSUserDefaults.standardUserDefaults["computerEnabled"] = false              
        # change to seconds
      end   
    end
  end
  def update_calcs
    @calc_controller_view.match(@odo_model.mileage)
    split_action
  end
  def update_calcs_by_cent
    @calc_controller_view.add_one_cent
    split_action
  end
  def make_zero_calc_button(frame)
    @zero_calc_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @zero_calc_button.setTitle("Zero Calc",forState:UIControlStateNormal)
    @zero_calc_button.sizeToFit
    @zero_calc_button.font = UIFont.fontWithName('Helvetica', size:24)
    # @zero_calc_button.frame = [[800,400], [160, 32]]
    @zero_calc_button.frame = frame
    
    self.view.addSubview @zero_calc_button
    @zero_calc_button.when(UIControlEventTouchDragOutside) do
      @calc_controller_view.zero
    end
  end
  def make_match_calc_button(frame)
    # @match_calc_button = UIButton.buttonWithType(UIButtonTypeSystem)
    # @match_calc_button.setTitle("Update",forState:UIControlStateNormal)
    # @match_calc_button.sizeToFit
    # @match_calc_button.font = UIFont.fontWithName('Helvetica', size:24)
    @match_calc_button = UIButton.buttonWithType(UIButtonTypeCustom)
    @match_calc_button.setImage(UIImage.imageNamed('sync@2x.png'),forState: UIControlStateNormal)
    
    @match_calc_button.frame = frame
    self.view.addSubview @match_calc_button
    @match_calc_button.when(UIControlEventTouchUpInside) do
      # @calc_controller_view.match(@odo_model.mileage)
      # update_calcs
      match
    end
  end
  def make_set_calc_tod_button(frame)
    @set_calc_tod_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @set_calc_tod_button.setTitle("Set Tod",forState:UIControlStateNormal)
    @set_calc_tod_button.sizeToFit
    @set_calc_tod_button.font = UIFont.fontWithName('Helvetica', size:24)
    # @set_calc_tod_button.frame = [[550,580], [120, 32]]
    @set_calc_tod_button.frame = frame
    
    # @set_calc_tod_button.frame = [[200,500], [160, 32]]
    self.view.addSubview @set_calc_tod_button
    @set_calc_tod_button.when(UIControlEventTouchDragOutside) do
      # @calc_controller_view.set_calc_tod(@rally_time_picker.selected_time)
      # @rally_time_picker.resignFirstResponder
      addLogEntry("Set TOD")
      set_calc_tod_actions
    end
  end
  
  def set_calc_tod_actions
    @calc_controller_view.set_calc_tod(@rally_time_picker.selected_time)
    @rally_time_picker.resignFirstResponder
    # addLogEntry("Set TOD") 
  end
  
  def make_begin_button
    @begin_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @begin_button.setTitle("Begin", forState:UIControlStateNormal)
    @begin_button.sizeToFit
    @begin_button.frame = [[600,450],[80,32]]
    @begin_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.view.addSubview @begin_button
    @begin_button.when(UIControlEventTouchUpInside) do
      dt = Time.now
      @count_down_view = Time.now
    end
  end
  
  def set_odometer_text
    @odometer_label.text = "#{format("%7.2f",@odometer)}"
  end
  def set_aux_odometer_text
    @aux_odometer_label.text = "#{format("%7.2f",@aux_odometer * @factor)}"
  end
  def make_odometer_label(frame)
    @odometer_label = UILabel.alloc.initWithFrame frame
    set_odometer_text
    @odometer_label.font = UIFont.fontWithName('Helvetica', size:64)
    self.view.addSubview @odometer_label
  end
  def make_aux_odometer_label(frame)
    @aux_odometer_label = UILabel.alloc.initWithFrame frame
    set_aux_odometer_text
    @aux_odometer_label.font = UIFont.fontWithName('Helvetica', size:64)
    @aux_odometer_label.backgroundColor = UIColor.blackColor
    @aux_odometer_label.textColor = UIColor.whiteColor
    @aux_odometer_label.textAlignment = UITextAlignmentRight
    self.view.addSubview @aux_odometer_label
  end
  def make_reset_aux_button(frame)
    @reset_aux_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @reset_aux_button.setTitle("0", forState:UIControlStateNormal)
    @reset_aux_button.sizeToFit
    @reset_aux_button.font = UIFont.fontWithName('Helvetica', size:48)
    # @reset_aux_button.center = CGPointMake(290,166)
    # @reset_aux_button.backgroundColor = UIColor.redColor
    @reset_aux_button.frame = frame
    self.view.addSubview @reset_aux_button
    @reset_aux_button.when(UIControlEventTouchUpInside) do
      @aux_odometer = 0.0
      set_aux_odometer_text
    end
  end
  
  def make_forward_button(frame)
    @forward_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @forward_button.setTitle("Fwd", forState:UIControlStateNormal)
    @forward_button.sizeToFit
    # @forward_button.center = CGPointMake(290,216)
    # @forward_button.backgroundColor = UIColor.greenColor
    @forward_button.frame = frame
    @forward_button.font = UIFont.fontWithName('Helvetica', size:24)
    self.view.addSubview @forward_button
    @forward_button.when(UIControlEventTouchUpInside) do
      # @direction = 'forward'
      @odo_model.set_forward
      @forward_button.tintColor = UIColor.blueColor 
      @reverse_button.tintColor = UIColor.blueColor       
    end
  end
  def make_reverse_button(frame)
    @reverse_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @reverse_button.setTitle("Rev", forState:UIControlStateNormal)
    @reverse_button.sizeToFit
    # @reverse_button.center = CGPointMake(220,216)
    # @reverse_button.backgroundColor = UIColor.redColor
    @reverse_button.frame = frame
    @reverse_button.font = UIFont.fontWithName('Helvetica', size:24)
    self.view.addSubview @reverse_button
    # UIControlEventTouchDragOutside
    # UIControlEventTouchUpInside
    @reverse_button.when(UIControlEventTouchDragOutside) do
      # @direction = 'reverse'
      @odo_model.set_reverse
      @reverse_button.tintColor = UIColor.redColor  
      # AudioServicesPlaySystemSound(KSystemSoundID_Vibrate)  
      AudioServicesPlaySystemSound(1005)  
    end
  end
  
  def make_plus_one_button(frame)
    @plus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_one_button.setTitle(".++", forState:UIControlStateNormal)
    @plus_one_button.sizeToFit
    @plus_one_button.frame = frame
    @plus_one_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.view.addSubview @plus_one_button
    @plus_one_button.when(UIControlEventTouchUpInside) do
      @odometer += 0.01
      set_odometer_text
    end
  end

  def make_plus_100_button
    @plus_100_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_100_button.setTitle("+.", forState:UIControlStateNormal)
    @plus_100_button.frame = [[20,20],[60,32]]
    @plus_100_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.view.addSubview @plus_100_button
    @plus_100_button.when(UIControlEventTouchUpInside) do
      (@odometer += 1.0).round(3)
      set_odometer_text
    end
  end
    
  def make_plus_ten_button
    @plus_ten_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @plus_ten_button.setTitle(".+", forState:UIControlStateNormal)
    @plus_ten_button.frame = [[84,20],[60,32]]
    @plus_ten_button.font = UIFont.fontWithName('Helvetica', size:32)
    self.view.addSubview @plus_ten_button
    @plus_ten_button.when(UIControlEventTouchUpInside) do
      (@odometer += 0.1).round(3)
      set_odometer_text
    end
  end
  
  def make_minus_one_button
    @minus_one_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_one_button.setTitle(".--", forState:UIControlStateNormal)
    @minus_one_button.sizeToFit
    @minus_one_button.frame = [[145,100],[80,32]]
    @minus_one_button.font = UIFont.fontWithName('Helvetica', size:40)
    self.view.addSubview @minus_one_button
    @minus_one_button.when(UIControlEventTouchUpInside) do
      if (@odometer - 0.01) < 0.0
        @odometer = 0.0
      else
        @odometer -= 0.01
      end      
      set_odometer_text
    end
  end
  
  def make_minus_ten_button
    @minus_ten_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_ten_button.setTitle(".-", forState:UIControlStateNormal)
    @minus_ten_button.sizeToFit
    @minus_ten_button.frame = [[84,100],[60,32]]
    @minus_ten_button.font = UIFont.fontWithName('Helvetica', size:40)
    self.view.addSubview @minus_ten_button
    @minus_ten_button.when(UIControlEventTouchUpInside) do
      if (@odometer - 0.1) < 0.0
        @odometer = 0.0
      else
        @odometer -= 0.1
      end
      set_odometer_text
    end
  end
  
  def make_minus_100_button
    @minus_100_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @minus_100_button.setTitle("-.", forState:UIControlStateNormal)
    @minus_100_button.sizeToFit
    @minus_100_button.frame = [[20,100],[60,32]]
    @minus_100_button.font = UIFont.fontWithName('Helvetica', size:40)
    self.view.addSubview @minus_100_button
    @minus_100_button.when(UIControlEventTouchUpInside) do
      if (@odometer - 1.0) < 0.0
        @odometer = 0.0
      else
        @odometer -= 1.0
      end
      set_odometer_text
    end
  end
  
  def make_debug_label(frame)
    @debug_label = UILabel.alloc.initWithFrame frame       
    # @debug_label = UITextView.alloc.initWithFrame [[10,260],[460,64]]        
    @debug_label.text = "GPS Accuracy"
    @debug_label.font = UIFont.fontWithName('Helvetica', size:20)
    self.view.addSubview @debug_label
  end
     
  def make_factor_button(frame)
    @factor_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @factor_button.setTitle("Set Factor", forState:UIControlStateNormal)
    # @factor_button.sizeToFit
    # @factor_button.center = CGPointMake(48,40)
    # 190 + 120
    @factor_button.frame = frame
    @factor_button.font = UIFont.fontWithName('Helvetica', size:24)
    self.view.addSubview @factor_button
    @factor_button.when(UIControlEventTouchUpInside) do
      @factor = @factor_field.text.to_f
      @odo_model.factor = @factor
      @defaults[:factor] = @factor
      @factor_field.text = "#{format("%5.4f",@factor)}"
      @factor_field.resignFirstResponder
    end 
  end

  def make_factor_field(frame)
    # @factor_field = UITextField.alloc.initWithFrame [[25, 100], [165, 32]]
    # x,y,width, height
    @factor_field = UITextField.alloc.initWithFrame frame
    @factor_field.keyboardType = UIKeyboardTypeDecimalPad
    @factor_field.text = "#{format("%5.4f",@factor)}"
    @factor_field.textAlignment = UITextAlignmentLeft
    @factor_field.autocapitalizationType = UITextAutocapitalizationTypeNone
    @factor_field.inputAccessoryView = nil
    @factor_field.backgroundColor = @daylight_background_color
    self.view.addSubview @factor_field
  end
  
  def make_checkpoint_button(frame)
    # @checkpoint_button = UIButton.buttonWithType(UIButtonTypeCustom) 
    # @checkpoint_button.setImage(UIImage.imageNamed('checkpoint@2x.png'),forState: UIControlStateNormal)
    
    @checkpoint_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @checkpoint_button.setTitle("√.", forState:UIControlStateNormal)
    @checkpoint_button.font = UIFont.fontWithName('Helvetica', size:48)
    
    @checkpoint_button.frame = frame
    self.view.addSubview @checkpoint_button
    @checkpoint_button.when(UIControlEventTouchUpInside) do
      update_calcs
      split_action
      addLogEntry("Checkpoint #{@delta_label.text}")
    end
  end

  def make_split_button(frame)
    # @split_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    # @split_button.setTitle("Split", forState:UIControlStateNormal)
    # @split_button.font = UIFont.fontWithName('Helvetica', size:24)
    
    @split_button = UIButton.buttonWithType(UIButtonTypeCustom) 
    # @split_button.setImage(UIImage.imageNamed('splitButton@2x.png'),forState: UIControlStateNormal)
    @split_button.setImage(UIImage.imageNamed('stopwatch@2x.png'),forState: UIControlStateNormal)
    # @split_button.setImage(UIImage.imageNamed('testButton@2x.png'),forState: UIControlStateNormal)

    @split_button.frame = frame
    self.view.addSubview @split_button
    @split_button.when(UIControlEventTouchUpInside) do
      # @clock_controller.current_tod_string_with_offset
      # @split_label.text = "#{@odo_model.mileage.round(2)}/#{@clock_controller.current_tod_string_with_offset}"
      # @calc_controller_view.match(@odo_model.mileage)
      # @aux_odometer = 0.0
      # set_aux_odometer_text
      split_action
      # @calc_controller_view.match(@odo_model.mileage)
      
      addLogEntry("Split")
    end
  end
  
  def match
    # update_calcs alread called two lines below
    puts "match - @odo_model.mileage #{@odo_model.mileage}"
    puts "@calc_model.calc_mileage #{@calc_model.calc_distance} #{@calc_model.inspect}"
    if manual_mode
      calc_mileage = @calc_model.calc_mileage
    else
      calc_mileage = @odo_model.mileage
    end
    @calc_controller_view.match(calc_mileage)
    # @calc_controller_view.match(@odo_model.mileage)
    @split_label.text = "#{@odo_model.mileage.round(2)}/#{@clock_controller.current_tod_string_with_offset}"
  end
  
  def split_action
    @split_label.text = "#{@odo_model.mileage.round(2)}#{"\t"}#{@clock_controller.current_tod_string_with_offset}"
    # @calc_controller_view.match(@odo_model.mileage)
    # @aux_odometer = 0.0
    # set_aux_odometer_text
    # addLogEntry('split')
    # puts "calc time: #{@calc_controller_view.calc_view.text} #{@calc_controller_view.tod_view.text}"
  end
  
  def make_split_label(frame)
    # @split_label = UILabel.alloc.initWithFrame [[360,166],[385,32]]    
    @split_label = UILabel.alloc.initWithFrame(frame)    
    @split_label.text = "#{@odometer}"
    @split_label.font = UIFont.fontWithName('Helvetica', size:36)
    @split_label.textAlignment = UITextAlignmentRight
    @split_label.backgroundColor = @daylight_background_color
    
    self.view.addSubview @split_label
  end

  def make_start_button(frame)
    @start_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    # @start_button.backgroundColor = UIColor.lightGrayColor
    @start_button.setTitle("GPS", forState:UIControlStateNormal)
    @start_button.sizeToFit
    @start_button.font = UIFont.fontWithName('Helvetica', size:24)
    # @start_button.backgroundColor = UIColor.greenColor
    # @start_button.center = CGPointMake(290,40)
    @start_button.frame = frame
    self.view.addSubview @start_button
    @start_button.when(UIControlEventTouchUpInside) do
      # @lm_started = Time.now
      # @switch.setOn(true, animated: 1) unless @switch.nil?
      # @odometer = 0.0
      # @aux_odometer = 0.0
      # @mileage_view.set_odometer_text(@odometer)
      # @locationManager.startUpdatingLocation
      # @start_button.tintColor = UIColor.greenColor
      # start_location_timer
      start_gps_actions
    end
    @start_button.when(UIControlEventTouchDragOutside) do
      stop_odo_actions
    end
  end
  
  def start_gps_actions
    @locationManager.startUpdatingLocation
    @start_button.tintColor = UIColor.greenColor
    start_location_timer
  end
  def make_mph_park_switch(frame)
    label_frame1 = Array.new(frame[0])
    label_frame1[0] += 55
    label_frame = [label_frame1,frame[1]]
    @mph_park_label = UILabel.alloc.initWithFrame(label_frame)
    @mph_park_label.text = "MPH Park"
    self.view.addSubview(@mph_park_label)
    
    @mph_park_switch = UISwitch.alloc.initWithFrame(frame)
    self.view.addSubview(@mph_park_switch)
    # puts "mph_park_switch #{@mph_park_switch.state} #{@mph_park_switch.state.class}"
    @mph_park_switch.when(UIControlEventTouchUpInside) do
      # puts "mph_park_switch touched #{@mph_park_switch.state}"
      if @mph_park_switch.isOn
        @odo_model.parked = true
        @aux_odometer = 0.0
        set_aux_odometer_text
        # puts "mph_park_switch on"
      else
        off_mileage = @aux_odometer
        # puts "============mph_park_switch off #{off_mileage}  #{@odo_model.mileage}"
       
        @odo_model.mileage += off_mileage
        @odo_model.parked = false
        @mileage_view.update_mileage_view
      end 
      addLogEntry("MPH Park")
    end
  end
  
  def make_park_switch(frame)
    label_frame1 = Array.new(frame[0])
    label_frame1[0] += 55
    label_frame = [label_frame1,frame[1]]
    @park_label = UILabel.alloc.initWithFrame(label_frame)
    @park_label.text = "Park"
    self.view.addSubview(@park_label)
     
    @park_switch = UISwitch.alloc.initWithFrame(frame)
    # @switch.setOn(0, animated: 1)
    self.view.addSubview(@park_switch)
    # puts "park_switch #{@park_switch.state} #{@park_switch.state.class}"
    @park_switch.when(UIControlEventTouchUpInside) do
      # puts "park_switch touched #{@park_switch.state}"
      if @park_switch.isOn
        @odo_model.parked = true
        # start_location_timer
        # start_odo_actions
        @aux_odometer = 0.0
        set_aux_odometer_text
        # puts "park_switch on"
      else
        # puts "park_switch off"
        @odo_model.parked = false
      end  
      addLogEntry("Park")
    end
  end
  def make_stop_button(frame)
    @stop_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @stop_button.setTitle("Park", forState:UIControlStateNormal)
    @stop_button.sizeToFit
    @stop_button.font = UIFont.fontWithName('Helvetica', size:24)
    @stop_button.frame = frame

    self.view.addSubview @stop_button
    @stop_button.when(UIControlEventTouchDragOutside) do
      @locationManager.stopUpdatingLocation
      @start_button.tintColor = UIColor.blueColor
      # AudioServicesPlaySystemSound(KSystemSoundID_Vibrate)  
      AudioServicesPlaySystemSound(1005)
    end
  end
  
  def make_zero_button(frame)
    @zero_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @zero_button.setTitle("0",forState:UIControlStateNormal)
    @zero_button.sizeToFit
    @zero_button.font = UIFont.fontWithName('Helvetica', size:48)
    # @zero_button.center = CGPointMake(290,120)
    # @zero_button.backgroundColor = UIColor.blueColor
    @zero_button.frame = frame
    # btn_image = UIImage.imageNamed("zero.png")
    # btn_image = UIImage.imageNamed("AppIcon29x29.png")
    # @zero_button.setBackgroundImage(btn_image, forState:UIControlStateNormal)
    self.view.addSubview @zero_button
    @zero_button.when(UIControlEventTouchUpInside) do
      @odometer = 0.0
      @counter=0
      @mileage_view.set_odometer_text(@odometer)
    end
  end

#  Perhaps these should be part of model
  def update_mileage(distance_moved)
    case @direction
    when 'forward'
      forward_mileage(distance_moved)
    when 'reverse'
      reverse_mileage(distance_moved)
    end
  end
  
  def forward_mileage(distance_moved) 
    if NSUserDefaults.standardUserDefaults["units"] == false
      @odometer += ((distance_moved * MetersToMiles) * @factor)
    else
      @odometer += ((distance_moved * MetersToKM) * @factor)
    end
    # @odometer += ((distance_moved * 0.00062137) * @factor)
    @mileage_view.set_odometer_text(@odometer)
  end
  
  def reverse_mileage(distance_moved)
    if NSUserDefaults.standardUserDefaults["units"] == false
      @odometer -= ((distance_moved * MetersToMiles) * @factor)
    else
      @odometer -= ((distance_moved * MetersToKM) * @factor)
    end
    # @odometer -= ((distance_moved * 0.00062137) * @factor)
    if (@odometer < 0.0)
      @odometer = 0.0
    end
    @mileage_view.set_odometer_text(@odometer)
  end
  
  # def make_speedometer_view_2(frame)
  #    @speed_view = UILabel.alloc.initWithFrame frame        
  #    @speed_view.text = "0"
  #    @speed_view.font = UIFont.fontWithName('Helvetica', size:64)
  #    @speed_view.backgroundColor = @daylight_background_color
  #    self.view.addSubview @speed_view
  #  end
  
  def make_speedometer_view(frame)
    @speedometer_view = UILabel.alloc.initWithFrame frame        
    @speedometer_view.text = "0"
    @speedometer_view.font = UIFont.fontWithName('Helvetica', size:64)
    @speedometer_view.backgroundColor = @daylight_background_color
    self.view.addSubview @speedometer_view
  end
  
  def test_moved_button
    @test_moved_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @test_moved_button.setTitle("Test", forState:UIControlStateNormal)
    @test_moved_button.sizeToFit
    @test_moved_button.font = UIFont.fontWithName('Helvetica', size:24)
    @test_moved_button.frame = [[330,270],[80,48]]
  
    self.view.addSubview @test_moved_button
    @test_moved_button.when(UIControlEventTouchUpInside) do
      test_moved
    end
  end
  def test_moved
    @odo_model.update_mileage(5)
    @mileage_view.update_mileage_view
  end
  # appears to be the callback for location update
  # def locationManager(manager, didUpdateToLocation: newLocation, fromLocation: oldLocation)
  #   return if newLocation.nil?
  #   return if oldLocation.nil?
  #   return if (newLocation.horizontalAccuracy < 0)   # ignore invalid udpates
  #   return if (oldLocation.horizontalAccuracy < 0)   # ignore invalid udpates
  #   return if (newLocation.speed < 0)   # ignore invalid udpates
  #   return if (oldLocation.speed < 0)   # ignore invalid udpates
  #   return if ((newLocation.horizontalAccuracy < (oldLocation.horizontalAccuracy - 10.0)))
  #   location_age = newLocation.timestamp.timeIntervalSinceNow
  #   return if location_age > 5.0
  #   return if (newLocation.horizontalAccuracy > 50)   # ignore weak 
  #   return if (oldLocation.horizontalAccuracy > 50)   # ignore weak
  #   
  #   puts "lat: #{newLocation.coordinate.latitude} long: #{newLocation.coordinate.longitude}"
  #   puts "lat: #{oldLocation.coordinate.latitude} long: #{oldLocation.coordinate.longitude}"
  #   distance_moved = newLocation.distanceFromLocation(oldLocation)
  #   puts distance_moved
  #   # update_mileage(distance_moved)
  #   @odo_model.update_mileage(distance_moved)
  #   @mileage_view.update_mileage_view
  #   if NSUserDefaults.standardUserDefaults["units"] == false
  #     @aux_odometer += ((distance_moved * MetersToMiles) * @factor)
  #   else
  #     @aux_odometer += ((distance_moved * MetersToKM) * @factor)
  #   end
  #   # @aux_odometer += (distance_moved * 0.00062137)
  #   # gps_fence_test(newLocation)
  #   # set_odometer_text
  #   set_aux_odometer_text
  #   @counter +=1
    # unless newLocation.nil? || @oldLocation.nil?
    #   speed = newLocation.speed * 2.23694
    #   @speed_view.text = "#{speed.round}"
    #   # @debug_label.text = "GPS info #{@counter} #{newLocation.horizontalAccuracy} #{oldLocation.horizontalAccuracy}"
    #   # @debug_label.text = "GPS info #{newLocation.description} #{@counter} #{oldLocation.description}"
    # end
  #   
  # end

  def gps_fence_test(new_location)
    latitude = 44.853885
    longitude = -93.375382    
    test_location = CLLocation.alloc.initWithLatitude(latitude, longitude: longitude)
    # 44.829000, -93.383412
    
    bls_lat = 44.829000
    bls_lon = -93.383412
    bls_location = CLLocation.alloc.initWithLatitude(bls_lat, longitude: bls_lon)
    
    # puts "test_location #{test_location.inspect}"
    # @gpsfence_label.text = "test #{test_location.coordinate} #{new_location.coordinate}"
    # new_location.coordinate.latitude
    # new_location.coordinate.longitude
    # puts "new_location  #{new_location.coordinate}"
    if new_location.nil?
      @gpsfence_label.text = "nil#{test_location.coordinate.latitude} #{test_location.coordinate.longitude}"
    else
      distance_away = new_location.distanceFromLocation(test_location) 
      bls_distance_away = new_location.distanceFromLocation(bls_location) 
      @gpsfence_label.text = "Dist is #{distance_away.round} meters #{bls_distance_away.round} meters"
    end 
    # puts "distance_away #{distance_away.inspect}"
    
    
  end
  
  # Location Manager Stuff
  def init_location_manager
    # Create the location manager if this object does not
    # already have one.
    @locationManager = CLLocationManager.alloc.init
    @locationManager.delegate = self
    @locationManager.requestAlwaysAuthorization
    @locationManager.desiredAccuracy = KCLLocationAccuracyBestForNavigation
    # @locationManager.distanceFilter = 5.0
  end
  
  # Delegate methods
  def location_timer_handler
    # puts "location_timer_handler"
    @locationManager.startUpdatingLocation
  end
  # =============== Location Update handler ===============
  def locationManager(manager, didUpdateLocations:locations)
    # puts "didUpdateLocations #{locations.inspect}"
    if @old_location.nil?
      @old_location = locations.first
      # return
    end
    # Should this be iterated?
    locations.each do |newLocation|
      unless newLocation.nil? || @old_location.nil?
        speed = newLocation.speed * 2.23694
        @speedometer_view.text = "#{speed.round}"
        @counter = 0 if @counter.nil?
        @counter +=1
        @debug_label.text = "GPS info #{@counter} #{newLocation.horizontalAccuracy}  #{@old_location.horizontalAccuracy}"
      end
      # newLocation = locations.last
      next if (newLocation.horizontalAccuracy < 0)   # ignore invalid udpates
      # next if (newLocation.speed < 0)   # ignore invalid udpates
      next if (newLocation.horizontalAccuracy > 30)   # ignore weak 
      # next if ((newLocation.horizontalAccuracy < (@old_location.horizontalAccuracy - 10.0)))
    
      distance_moved = newLocation.distanceFromLocation(@old_location)
      @odo_model.update_mileage(distance_moved)
      @mileage_view.update_mileage_view
      
      update_aux_counter(distance_moved)
      # if NSUserDefaults.standardUserDefaults["units"] == false
      #   @conversion_factor = 0.00062137.round(8)
      # else
      #   @conversion_factor = 0.001.round(3)
      # end
      # @aux_odometer += (distance_moved * @conversion_factor)
      # set_aux_odometer_text
      @old_location = newLocation
    end
    
    # @counter +=1 # No longer used  

    
    # @old_location = newLocation
    # manager.stopUpdatingLocation
  end
  
  def update_aux_counter(distance_moved)
    if NSUserDefaults.standardUserDefaults["units"] == false
      @conversion_factor = 0.00062137.round(8)
    else
      @conversion_factor = 0.001.round(3)
    end
    @aux_odometer += (distance_moved * @conversion_factor)
    set_aux_odometer_text
  end
  
  def locationManager(manager, didFailWithError:error)
    puts "didFailWithError #{error}"
  end
  
  def start_location_timer
    @locationManager.startUpdatingLocation
    @locations_timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                               target: self,
                                               selector: "location_timer_handler",
                                               userInfo: nil,
                                               repeats: true) if @locations_timer.nil?
  end
  
  def didEnterRegion(manager,region)
    @geofence_label.text = " enter #{region.identifier} #{Time.now}"
    
  end
  def didExitRegion(manager, region)
    @geofence_label.text = " exit #{region.identifier} #{Time.now}"
    
  end
  def didStartMonitoringForRegion(manager,region)
    # puts "didStartMonitoringForRegion #{manager.inspect} #{region.inspect} #{region.identifier}"
    @geofence_label.text = " dsmfr #{region.identifier} #{Time.now}"
  end

  # Not sure this is used
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Odo",image: nil, tag: 1)
    self 
  end

end