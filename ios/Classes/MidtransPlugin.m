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
  if ([@"init" isEqualToString:call.method ]) {
    NSString *key = call.arguments[@"clientKey"];
    NSString *url = call.arguments[@"merchantBaseUrl"];
    MidtransServerEnvironment serverEnvirontment = MidtransServerEnvironmentProduction;
    [CONFIG setClientKey:key environment:serverEnvirontment merchantServerURL:url];
    return result(0);
  } else if([@"purchase" isEqualToString:call.method]) {
    //NSString *str = call.arguments[@"token"];
    id delegate = [MidtransPayment alloc];
    NSError *error = nil;


    NSString *snapToken = call.arguments[@"token"];

    [[MidtransMerchantClient shared] requestTransacationWithCurrentToken:snapToken completion:^(MidtransTransactionTokenResponse *token, NSError *error)
    {
      MidtransUIPaymentViewController *vc = [[MidtransUIPaymentViewController new] initWithToken:token];
      vc.paymentDelegate = delegate;
      UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
      [viewController presentViewController:vc animated:YES completion:nil];
    }];

    return result(0);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end
