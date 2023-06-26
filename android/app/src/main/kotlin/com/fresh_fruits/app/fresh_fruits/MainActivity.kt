package com.fresh_fruits.app.fresh_fruits

 import androidx.annotation.NonNull
 import io.flutter.embedding.android.FlutterFragmentActivity
 import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        FlavorMethodChannel(binaryMessenger,this).init()
    }
}
