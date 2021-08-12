package com.lowkeyreactnativelinkpreview

import android.util.Log
import com.facebook.react.bridge.*
import io.github.ponnamkarthik.richlinkpreview.MetaData
import io.github.ponnamkarthik.richlinkpreview.ResponseListener
import io.github.ponnamkarthik.richlinkpreview.RichPreview

class ReactNativeLinkPreviewModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "ReactNativeLinkPreview"
    }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    fun generate(inputUrl: String, promise: Promise) {
      val richPreview = RichPreview(object : ResponseListener {
        override fun onData(metaData: MetaData) {
          val responseMap = Arguments.createMap();

          responseMap.putString("title", metaData.title)
          responseMap.putString("type", metaData.mediatype)
          responseMap.putString("url", metaData.url)
          responseMap.putString("imageURL", metaData.imageurl)
          responseMap.putString("description", metaData.description)

          promise.resolve(responseMap)
        }

        override fun onError(e: Exception) {
          //handle error
        }
      })
      richPreview.getPreview(inputUrl)
    }


}
