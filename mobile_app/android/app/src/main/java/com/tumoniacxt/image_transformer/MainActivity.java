package com.tumoniacxt.image_transformer;

import androidx.annotation.NonNull;
import java.util.List;
import java.io.InputStream;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "ort";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        BinaryMessenger.TaskQueue taskQueue = flutterEngine.getDartExecutor().getBinaryMessenger().makeBackgroundTaskQueue();
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL, StandardMethodCodec.INSTANCE, taskQueue)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("decode")) {
                        try {
                            List<List<List<List<Double>>>> inputData = call.argument("inputData");
                            String modelPath = call.argument("model");
                            int modelVersion = call.argument("version");
                            
                            InputStream stream;
                            if (modelVersion == 2) {
                                stream = MainActivity.this.getAssets().open("t2i/diffusion/decoder_quant.ort");
                            } else {
                                stream = MainActivity.this.getAssets().open("t2i/diffusion/decoder_quant.ort");
                            }

                            byte[] modelCore = new byte[stream.available()];
                            stream.read(modelCore);
                            stream.close(); 

                            List<List<List<List<Double>>>> output = ONNXProcessor.decodeImg(inputData, modelCore);
                            runOnUiThread(() -> result.success(output));
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }
                        
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }
}
