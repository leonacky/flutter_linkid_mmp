#import "FlutterLinkidMmpPlugin.h"
#if __has_include(<flutter_linkid_mmp/flutter_linkid_mmp-Swift.h>)
#import <flutter_linkid_mmp/flutter_linkid_mmp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_linkid_mmp-Swift.h"
#endif

@implementation FlutterLinkidMmpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [LinkidMmpPlugin registerWithRegistrar:registrar];
}
@end
