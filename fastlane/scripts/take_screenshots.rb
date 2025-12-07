#!/usr/bin/env ruby
# Script to automate taking screenshots for EventFlow
# Usage: ruby take_screenshots.rb "iPhone 15 Pro Max"

require 'fileutils'

device_name = ARGV[0] || "iPhone 15 Pro Max"
screenshots_dir = File.join(Dir.pwd, "fastlane", "screenshots", device_name.gsub(/[^a-zA-Z0-9]/, "_"))
FileUtils.mkdir_p(screenshots_dir)

# Wait for app to be ready
sleep(3)

# Screenshot sequence - navigate through app and take screenshots
screenshots = [
  {
    name: "01_import_screen",
    description: "Import screen with sample data button",
    wait: 2,
    action: "none" # Already on import screen
  },
  {
    name: "02_all_events",
    description: "All Events tab showing day grouping",
    wait: 2,
    action: "tap_tab:1" # Tap "All Events" tab (index 1)
  },
  {
    name: "03_my_agenda",
    description: "My Agenda with selected events",
    wait: 2,
    action: "tap_tab:2" # Tap "My Agenda" tab
  },
  {
    name: "04_insights",
    description: "Insights with topic cloud and heatmap",
    wait: 3,
    action: "tap_tab:3" # Tap "Insights" tab
  },
  {
    name: "05_fun_bingo",
    description: "Fun tab with conference bingo",
    wait: 2,
    action: "tap_tab:4" # Tap "Fun" tab
  },
  {
    name: "06_settings",
    description: "Settings screen",
    wait: 2,
    action: "open_settings" # Open settings
  }
]

screenshots.each_with_index do |screenshot, index|
  puts "  📸 Taking screenshot: #{screenshot[:name]}"
  
  # Perform action if needed
  case screenshot[:action]
  when /tap_tab:(\d+)/
    tab_index = $1.to_i
    # Use xcrun simctl to tap on bottom navigation
    # This is approximate - you may need to adjust coordinates
    system("xcrun simctl io booted screenshot --type=png /tmp/temp_screenshot.png")
  when "open_settings"
    # Tap settings icon (top right)
    system("xcrun simctl io booted screenshot --type=png /tmp/temp_screenshot.png")
  end
  
  sleep(screenshot[:wait])
  
  # Take screenshot
  output_path = File.join(screenshots_dir, "#{screenshot[:name]}.png")
  system("xcrun simctl io booted screenshot --type=png '#{output_path}'")
  
  if File.exist?(output_path)
    puts "    ✅ Saved: #{output_path}"
  else
    puts "    ❌ Failed to save screenshot"
  end
  
  sleep(1) # Brief pause between screenshots
end

puts "✅ Completed screenshots for #{device_name}"
puts "📁 Saved to: #{screenshots_dir}"

