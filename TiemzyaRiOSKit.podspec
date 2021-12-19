#
# Be sure to run `pod lib lint TiemzyaRiOSKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TiemzyaRiOSKit'
  s.version          = '1.3.0'
  s.summary          = 'This framework helps simplyfying some aspects of iOS development ...'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TiemzyaRiOSKit is an iOS utility framework written in Swift. It offers simple-to-use functionality for working with localization, databases and overlays amongst others.
                       DESC

  s.homepage         = 'https://github.com/tiemzyar/trik'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tiemzyar' => 'tiemzyar@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/tiemzyar/trik.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
#  s.platform     = :ios, '9.0'
#  s.requires_arc = true

  s.source_files = 'TiemzyaRiOSKit/Classes/**/*'

  s.resource_bundles = {
    'TiemzyaRiOSKit' => ['TiemzyaRiOSKit/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CFNetwork', 'CoreData', 'CoreGraphics', 'QuartzCore', 'CoreServices', 'SystemConfiguration', 'Security', 'MessageUI', 'ImageIO'
  s.dependency 'Alamofire', '~> 5.2.2'
#  s.dependency 'RNCryptor', '~> 5.0'
#  s.dependency 'Locksmith', '~> 3.0'
#  s.dependency 'Zip', '~> 1.0'
end
