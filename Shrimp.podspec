#
# Be sure to run `pod lib lint ShrimpHttp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Shrimp'
  s.version          = '0.5.1'
  s.summary          = 'Shrimp is an simplify HTTP networking library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Shrimp is an simplify HTTP networking library written in Swift.
                       DESC

  s.homepage         = 'https://github.com/KevinZhouRafael/Shrimp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rafael zhou' => 'wumingapie@gmail.com' }
  s.source           = { :git => 'https://github.com/KevinZhouRafael/Shrimp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#  s.swift_versions = ['5.0','5.1','5.2','5.3']
  s.ios.deployment_target = '8.0'

  s.source_files = 'Shrimp/Classes/**/*'

  # s.resource_bundles = {
  #   'ShrimpHttp' => ['ShrimpHttp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  #s.dependency 'CryptoSwift', '~> 0.7.0'
  s.dependency 'ReachabilitySwift'
end
