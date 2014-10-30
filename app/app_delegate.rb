class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    @defaults = NSUserDefaults.standardUserDefaults

    @distance_controller = DistanceController.alloc.initWithNibName(nil, bundle: nil)
    @distance_controller.title = "Odo"  
    @window.rootViewController = @distance_controller
    true
  end
end
