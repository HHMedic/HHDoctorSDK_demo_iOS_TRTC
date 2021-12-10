## 和缓视频医生 iOS SDK对接文档 3.1.8（快速接入版本）

### 一、引入SDK
* 配置

由于呼叫视频需要相机相册权限，需要在info.plist中添加对应的权限，否则会导致无法调用。

```
<key>NSPhotoLibraryUsageDescription</key>
<string>应用需要使用相册权限，以便您向医生发送健康资料。</string>
<key>NSCameraUsageDescription</key>
<string>应用需使用相机权限，以便您向医生进行视频咨询。</string>
<key>NSMicrophoneUsageDescription</key>
<string>应用需使用麦克风权限，以便您向医生进行视频咨询。</string>
```

*  在 `Podfile` 文件中加入

```shell
use_frameworks!
pod 'HHVDoctorSDK', :git => "http://code.hh-medic.com/hh_public/hhvDoctorSDK.ios.git"
```
* 安装

``` shell
pod install
```


### 二、 初始化SDK

```
swift
let option = HHSDKOptions(isDebug: true, isDevelop: true)
option.cerName = "2cDevTest"
HHMSDK.default.start(option: option)
```

### 三、登录登出

```
swift
// 登录
HHMSDK.default.login(userToken: "token") { [weak self] in
    if let aError = $0 {
        print("登录错误: " + aError.localizedDescription)
    } else {
        print("登录成功")
    }
}
```
error 为登录错误信息，成功则为 nil。
```
swift
// 登出
HHMSDK.default.logout()
```

### 四、跳转首页（必须登录后）

```
HHMSDK.default.skipChatHome()
```

### 五、Demo及详细文档

Demo
https://github.com/HHMedic/HHDoctorSDK_demo_iOS_TRTC

详细接入文档
https://github.com/HHMedic/HHDoctorSDK_demo_iOS_TRTC/blob/main/Document.md
