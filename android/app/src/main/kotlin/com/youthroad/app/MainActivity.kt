package com.youthroad.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.kakao.sdk.common.KakaoSdk

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Kakao SDK 초기화
        KakaoSdk.init(this, "aa0f9f3d74d04efb792ef3af8fb1029a")
    }
}
