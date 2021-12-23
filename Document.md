
## 和缓视频医生 iOS SDK 3.1.8

<p align="right">
北京和缓医疗科技有限公司<br/>
网址：https://www.hh-medic.com <br/>
地址：北京市东城区东直门来福士7层
</p>
[toc]



##  0. 更新日志

 
> 3.1.8.12222037
  - 功能优化
  - 适配xcode15 iOS13
 
> 3.1.4.10281906

 - 细节优化
 
> 3.1.2

 - 增加视频中开关本地摄像头的配置

   ```
   配置方式：
   HHSDKOptions.default.mVideoOptions.enableCloseCamera // 视频中支持开关摄像头 默认不支持
   HHSDKOptions.default.mVideoOptions.isCloseCameraCall // 支持关闭摄像头呼叫   默认不支持
   ```

> 3.1.0

 - 增加购买会员配置

   ```
   配置方式：
   HHSDKOptions.default.mUserCenterOptions.enableBuyService // 默认不支持
   ```


> 3.0.8

 - 增加多人视频功能
 - 适配模拟器运行


> 3.0.6

 - HHMVideoDelegate增加getChatParentView(_ view : UIView)，以便开发者在呼叫页面添加自定义view
 - 增加跳转信息流的接口
 - 删除项目中UIWebview的引用
 - 适配不同版本的xcode

> 2.0.2

 - 适配 Xcode 10, swift4.2


## 1. 集成方式

说明: 接入 HHDoctorSDK 大概会使 ipa 包增加 15M.
 HHDoctorSDK 提供两种集成方式：您既可以通过 CocoaPods 自动集成我们的 SDK，也可以通过手动下载 SDK, 然后添加到您的项目中。
我们提供的下载地址：

 我们提供了发布仓库: [HHVDoctorSDK](https://code.hh-medic.com/hh_public/hhvDoctorSDK.ios)。
 集成demo地址: [HHDoctorSDK_demo_iOS](https://code.hh-medic.com/hh_public/HHVDoctorSDK-Demo/tree/master)

由于呼叫视频需要相机相册权限，需要在info.plist中添加对应的权限，否则会导致无法调用。

```
<key>NSPhotoLibraryUsageDescription</key>
<string>应用需要使用相册权限，以便您向医生发送健康资料。</string>
<key>NSCameraUsageDescription</key>
<string>应用需使用相机权限，以便您向医生进行视频咨询。</string>
<key>NSMicrophoneUsageDescription</key>
<string>应用需使用麦克风权限，以便您向医生进行视频咨询。</string>
```

### 1.1. 手动集成

1. 根据自己工程需要，下载对应版本的 HHMSDK，得到 NIMSDK.framework ，NIMAVChat.framework，NVS.framework，SecurityKit.framework 和 HHDoctorSDK.framework，以及未链接的全部三方依赖库 ，将他们导入工程。
2. 添加其他 HHDoctorSDK 依赖库。

    - SystemConfiguration.framework
    - MobileCoreServices.framework
    - AVFoundation.framwork
    - CoreTelephony.framework
    - CoreMedia.framework
    - VideoToolbox.framework
    - AudioToolbox.framework
    - libz
    - libsqlite3.0
    - libc++
3. 在 `Build Settings` -> `Other Linker Flags` 里，添加选项 `-ObjC`。
4. 在 `Build Settings` -> `Enable Bitcode` 里，设置为 `No`。
5. 如果需要在后台时保持音频通话状态，在 `Capabilities` -> `Background Modes` 里勾选 `audio, airplay, and Picture in Picture`。

### 1.2. 自动集成（推荐）
* 在 `Podfile` 文件中加入

```shell
use_frameworks!
pod 'HHVDoctorSDK', :git => "http://code.hh-medic.com/hh_public/hhvDoctorSDK.ios.git"
```
* 安装

``` shell
pod install
```

### 1.3. 调用规则
所有 HHDoctorSDK 业务均通过 HHMSDK 单例调用

```swift
public class HHMSDK : NSObject {

    public static let `default`: HHDoctorSDK.HHMSDK
}
```

## 2. 初始化
在使用 HHDoctorSDK 任何方法之前，都应该首先调用初始化方法。正常业务情况下，初始化方法有仅只应调用一次。

HHSDKOptions 选项参数列表

参数|类型|说明
------|---|--------
productId|String|和缓分配的产品ID（必填）
isDevelopment|Bool|服务器模式（测试/正式）
isDebug|Bool|调试模式(是否打印日志)
APNs|String |推送证书名（由和缓生成）
hudManager| HHHUDable|自定义 progressHUD
hudDisTime| Double|hud 自动消失时间

调用示例

```swift
let option = HHSDKOptions(isDebug: true, isDevelop: true)
option.cerName = "2cDevTest"
// let option = HHSDKOptions()
// option.isDevelopment = true
// option.isDebug = true
// option.hudDisTime = 2
HHMSDK.default.start(option: option)
```


## 3. 登录账户
在对医生视频呼叫之前，需要先登录账号信息。账号的 userToken 由和缓提供。
### 3.1. 登录

*注意: 不能多次调用登录 SDK，否则会导致视频故障。*

* 原型

```swift
public class HHMSDK : NSObject {

    /// 登录账户
    ///
    /// - Parameters:
    ///   - userToken: 用户的唯一标志
    ///   - completion: 完成的回调
    @objc  public func login(userToken: String, completion: @escaping HHLoginHandler) {
}
```

* 调用示例

```swift
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

### 3.2. 登出
应用层登出/注销/切换自己的账号时需要调用 HHMSDK 的登出操作，该操作会通知和缓服务器进行 APNs 推送信息的解绑操作，避免用户已登出但推送依然发送到当前设备的情况发生。

* 原型

```swift
public class HHMSDK : NSObject {

    /// 登出
    public func logout()
}
```

* 调用示例

```swift
// 登出
HHMSDK.default.logout()
```

## 4. 视频呼叫
* 原型

```swift
public class HHMSDK : NSObject {

    /// 发起呼叫
    ///
    /// - Parameters:咨询人的userToken
    @objc dynamic public func call(userToken: String)
}
```

* 调用示例

```swift
// 呼叫
HHMSDK.default.call("109CF62C95E7F58E2C0C129CAE48FC953F0D04F68EA2608F6783B874E4F50EEF")
```



## 5. 指定成员呼叫

* 原型

```swift
public class HHMSDK : NSObject {

    /// 指定人发起呼叫(带 UI)
    ///
    /// - Parameters:needSelectMember 是否需要显示选成员弹窗，默认需要
    @objc dynamic public func startMemberCall(needSelectMember: Bool = true)
}
```

* 调用示例

```swift
HHMSDK.default.startMemberCall()
```





## 6. 代理(delegate)(可选)

代理主要用于视频过程中的状态反馈。如果不需要状态反馈，可以不考虑该代理。
所有的代理方法都是可选的，可以根据自己的实际需要实现不同的代理方法。

* 原型

```swift
/// 视频管理器代理
public protocol HHMVideoDelegate : NSObjectProtocol {

    /// 主动视频时的呼叫状态变化
    ///
    /// - Parameter state: 当前呼叫状态
    public func callStateChange(_ state: HHMedicSDK.HHMCallingState)

    /// 通话已接通
    public func callDidEstablish()

    /// 呼叫失败
    public func onFail(error: Error)

    public func onCancel()

    /// 通话已结束 (接通之后才有结束)
    public func callDidFinish()

    /// 转呼医生
    public func onExtensionDoctor()

    /// 接收到呼叫(被呼叫方)
    ///
    /// - Parameters:
    ///   - callID: 呼叫的 id
    ///   - from: 呼叫人 id
    public func onReceive(_ callID: String, from: String)

    /// 收到视频呼入时的操作（被呼叫方）
    ///
    /// - Parameter accept: 接受或者拒接
    public func onResponse(_ accept: Bool)

    /// 缺少必要权限
    ///
    /// - Parameter type: 缺少的权限类型
    public func onLeakPermission(_ type: HHMedicSDK.PermissionType)
}
```

### 6.1. 加入
代理支持同时设置多个。

```swift
HHMSDK.default.add(delegate: self)
```

### 6.2. 移除

```swift
HHMSDK.default.remove(delegate: self)
```

## 7. 信息流



### 7.1.  跳转信息流

```
HHMSDK.default.skipChatHome(skipType: .present, vc: self)
```



### 7.2.  饿了么购药

正常情况下呼叫完成后，如有必要，医生会发送药卡，如需医生发送饿了么药卡，需在呼叫之前调用发送本地定位的接口。

如需关掉该功能只需发送(0,0)的坐标。具体可参照demo里SettingVC里关于定位的设置。

```
HHLocation.default.startLocation(lng: "116.431941", lat: "39.940199") /// 此为测试坐标，需替换为用户本地的坐标
```

在饿了么购药过程中，会涉及到微信支付和支付宝支付。开发者需在自己的项目主Target中配置对应的回调scheme。

分别为，具体可参照demo里的配置

```
1. identifier : eleme  URL Schemes : cash.tb.ele.me
2. identifier : none   URL Schemes : HHPay
3. identifier : none   URL Schemes : alipays
```



## 8. 其他配置

### 8.1. APNs

在 appDelegate 中向 SDK 传入 deviceToken 即可。

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    HHMSDK.default.updateAPNS(token: deviceToken)
}
```

*注意：需要上传 APNs 的 p12 文件，请联系我们上传。*

### 8.2. Background Modes

为了支持用户压后台后音视频的正常使用，需要设置 Background Modes。具体设置如下：

```
xxx target -> Capabilities -> Background Modes -> 勾选 Audio，Airplay and Picture in Picture
```

### 8.3. 扩展参数

为了支持收集渠道日志，SDK支持在初始化时传递自定义参数(长度限制小于64位，不支持JSON)。

```
HHSDKOptions.default.setCallExtension(callExtension: "xxx")
```



### 8.4. 支付跳转配置

在使用SDK叮当购药或会员购买服务时，需要为项目配置支付跳转的scheme.

配置步骤如下：

Step1: 在 Targets - Info - URL Types下增加：

```
URL1: 
identifier: ''
URL Schemes: hh-medic.com

URL2:
identifier: ''
URL Schemes: alipays

URL3:
identifier: 'eleme'
URL Schemes: cash.tb.ele.me
```



Step2: 在AppDelegate下配置如下代码：

```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "hh-medic.com" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WX_H5_PAY"), object: nil)
            return true
        }
   
        return true
    }
```



### 8.5. 上架 App Store 时，出现 x86_64, i386 架构错误该如何解决？

该问题是由于 App Store 不支持 x86_64, i386 架构引起的，具体解决方法如下：

1. 清空项目编译缓存：
   选择【Product】>【clean】，按住Alt变成 clean build Folder...，等待操作完成。
2. 剔除 App Store 不支持的 x86_64 和 i386 架构：
   a. 选择【TARGETS】>【Build Phases】。
   b. 单击加号，选择【New Run Script Phase】。
   c. 添加如下代码：

```
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"  

# This script loops through the frameworks embedded in the application and  

# removes unused architectures.  

 find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK  
 do  
 FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)  
 FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"  
 echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"  

 EXTRACTED_ARCHS=()  

 for ARCH in $ARCHS  
 do  
 echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"  
 lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"  
 EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")  
 done  

 echo "Merging extracted architectures: ${ARCHS}"  
 lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"  
 rm "${EXTRACTED_ARCHS[@]}"  

 echo "Replacing original executable with thinned version"  
 rm "$FRAMEWORK_EXECUTABLE_PATH"  
 mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"  

 done
```

### 8.6. 宿主app是基于Object-C时需要注意的问题

1. 需勾选 Always embed swift standard libraries 为 YES 否则在低版本系统会闪退。
