//
//  AppDelegate.m
//  TRTCSimpleDemo-OC
//
//  Created by dangjiahe on 2021/4/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <FaceBeauty/FaceBeautyInterface.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //todo --- facebeauty start ---
    // 本地资源文件拷贝至沙盒路径
    BOOL isResourceCopied = NO;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FaceBeauty" ofType:@"bundle"];

    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (libraryPaths.count > 0) {
        NSString *libraryDirectory = [libraryPaths lastObject];
        NSString *sandboxPath = [libraryDirectory stringByAppendingPathComponent:@"FaceBeauty"];
        isResourceCopied = [[FaceBeauty shareInstance] copyResourceBundle:bundlePath toSandbox:sandboxPath];
    }

    NSString *version = [[FaceBeauty shareInstance] getVersion];
    NSLog(@"当前FaceBeauty版本 %@", version ?: @"");

    # error 需要FaceBeauty appid，与包名应用名绑定，请联系商务获取
    if (isResourceCopied) {
        [[FaceBeauty shareInstance] initFaceBeauty:@"YOUR_APP_ID" withDelegate:nil];
    }
    //todo --- facebeauty end ---
    return YES;
}



//#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

@end
