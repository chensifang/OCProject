# Uncomment the next line to define a global platform for your project
# platform :ios, ‘8.0’
source 'https://git.coding.net/fourye/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
flutter_application_path = 'my_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
target 'TestProject' do
  install_all_flutter_pods(flutter_application_path)
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  pod 'ReactiveObjC'
  pod 'YYKit'
  pod 'Aspects'
  pod 'SFLog'
  pod 'SDWebImage'
  pod 'AFNetworking'
  pod 'fishhook'
  pod 'RSSwizzle'
end
