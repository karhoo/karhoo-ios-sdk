# Karhoo private pods
# source 'git@github.com:karhoo/KarhooPods.git'

# Standard cocoapods specs source
# source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

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
