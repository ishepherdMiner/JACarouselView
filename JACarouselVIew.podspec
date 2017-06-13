Pod::Spec.new do |s|
  s.name         = "JACarouselView"
  s.version      = "0.0.6"
  s.summary      = "An easy-to-use carousel"
  s.description  = <<-DESC
  An easy-to-use carousel.You can use like UITableView
                   DESC
  s.homepage     = "https://github.com/ishepherdMiner/JACarouselView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  s.author       = { "Jason" => "iJason92@yahoo.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ishepherdMiner/JACarouselView.git", :tag => "#{s.version}" }
  s.source_files = "JACarouselView", "JACarouselView/**/*.{h,m}"  
  s.resource     = "JACarouselView/*.bundle"
  s.public_header_files = "JACarouselView/**/*.h"
  s.frameworks   = "UIKit", "QuartzCore","Foundation"
  s.requires_arc = true
  s.module_name  = "JACarouselView"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
