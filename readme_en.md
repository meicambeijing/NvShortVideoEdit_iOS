# Meishe short video module access guide

## Development environment requirements

* iOS 12.0 and above
* Swift 5 
* CocoaPods

## Support media formats

For details, see: [Meishes sdk product overview](https://www.meishesdk.com/ios/doc_en/html/content/Introduction_8md.html)

## System authorization

App needs to add the following permissions in Info.plist, otherwise it will not be able to use the short video module.


```xml
<key>NSCameraUsageDescription</key>
<string>AppYour consent is required to access the camera</string>
<key>NSMicrophoneUsageDescription</key>
<string>AppYour consent is required to access the microphone</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>AppYour consent is required to access the album</string>
<key>NSAppleMusicUsageDescription</key>
<string>AppYour consent is required to access music</string>
```

## Meishe SDK authorization

Meishe SDK authorization method:

```objective-c
#import <NvStreamingSdkCore/NvsStreamingContext.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *licPath = [[NSBundle mainBundle] pathForResource:@"meicam_licence" ofType:@"lic"];
    BOOL ret = [NvsStreamingContext verifySdkLicenseFile:licPath];
    if (!ret) {
        NSLog(@"verifySdkLicenseFile faild");
    }

    return YES;
}
@end
```

After registering as a user on [Meishe‘s official website](https://en.meishesdk.com/), create an application and configure the App package name. After a Meishe business colleague activates the authorization, you can download the authorization file in the application information.


> The SDK authorization is bound to the Bundle Idenfity of the App. When it is not authorized, all functions of the SDK can be used without checking the authorization, and the drawn picture will have the MEISHE watermark.


## Network interface configuration

The filters, stickers, music and other files used in the short video module are all obtained through the network interface. The server needs to implement the corresponding interface according to the interface document.

Configure the server address and public parameters in the App project.

```objective-c
#import <NvShortVideoCore/NvShortVideoCore.h>

NvHttpRequest *request = [NvHttpRequest sharedInstance];

/// 根据素材类型获取素材分类列表
/// Gets a classified list of materials based on their type
request.assetRequestUrl = NV_ASSET_REQUEST_URL;
/// 根据分类获取素材列表
/// Get a list of materials by category
request.assetCategoryUrl = NV_ASSET_CATEGORY_URL;
/// 获取音乐列表
/// Get music list
request.assetMusiciansUrl = NV_ASSET_MUSICIANS_URL;
/// 获取字体列表
/// Get font list
request.assetFontUrl = NV_ASSET_FONT_URL;
/// 把素材的id作为参数传入，获取到素材下载的链接
/// Pass in the id of the material as a parameter to get the link to the material download
request.assetDownloadUrl = NV_ASSET_DOWNLOAD_URL;
/// 获取预制素材
/// Get the Prefabricated material for the project
request.assetPrefabricatedUrl = NV_ASSET_PREFABRICATED_URL;
/// 一键成片
/// AutoCut
request.assetAutoCutUrl = NV_ASSET_AUTOCUT_URL;
/// 获取模版的标签分类
/// Gets the label classification of the template
request.assetTagUrl = NV_ASSET_TAG_URL;

/// 公共参数
/// Default parameters
request.clientId = NV_ClientId;
request.clientSecret = NV_ClientSecret;
request.assemblyId = NV_AssemblyId;

// MARK: -- 设置模块网络接口 / Set the network interface of the module
NvMaterialCenter* materialCenter = [NvMaterialCenter sharedInstance];
materialCenter.netDelegate = request;
```

## Preset material

The material packages that the short video module relies on can be selected as needed. For details of preset materials, see: [Short video module preset materials](PrefabricatedMaterial_en.html)

## Main methods of short video module

The module main methods are defined in the [NvModuleManager.h](./interface_nv_module_manager.html) file.
Example call:

```objective-c
// 引入头文件
#import <NvShortVideoCore/NvShortVideoCore.h>

- (IBAction)sendertapCapture:(UIButton*)bt {
    bt.enabled = NO;
    NvVideoConfig *config = [[NvVideoConfig alloc] init];
    NvModuleManager* moduleManager = [NvModuleManager sharedInstance];
    [moduleManager startCaptureWithPresentViewController:self.navigationController config:config music:nil with:^{
        bt.enabled = YES;
    }];
}
```

### Video recording

```objective-c
 /*! \if ENGLISH
 *
 *  \brief Shooting entrance
 *  \param viewController Current viewController
 *  \param config Configuration item
 *  \param music The default is nil，If you need to shoot with music, you need to pass an audio object, and the path of the audio must be local and has been downloaded
 *  \param complatetionHandler
 *  \else
 *
 *  \brief 拍摄入口
 *  \param viewController 当前控制器
 *  \param config 配置项
 *  \param music 默认是nil，如果拍摄时需要带音乐拍摄，需要传递一个音频对象，音频的路径必须是本地的，已经下载的路径
 *  \param complatetionHandler
 *  \endif
 */
- (void)startCaptureWithPresentViewController:(UIViewController *)viewController
                                       config:(NvVideoConfig * _Nullable)config
                                        music:(NvCaptionMusicInfo * _Nullable)music
                                         with:(void(^)(void))complatetionHandler;
```

### Picture in Picture

```objective-c
/*! \if ENGLISH
 *
 *  \brief PIP entrance By default, the album is opened, and a material from the album is taken into the beat
 *  \param viewController Current viewController
 *  \param config Configuration item
 *  \param complatetionHandler
 *  \else
 *
 *  \brief 合拍入口，默认打开相册，从相册取一个素材进入合拍
 *  \param viewController 当前控制器
 *  \param config 配置项
 *  \param complatetionHandler
 *  \endif
 */
- (void)startDualCaptureWithPresentViewController:(UIViewController *)viewController
                                           config:(NvVideoConfig * _Nullable)config
                                             with:(void(^)(void))complatetionHandler;

/*! \if ENGLISH
 *
 *  \brief PIP entrance
 *  \param viewController Current viewController
 *  \param config Configuration item
 *  \param videoPath The video path to be filmed must be a local path
 *  \param complatetionHandler
 *  \else
 *
 *  \brief 合拍入口
 *  \param viewController 当前控制器
 *  \param config 配置项
 *  \param videoPath 准备合拍的视频路径，必须是本地路径
 *  \param complatetionHandler
 *  \endif
 */
- (void)startDualCaptureWithPresentViewController:(UIViewController *)viewController
                                           config:(NvVideoConfig * _Nullable)config
                                        videoPath:(NSString *)videoPath
                                             with:(void(^)(void))complatetionHandler;
```

### Video editing

```objective-c
/*! \if ENGLISH
 *
 *  \brief Edit entrance
 *  \param viewController Current viewController
 *  \param config Configuration item
 *  \param complatetionHandler
 *  \else
 *
 *  \brief 编辑入口
 *  \param viewController 当前控制器
 *  \param config 配置项
 *  \param complatetionHandler
 *  \endif
 */
- (void)startEditWithPresentViewController:(UIViewController *)viewController
                                    config:(NvVideoConfig * _Nullable)config
                                      with:(void(^)(void))complatetionHandler;
```

### Video editing complete callback

```objective-c
/*!
 * \if ENGLISH
 *
 *  \brief Edit complete, ready to enter publish callback
 *  \else
 *
 *  \brief 编辑完成，准备进入发布回调
 *  \endif
 */
@protocol NvModuleManagerDelegate <NSObject>

/*!
 * \if ENGLISH
 *
 *  \brief Edit complete, jump release callback
 *  @param taskId  Edit the event id used to exit the module
 *  @param coverImagePath cover
 *  @param hasDraft Whether there is a draft button
 *  @param draftInfo The title displayed on the publish page
 *  @param videoEditNavigationController Current nav controller
 *  \else
 *
 *  \brief 编辑完成，跳转发布回调
 *  @param taskId 编辑事件id，用于退出模块
 *  @param coverImagePath 封面图
 *  @param hasDraft 是否有草稿按钮
 *  @param draftInfo 发布页显示的标题
 *  @param videoEditNavigationController 当前nav控制器
 *  \endif
 *  \sa exitVideoEdit:
 */
- (void)publishWithTaskId:(NSString *)taskId
           coverImagePath:(NSString *)coverImagePath
                 hasDraft:(BOOL)hasDraft
                draftInfo:(NSString *_Nullable)draftInfo
videoEditNavigationController:(UINavigationController *)videoEditNavigationController;

@end
```

### Select cover

```objective-c
/*! \if ENGLISH
 *
 *  \brief Save the cover image to the album
 *  \param coverPath Current cover map path
 *  \param completionHandler
 *  \warning Publish page Save picture button, click after the call
 *  \else
 *
 *  \brief 保存封面图到相册
 *  \param coverPath 当前封面图路径
 *  \param completionHandler
 *  \warning 发布页保存图片按钮，点击之后调用
 *  \endif
 */
- (void)saveCover:(NSString *)coverPath with:(nullable void(^)(BOOL success))completionHandler;
```

### Save draft

```objective-c
/*! \if ENGLISH
 *
 *  \brief Save draft
 *  \param infoString The text of the currently saved publication page
 *  \warning Publish page Save draft button, called after clicking
 *  \else
 *
 *  \brief 保存草稿
 *  \param infoString 当前保存的发布页文本
 *  \warning 发布页保存草稿按钮，点击之后调用
 *  \endif
 */
- (BOOL)saveCurrentDraftWithDraftInfo:(NSString *_Nullable)infoString;
```

### Synthetic video

```objective-c
/*! \if ENGLISH
 *
 *  \brief Start exporting video
 *  \param configure Default is nil, no need to pass
 *  \warning Publish page Save video button, click after the call
 *  \else
 *
 *  \brief 开始导出视频
 *  \param configure 默认是nil，不需要传
 *  \warning 发布页保存视频按钮，点击之后调用
 *  \endif
 */
- (BOOL)compileCurrentTimeline:(NSDictionary *_Nullable)configure;
```

### Video synthesis callback

```objective-c
/*! \if ENGLISH
 *
 *  \brief sdk video export callback
 *  \else
 *
 *  \brief sdk视频导出回调
 *  \endif
 */
@protocol NvModuleManagerCompileStateDelegate <NSObject>

/*! \if ENGLISH
 *
 *  \brief compile video progress callback
 *  \param progress  the current progress
 *  \else
 *
 *  \brief 合成视频进度回调
 *  \param progress 当前的进度
 *  \endif
 */
- (void)didCompileFloatProgress:(float)progress;

/*! \if ENGLISH
 *
 *  \brief The resultant video completes the callback
 *  \param outputPath Video output file path
 *  \param error error
 *  \else
 *
 *  \brief 合成视频完成回调
 *  \param outputPath 视频输出的文件路径
 *  \param error 错误信息
 *  \endif
 */
- (void)didCompileCompleted:(NSString *_Nullable)outputPath error:(NSError *_Nullable)error;

@end
```

### Save video file

```objective-c
/*! \if ENGLISH
 *
 *  \brief Save the video to the album
 *  \param coverPath Current video path
 *  \param completionHandler
 *  \else
 *
 *  \brief 保存视频到相册
 *  \param coverPath 当前视频路径
 *  \param completionHandler
 *  \endif
 */
- (void)saveVideo:(NSString *)videoPath with:(nullable void(^)(BOOL success))completionHandler;
```

### Save cover image

```objective-c
/*! \if ENGLISH
 *
 *  \brief Save the cover image to the album
 *  \param coverPath Current cover map path
 *  \param completionHandler
 *  \warning Publish page Save picture button, click after the call
 *  \else
 *
 *  \brief 保存封面图到相册
 *  \param coverPath 当前封面图路径
 *  \param completionHandler
 *  \warning 发布页保存图片按钮，点击之后调用
 *  \endif
 */
- (void)saveCover:(NSString *)coverPath with:(nullable void(^)(BOOL success))completionHandler;
```

### Exit short video module

Call it when the video publishing page exits

```objective-c
/*! \if ENGLISH
 *
 *  \brief Exit the entire publisher call
 *  \param taskId Returned by the edit completion callback
 *  \warning This method will clean up the current draft and SDK-held resources, please call after completely exiting the editing and publishing process
 *  \else
 *
 *  \brief 退出整个发布器调用
 *  \param taskId 由编辑完成回调中返回
 *  \warning 该方法会清理当前草稿以及sdk持有资源，请在完全退出编辑发布流程之后，调用
 *  \endif
 */
- (BOOL)exitVideoEdit:(NSString *)taskId;
```

### Get draft list

The method is defined in [NvDraftManager.h](./interface_nv_draft_manager.html)

```objective-c
/*! \if ENGLISH
 *
 *  \brief Gets all drafts saved in the sandbox
 *  \return draft list
 *  \else
 *
 *  \brief 获取沙盒中保存的所有草稿
 *  \return 草稿列表
 *  \endif
*/
+ (NSMutableArray<NvDraftModel *> *)getUserDraftFileArray;
```

### Delete draft

The method is defined in [NvDraftManager.h](./interface_nv_draft_manager.html)

```objective-c
/*! \if ENGLISH
 *
 *  \brief Delete a draft file
 *  \param model draft
 *  \else
 *
 *  \brief 删除某个草稿文件
 *  \param model draft
 *  \endif
*/
+ (void)deleteDraftFile:(NvDraftModel *)model;
```

### Open draft

The method is defined in [NvModuleManager.h](./interface_nv_module_manager.html)

```objective-c
/*! \if ENGLISH
 *
 *  \brief Enter the editing portal through draft data recovery
 *  \param draft Current draft object
 *  \param viewController Current viewController
 *  \param config Configuration item
 *  \else
 *
 *  \brief 通过草稿数据恢复，进入编辑入口
 *  \param draft 当前草稿对象
 *  \param viewController 当前控制器
 *  \param config 配置项
 *  \endif
 */
- (void)reeditDraft:(NvDraftModel *)draft presentViewController:(UIViewController *)viewController
             config:(NvVideoConfig * _Nullable)config;
```


## Module settings

The short video module setting class NvVideoConfig includes function module settings and UI customization. For details, see: [Short video function module settings](functionConfiguration_en.html)、[Short video UI module settings](UIConfiguration_en.html)

