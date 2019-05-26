# Be sure to run `pod lib lint WhiteLabel.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|

  s.name                    = 'WhiteLabel'
  s.version                 = '3.0.0'
  s.summary                 = 'Swift SDK for the White Label API.'

  s.homepage                = 'https://github.com/White-Label/Swift-SDK'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Alex Givens' => 'alex@noonpacific.com' }
  s.source                  = { :git => 'https://github.com/White-Label/Swift-SDK.git', :tag => s.version.to_s }
  s.social_media_url        = 'https://twitter.com/NoonPacific'

  s.swift_version           = '5.0'

  s.ios.deployment_target   = '10.0'
  s.osx.deployment_target   = '10.11'
  s.tvos.deployment_target  = '11.0'

  s.source_files            = 'WhiteLabel/**/*.swift'
  s.resources               = 'WhiteLabel/**/*.xcdatamodeld'
  s.frameworks              = 'CoreData'

  s.dependency 'Alamofire', '~> 4.8'

end
