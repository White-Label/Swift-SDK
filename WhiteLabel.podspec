# Be sure to run `pod lib lint WhiteLabel.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'WhiteLabel'
  s.version          = '0.1.8'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'Swift SDK for the White Label API.'
  s.homepage         = 'https://github.com/NoonPacific/White-Label-Swift-SDK'
  s.social_media_url = 'https://twitter.com/NoonPacific'
  s.author           = { 'Alex Givens' => 'alex@noonpacific.com' }
  s.source           = { :git => 'https://github.com/NoonPacific/White-Label-Swift-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
#  s.osx.deployment_target = '10.9'
#  s.tvos.deployment_target = '9.0'

  s.source_files = 'WhiteLabel/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'RestKit', '~> 0.27.0'
end
