package com.fresh_fruits.app.fresh_fruits


import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

abstract class BaseMethodChannel(private val binaryMessenger: BinaryMessenger) {
    abstract  fun getChannelId():String
    abstract fun buildMethodCallHandler(): MethodChannel.MethodCallHandler

    fun init():MethodChannel{
        val methodChannel = MethodChannel(binaryMessenger,getChannelId())
        methodChannel.setMethodCallHandler(buildMethodCallHandler())
        return methodChannel
    }
}