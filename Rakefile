# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bubble-wrap'
require "bubble-wrap/mail"
require 'bubble-wrap/media'
require "sugarcube"
require "sugarcube-color"
require "sugarcube-gestures"
require 'motion-settings-bundle'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end
# added to GitHub
Motion::Project::App.setup do |app|

  # Use `rake config' to see complete project settings.
  # app.codesign_certificate = 'iPhone Distribution: Clarence Westberg'
  # app.identifier = 'com.cwrr.reider'
  app.name = 'RallyOdoCalc'
  app.device_family = [:ipad]
  app.info_plist['UIBackgroundModes'] = [ 'location']
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.frameworks += ['CoreData', 'CoreLocation','AudioToolbox']
  app.frameworks += ['MediaPlayer']
  app.frameworks += %w(AVFoundation)
  app.info_plist['NSLocationAlwaysUsageDescription'] = 'Do you want this app to run even when not active?'
  
  app.icons = Dir.glob("resources/AppIcon*.png").map{|icon| icon.split("/").last}
  app.release do
    app.codesign_certificate = 'iPhone Distribution: Clarence Westberg'
    # app.identifier = 'com.cwrr.reider'
    app.identifier = 'com.cwrr.rot'
    app.provisioning_profile ="/Users/clarencewestberg/Library/MobileDevice/Provisioning Profiles/5B04FCAF-5DF0-4A3B-9BAF-C8D9CAADF054.mobileprovision"
  end
  # use 4145F for dev
  app.development do
    app.codesign_certificate = 'iPhone Developer: Clarence Westberg'
    app.provisioning_profile = "/Users/clarencewestberg/Library/MobileDevice/Provisioning Profiles/d7cdbb63-8e05-489c-a951-1a0e18fd88b7.mobileprovision"
    # app.provisioning_profile = "/Users/clarencewestberg/Library/MobileDevice/Provisioning Profiles/c7733cc1-091f-4119-94ab-0df30c2ccc64.mobileprovision"
  end
end

Motion::SettingsBundle.setup do |app|
  # app.toggle "Computer Mode", key: "computerEnabled", default: false
  # app.toggle "Calc Mileage", key: "calcMileageEnabled", default: false
  app.toggle "Cents", key: "cents_timing", default: false
  app.toggle "KM", key: "units", default: false
  # app.toggle "1 Tap = Match", key: "one_tap", default: true
  # app.toggle "2 Taps = CAST", key: "two_taps", default: true
  # app.toggle "Hide C/M", key: "hide_cm", default: true
  # app.toggle "Set TOD", key: "set_tod", default: false
  # app.toggle "Zero Calc", key: "zero_calc", default: false
  # app.toggle "TRM Out", key: "trm_out", default: true
  # app.toggle "Zero Out", key: "zero_out", default: true

  # A slider, configure volume or something linear
  # app.slider "Spice Level", key: "spiceLevel", default: 50, min: 1, max: 100

  # Child pane to display licenses in
  app.child "Acknowledgements" do |ack|
    ack.child "RubyMotion" do |lic|
      lic.group "Copyright 2014 Clarence Westberg"
    end
  end
end
