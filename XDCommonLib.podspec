
Pod::Spec.new do |s|

s.name         = "XDCommonLib"
s.version      = "0.0.2.4"
s.summary      = "XDCommonLib is a powerful tool set for iOS rapid development."
s.description  = <<-DESC
XDCommonLib is a strong tool set for iOS rapid development.
DESC
s.homepage     = "https://github.com/suxinde2009/XDCommonLib"
s.license      = "MIT"

s.author       = { "suxinde2009" => "suxinde2009@126.com", :tag => '0.0.2.4' }


s.source       = { :git => "https://github.com/suxinde2009/XDCommonLib.git" }
s.source_files  = "XDCommonLib", "XDCommonLib/**/*.{h,m}"
s.public_header_files = "XDCommonLib/**/*.h"

s.resources = ["XDCommonLib/**/*.{storyboard,bundle,xcassets,xcdatamodeld,xib,plist}", "XDCommonLib/Licenses/**"]

s.frameworks = "UIKit", "Foundation", "CoreFoundation"
s.libraries = "z", "xml2"

s.requires_arc = true
s.platform     = :ios, "8.0"

end
