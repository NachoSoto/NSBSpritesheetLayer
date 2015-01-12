Pod::Spec.new do |s|
  s.name         = "NSBSpritesheetLayer"
  s.version      = "1.1.0"
  s.summary      = "Spritesheet animations in UIKit."
  s.homepage     = "https://github.com/NachoSoto/NSBSpritesheetLayer"

  s.license      = { :type => 'WTFPL', :file => 'LICENSE' }
  s.author       = { "Nacho Soto" => "hello@nachosoto.com" }
  
  s.source       = { :git => "https://github.com/NachoSoto/NSBSpritesheetLayer.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.source_files = 'NSBSpritesheetLayer/Classes/*.{h,m}'
  s.requires_arc = true
  s.ios.frameworks = 'UIKit', 'CoreGraphics', 'QuartzCore'
end