#import "MidtransPlugin.h"
#import <midtrans/midtrans-Swift.h>

@implementation MidtransPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMidtransPlugin registerWithRegistrar:registrar];
}
@end
