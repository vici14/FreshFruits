package com.fresh_fruits.app.fresh_fruits

import android.content.Context
 import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

const val channelId: String = "co.fresh_fruits.flavor"

class FlavorMethodChannel(binaryMessenger: BinaryMessenger,val context: Context): BaseMethodChannel(binaryMessenger) {
    override fun getChannelId(): String {
        return channelId;
    }

    override fun buildMethodCallHandler(): MethodChannel.MethodCallHandler {
        return  MethodChannel.MethodCallHandler{
                call, result ->
            call.let {
                    methodCall ->
                if(methodCall.method == "getFlavor"){
                    println(BuildConfig.FLAVOR)
                    result.success(BuildConfig.FLAVOR)
                }
            }
        }
    }

}