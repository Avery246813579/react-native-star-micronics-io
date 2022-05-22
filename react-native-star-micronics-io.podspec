# react-native-brother-printers.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-star-micronics-io"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  The iOS portion of the wrapper for using star micronics
                   DESC
  s.homepage     = "https://github.com/avery246813579/react-native-star-micronics-io"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Your Name" => "avery@dripos.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/avery246813579/react-native-star-micronics-io.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,cc,cpp,m,mm,swift,plist}"
  s.requires_arc = true
  s.resources = 'ios/**/*.plist'

  s.dependency "React"
  s.dependency "StarMgsIO"
end

