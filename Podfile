# Karhoo private pods
# source 'git@github.com:karhoo/KarhooPods.git'

# Standard cocoapods specs source
# source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

def sdkPods
    pod 'SwiftLint'
    pod 'KeychainSwift', '12.0.0'
    pod 'ReachabilitySwift', '5.0.0'
end

target 'KarhooSDK' do
    inhibit_all_warnings!
    sdkPods
end

target 'Client' do
  sdkPods
end

target 'KarhooSDKTests' do
end

target 'KarhooSDKIntegrationTests' do
    pod 'OHHTTPStubs/Swift', '8.0.0'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
