# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Arak' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire'
  pod 'NVActivityIndicatorView' , '~> 4.0.0'
  pod 'AwaitToast'
  pod 'Firebase/Messaging'
  pod 'FSPagerView'
  pod "BSImagePicker", "~> 3.1"
  pod 'Firebase/Storage'
  pod 'AppCenter'
  #  pod 'FBSDKCoreKit'
  #  pod 'FBSDKLoginKit'
  #  pod 'FBSDKShareKit'
  pod 'GoogleSignIn'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'DatePickerDialog'
  pod 'JWTDecode', '~> 2.6'
  pod 'Cosmos', '~> 23.0'
  pod 'KDCircularProgress'
  pod 'OTPFieldView'
  pod "ExpandableLabel"
  pod 'Kingfisher', '~> 7.0'
  pod "Player", "~> 0.13.2"
  pod 'WWLayout'
  pod 'KeychainSwift', '~> 20.0'
  pod "DTPhotoViewerController"
  
  pod 'FacebookSDK'
  pod 'FacebookSDK/LoginKit'
  pod 'FacebookSDK/ShareKit'
  pod 'FacebookSDK/PlacesKit'
  pod 'lottie-ios'
  
  #  pod 'FBSDKMessengerShareKit'
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end
