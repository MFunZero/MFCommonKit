#
# Be sure to run `pod lib lint MFCommonKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MFCommonKit'
  s.version          = '0.1.3'
  s.summary          = 'common tools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "公共组件"

  s.homepage         = 'https://github.com/MFunzero/MFCommonKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MFunzero' => '2469209357@qq.com' }
  s.source           = { :git => 'https://github.com/MFunzero/MFCommonKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
#  s.dependency 'Alamofire'
#  s.dependency 'HandyJSON'
#  s.source_files = 'MFCommonKit/Classes/**/*'
  
#
#  s.subspec 'Base' do |ss|
#    ss.source_files = 'MFCommonKit/Classes/Base/*'
#  end
#
  s.subspec 'Category' do |ss|
    ss.source_files = 'MFCommonKit/Classes/Category/**/*'
  end
  
  s.subspec 'Tool' do |ss|
    ss.source_files = 'MFCommonKit/Classes/Tool/**/*'
    ss.dependency 'Alamofire'
    ss.dependency 'HandyJSON'
  end
  
  # s.resource_bundles = {
  #   'MFCommonKit' => ['MFCommonKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
