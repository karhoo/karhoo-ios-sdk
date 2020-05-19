Pod::Spec.new do |s|

  s.name                  = "KarhooSDK"
  s.version               = "1.1.1"
  s.summary               = "Karhoo Network SDK"
  s.homepage              = "https://docs.stg.karhoo.net/v1/mobilesdk/network"
  s.license               = 'MIT'
  s.author                = { "Karhoo" => "ios@karhoo.com" }

  s.source                = { :git => "git@github.com:karhoo/Karhoo-iOS-SDK.git", :tag => s.version }
  s.source_files          = 'KarhooSDK/**/*.swift'
  s.platform              = :ios, '10.0'
  s.requires_arc          = true
  
  s.dependency   'ReachabilitySwift', '5.0.0'
  s.dependency   'KeychainSwift', '12.0.0'

end
