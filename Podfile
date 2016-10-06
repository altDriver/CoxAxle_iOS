source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "9.0"

use_frameworks!

target 'CoxAxle' do
 pod 'Alamofire', '~> 4.0'
 pod 'JSONModel'
 pod 'EAIntroView', '~> 2.9.0'
 pod 'REFrostedViewController', '~> 2.4'
 pod 'SMFloatingLabelTextField'
 pod 'JTMaterialSwitch'
 pod 'IQKeyboardManagerSwift', '4.0.6'
 pod 'YLProgressBar', '~> 3.10.0'
 pod 'UIActivityIndicator-for-SDWebImage'
 pod 'LGSemiModalNavController'
 pod 'Google/Analytics'
 pod 'MSSimpleGauge'
 pod 'DKImagePickerController', :git => 'https://github.com/zhangao0086/DKImagePickerController.git', :branch => 'master'
 pod 'TTRangeSlider'
 pod 'CAIVINScannerLite', :git => 'git@ghe.coxautoinc.com:MPDG/vinscannerlite_pod.git', :branch => 'master'
 pod 'CCBottomRefreshControl'
end

target 'CoxAxleTests' do
  # pod 'Kiwi'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
