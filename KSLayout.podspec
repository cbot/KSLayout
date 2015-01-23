Pod::Spec.new do |s|
  s.name         = "KSLayout"
  s.version      = "1.0.0"
  s.summary      = "A tiny library that helps to automatically layout subviews in a container view by creating the necessary constraints"
  s.homepage     = "https://github.com/cbot/KSLayout"
  s.license      = 'MIT'
  s.author       = { "Kai Straßmann" => "derkai@gmail.com" }
  s.source       = { :git => "https://github.com/cbot/KSLayout.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.public_header_files = 'Classes/ios/*.h'
  s.source_files = 'Classes/ios/*'
  s.frameworks = 'Foundation', 'UIKit'
end
