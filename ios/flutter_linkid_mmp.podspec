#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_linkid_mmp.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_linkid_mmp'
  s.version          = '1.1.34'
  s.summary          = 'LinkId Mobile Marketing Platform'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/leonacky/flutter_linkid_mmp'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tuan Dinh' => 'leonacky@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '8.0'
  
#  s.dependency 'linkid_mmp', '~> 1.0.3'
#  s.dependency 'CryptoSwift', '1.3.3'
#  s.dependency 'GRDB.swift', '4.14.0'
  
# s.preserve_paths = 'linkid_mmp.xcframework/**/*', 'GRBB.xcframework/**/*'
# s.xcconfig = { 'OTHER_LDFLAGS' => '-framework linkid_mmp -framework GRDB' }
# s.vendored_frameworks = 'linkid_mmp.xcframework', 'GRDB.xcframework'

  s.preserve_paths = 'linkid_mmp.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework linkid_mmp' }
  s.vendored_frameworks = 'linkid_mmp.xcframework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'}
  s.swift_version = '5.0'
end
