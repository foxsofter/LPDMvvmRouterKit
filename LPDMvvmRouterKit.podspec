Pod::Spec.new do |s|
  s.name             = 'LPDMvvmRouterKit'
  s.version          = '0.2.8'
  s.summary          = 'An elegent router kit for iOS.'

  s.description      = <<-DESC
LPDMvvmRouterKit is written in a Objectivec-C, available under the MVVM framework.
                       DESC

  s.homepage         = 'https://github.com/LPD-iOS/LPDMvvmRouterKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'foxsofter' => 'foxsofter@gmail.com' }
  s.source           = { :git => 'https://github.com/LPD-iOS/LPDMvvmRouterKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LPDMvvmRouterKit/Classes/**/*'

  # s.resource_bundles = {
  #   'LPDMvvmRouterKit' => ['LPDMvvmRouterKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.private_header_files = 'LPDMvvmRouterKit/Classes/NSObject+LPDPerformAction.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'LPDMvvmKit'
end
