#
# Be sure to run `pod lib lint ShrimpHttp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShrimpHttp'
  s.version          = '0.1.1'
  s.summary          = 'ShrimpHttp is an simplify HTTP networking library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ShrimpHttp is an simplify HTTP networking library written in Swift.
                       DESC

  s.homepage         = 'https://github.com/KevinChouRafael/ShrimpHttp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rafael zhou' => 'wumingapie@gmail.com' }
  s.source           = { :git => 'https://github.com/KevinChouRafael/ShrimpHttp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ShrimpHttp/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ShrimpHttp' => ['ShrimpHttp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'SwiftyJSON', '~> 2.4.0'
end
