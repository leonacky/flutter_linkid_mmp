#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_linkid_mmp.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_linkid_mmp'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  
  s.dependency 'SQLite.swift', '~> 0.14.0'
  s.dependency 'KeychainSwift', '~> 20.0'
  s.dependency 'CryptoSwift', '~> 1.5.1'
  
  s.preserve_paths = 'linkid_mmp.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework linkid_mmp' }
  s.vendored_frameworks = 'linkid_mmp.xcframework'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
