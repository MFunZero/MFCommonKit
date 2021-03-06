#
# Be sure to run `pod lib lint MFCommonKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFCommonKit'
  s.version          = '0.1.5'
  s.summary          = 'common tools, 已适配Alamofir5.0'

  s.description      = "公共组件, 网络请求、扩展类、HUD 等..."

  s.homepage         = 'https://github.com/MFunzero/MFCommonKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MFunzero' => '2469209357@qq.com' }
  s.source           = { :git => 'https://github.com/MFunzero/MFCommonKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.platform     = :ios, "10.0"
  s.swift_version = '5.0'
  s.frameworks    = 'UIKit','AVFoundation'
#  s.dependency 'Alamofire'
#  s.dependency 'HandyJSON'
#  s.source_files = 'MFCommonKit/Classes/**/*'
  
#
#  s.subspec 'Base' do |ss|
#    ss.source_files = 'MFCommonKit/Classes/Base/*'
#  end
#
  s.subspec 'Tool' do |ss|
    ss.source_files = 'MFCommonKit/Classes/Tool/**/*'
    ss.dependency 'Alamofire', '~> 5.0'
    ss.dependency 'HandyJSON', '5.0.2-beta'
    ss.dependency 'MFCommonKit/Extension'
  end

  s.subspec 'Extension' do |ss|
    ss.source_files = 'MFCommonKit/Classes/Extension/*'
    ss.dependency 'SnapKit'
  end
  
  s.subspec 'Base' do |ss|
    ss.source_files = 'MFCommonKit/Classes/Base/*'
  end
  
  s.subspec 'HUDTool' do |ss|
    ss.source_files = 'MFCommonKit/Classes/HUDTool/**/*' 
    ss.dependency 'MBProgressHUD'
    ss.dependency 'MFCommonKit/Extension'
    ss.dependency 'MFCommonKit/Base'
  end

  s.subspec 'SegmentController' do |ss|
    ss.source_files = 'MFCommonKit/Classes/SegmentController/*'
    ss.dependency 'MFCommonKit/Extension'
  end
  
  # s.resource_bundles = {
  #   'MFCommonKit' => ['MFCommonKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
