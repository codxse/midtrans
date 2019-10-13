package id.nadiar.midtrans;

import android.content.Context;

import com.midtrans.sdk.corekit.core.MidtransSDK;
import com.midtrans.sdk.corekit.core.UIKitCustomSetting;
import com.midtrans.sdk.corekit.models.snap.TransactionResult;
import com.midtrans.sdk.uikit.SdkUIFlowBuilder;
import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** MidtransPlugin */
public class MidtransPlugin implements MethodCallHandler, TransactionFinishedCallback {
  private final Registrar registrar;
  private final MethodChannel channel;
  private Context context;

  public MidtransPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;
    this.context = registrar.activeContext();
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "id.nadiar.midtrans");
    channel.setMethodCallHandler(new MidtransPlugin(registrar, channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    System.out.println("call method " + call.method);

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("purchase")) {
      UIKitCustomSetting _configuration = MidtransSDK.getInstance().getUIKitCustomSetting();
      _configuration.setSkipCustomerDetailsPages(true);
      _configuration.setShowPaymentStatus(true);

      try {
        SdkUIFlowBuilder.init()
                .setClientKey(call.argument("clientKey").toString())
                .setContext(context)
                .setTransactionFinishedCallback(this)
                .setMerchantBaseUrl(call.argument("merchantBaseUrl").toString())
                .enableLog(true)
                .setUIkitCustomSetting(_configuration)
                .buildSDK();

        MidtransSDK.getInstance().startPaymentUiFlow(context, call.argument("token").toString());
      } catch (Exception e) {
        result.error("Error buld SdkUIFlowBuilder", e.getMessage(), e.getStackTrace());
      }


    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onTransactionFinished(TransactionResult transactionResult) {
    // Log.d("MIDTRANS", transactionResult.getStatus());
    // Log.d("MIDTRANS", transactionResult.getStatusMessage());
    Map<String, Object> _purchased = new HashMap<>();
    _purchased.put("transactionCanceled", transactionResult.isTransactionCanceled());
    _purchased.put("status", transactionResult.getStatus());
    _purchased.put("source", transactionResult.getSource());
    _purchased.put("statusMessage", transactionResult.getStatusMessage());

    if (transactionResult.getResponse() != null) {
      _purchased.put("response", transactionResult.getResponse().toString());
    } else {
      _purchased.put("response", "");
    }

    channel.invokeMethod("onTransactionFinished", _purchased);
  }

}
