#
# Be sure to run `pod lib lint Savior.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Savior'
  s.version          = '1.1.0'
  s.summary          = 'Savior is a lightweight Swift ORM that makes persistence delightful.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Savior is a client-side ORM written in Swift for make storing data delightful. Built to be data-agnostic, Savior lets you easily add persistence capabilities to your iOS app. The best part is it doesn\'t require you to change or subclass your existing data models. Just conform your models to the \'Storable\' protocol to get started. Currently Realm is the default provider, but Pull Requests are welcome to add more!'

  s.homepage         = 'https://github.com/erusso1/Savior'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erusso1' => 'ephraim.s.russo@gmail.com' }
  s.source           = { :git => 'https://github.com/erusso1/Savior.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.default_subspec = 'Realm'
  s.source_files = 'Savior/Classes/**/*'
  s.swift_version = '4.2'
  
  s.subspec 'Core' do |core|
      core.ios.deployment_target = '10.0'
      core.source_files = 'Savior/Classes/Core/*.{swift}'
  end
  
  s.subspec 'Realm' do |realm|
      realm.ios.deployment_target = '10.0'
      realm.source_files = 'Savior/Classes/Realm/*.{swift}'
      realm.dependency 'Savior/Core'
      realm.dependency 'RealmSwift'
  end
  
  # s.resource_bundles = {
  #   'Savior' => ['Savior/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
