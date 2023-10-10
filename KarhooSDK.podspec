Pod::Spec.new do |s|

  s.name                  = "KarhooSDK"
  s.version               = "1.8.2"
  s.summary               = "Karhoo Network SDK"
  s.homepage              = "https://developer.karhoo.com/docs/build-apps-using-sdks"
  s.license               = 'BSD 2-Clause'
  s.author                = { "Karhoo" => "ios@karhoo.com" }

  s.source                = { :git => "https://github.com/karhoo/karhoo-ios-sdk.git", :tag => s.version }
  s.source_files          = 'KarhooSDK/**/*.swift'
  s.platform              = :ios, '13.0'
  s.requires_arc          = true
  s.swift_version         = '5.0'

end
