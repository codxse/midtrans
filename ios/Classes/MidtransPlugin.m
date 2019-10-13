#import "MidtransPlugin.h"
#import <MidtransKit/MidtransKit.h>

FlutterMethodChannel* channel;

@interface MidtransPayment : NSObject<MidtransUIPaymentViewControllerDelegate> {}
@end

@implementation MidtransPayment
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCard:(MidtransMaskedCreditCard *)result {}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController saveCardFailed:(NSError *)error {}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentPending:(MidtransTransactionResult *)result {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:@NO forKey:@"transactionCanceled"];
    [ret setObject:@"pending" forKey:@"status"];
    [channel invokeMethod:@"onTransactionFinished" arguments:ret];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:@NO forKey:@"transactionCanceled"];
    [ret setObject:@"success" forKey:@"status"];
    [channel invokeMethod:@"onTransactionFinished" arguments:ret];
}
- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:@NO forKey:@"transactionCanceled"];
    [channel invokeMethod:@"onTransactionFinished" arguments:ret];
}
- (void)paymentViewController_paymentCanceled:(MidtransUIPaymentViewController *)viewController {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:@YES forKey:@"transactionCanceled"];
    [channel invokeMethod:@"onTransactionFinished" arguments:ret];
}
@end

@implementation MidtransPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
             methodChannelWithName:@"id.nadiar.midtrans"
             binaryMessenger:[registrar messenger]];
  MidtransPlugin* instance = [[MidtransPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

}
@end
