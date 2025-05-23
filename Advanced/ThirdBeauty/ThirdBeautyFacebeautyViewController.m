//
//  ThirdBeautyFacebeautyViewController.m
//  TRTC-API-Example-OC
//
//  Created by adams on 2021/4/22.
//  Copyright © 2021 Tencent. All rights reserved.
//

/*
 Third-Party Beauty Filters
 The TRTC app supports third-party beauty filters.
 This document shows how to integrate third-party beauty filters.
 1. Enter a room: [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE]
 2. Set the callback of remote video data for custom rendering: [self.trtcCloud setLocalVideoRenderDelegate:self pixelFormat:(TRTCVideoPixelFormat_NV12)
 bufferType:(TRTCVideoBufferType_PixelBuffer)]
 3. Use a third-party filter SDK <FaceBeauty is used in the demo>: [[FUManager shareManager] renderItemsToPixelBuffer:frame.pixelBuffer];
 Documentation: https://cloud.tencent.com/document/product/647/34066
 */

#import "ThirdBeautyFacebeautyViewController.h"
#import "UIViewController+KeyBoard.h"
//todo --- facebeauty start ---
#import "FBUIManager.h"
#import <FaceBeauty/FaceBeautyInterface.h>
bool is_Mirror = true;
//todo --- facebeauty end ---

static const NSInteger RemoteUserMaxNum = 6;

@interface ThirdBeautyFacebeautyViewController () <TRTCCloudDelegate, TRTCVideoFrameDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftRemoteViewA;
@property (weak, nonatomic) IBOutlet UIView *leftRemoteViewB;
@property (weak, nonatomic) IBOutlet UIView *leftRemoteViewC;
@property (weak, nonatomic) IBOutlet UIView *rightRemoteViewA;
@property (weak, nonatomic) IBOutlet UIView *rightRemoteViewB;
@property (weak, nonatomic) IBOutlet UIView *rightRemoteViewC;

@property (weak, nonatomic) IBOutlet UILabel *leftRemoteLabelA;
@property (weak, nonatomic) IBOutlet UILabel *leftRemoteLabelB;
@property (weak, nonatomic) IBOutlet UILabel *leftRemoteLabelC;
@property (weak, nonatomic) IBOutlet UILabel *rightRemoteLabelA;
@property (weak, nonatomic) IBOutlet UILabel *rightRemoteLabelB;
@property (weak, nonatomic) IBOutlet UILabel *rightRemoteLabelC;
@property (weak, nonatomic) IBOutlet UILabel *setBeautyLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *beautyNumLabel;

@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomIdTextField;

@property (weak, nonatomic) IBOutlet UISlider *setBeautySlider;
@property (weak, nonatomic) IBOutlet UIButton *startPushStreamButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (strong, nonatomic) NSMutableOrderedSet *remoteUserIdSet;

@property (nonatomic, assign) BOOL isRenderInit;

@end

@implementation ThirdBeautyFacebeautyViewController

- (NSMutableOrderedSet *)remoteUserIdSet {
    if (!_remoteUserIdSet) {
        _remoteUserIdSet = [[NSMutableOrderedSet alloc] initWithCapacity:RemoteUserMaxNum];
    }
    return _remoteUserIdSet;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _trtcCloud = [TRTCCloud sharedInstance];
    _trtcCloud.delegate = self;
    [self setupDefaultUIConfig];
//    [self setupBeautySDK];
    [self addKeyboardObserver];
    
    //todo --- facebeauty start ---
    [[FBUIManager shareManager] loadToWindowDelegate:nil];
//    [[FBUIManager shareManager] showBeautyView];
    //todo --- facebeauty end ---
    
    //todo --- facebeauty start ---
    [self.trtcCloud setLocalVideoProcessDelegete:self pixelFormat:TRTCVideoPixelFormat_Texture_2D bufferType:TRTCVideoBufferType_Texture];
    [self.view addSubview:[FBUIManager shareManager].enterBeautyBtn];
    
    //todo --- facebeauty end ---
}

- (void)setupDefaultUIConfig {
    
    self.roomIdTextField.text = [NSString generateRandomRoomNumber];
    self.userIdTextField.text = [NSString generateRandomUserId];
    self.title = localizeReplace(localize(@"TRTC-API-Example.ThirdBeauty.Title"), self.roomIdTextField.text);
    
    self.roomIdLabel.text = localize(@"TRTC-API-Example.ThirdBeauty.roomId");
    self.userIdLabel.text = localize(@"TRTC-API-Example.ThirdBeauty.userId");
    self.setBeautyLabel.text = localize(@"TRTC-API-Example.ThirdBeauty.SetBeautyLevel");
    NSInteger value = self.setBeautySlider.value * 6;
    self.beautyNumLabel.text = [NSString stringWithFormat:@"%ld",value];
    
    [self.startPushStreamButton setTitle:localize(@"TRTC-API-Example.ThirdBeauty.startPush") forState:UIControlStateNormal];
    [self.startPushStreamButton setTitle:localize(localize(@"TRTC-API-Example.ThirdBeauty.stopPush")) forState:UIControlStateSelected];
    
    self.startPushStreamButton.titleLabel.adjustsFontSizeToFitWidth = true;
  
    self.leftRemoteLabelA.adjustsFontSizeToFitWidth = true;
    self.leftRemoteLabelA.tag = 300;
    self.leftRemoteLabelB.adjustsFontSizeToFitWidth = true;
    self.leftRemoteLabelB.tag = 301;
    self.leftRemoteLabelC.adjustsFontSizeToFitWidth = true;
    self.leftRemoteLabelC.tag = 302;
    
    self.rightRemoteLabelA.adjustsFontSizeToFitWidth = true;
    self.rightRemoteLabelA.tag = 303;
    self.rightRemoteLabelB.adjustsFontSizeToFitWidth = true;
    self.rightRemoteLabelB.tag = 304;
    self.rightRemoteLabelC.adjustsFontSizeToFitWidth = true;
    self.rightRemoteLabelC.tag = 305;
    
    self.leftRemoteViewA.alpha = 0;
    self.leftRemoteViewA.tag = 200;
    
    self.leftRemoteViewB.alpha = 0;
    self.leftRemoteViewB.tag = 201;
    
    self.leftRemoteViewC.alpha = 0;
    self.leftRemoteViewC.tag = 202;
    
    self.rightRemoteViewA.alpha = 0;
    self.rightRemoteViewA.tag = 203;
    
    self.rightRemoteViewB.alpha = 0;
    self.rightRemoteViewB.tag = 204;
    
    self.rightRemoteViewC.alpha = 0;
    self.rightRemoteViewC.tag = 205;
    
}

- (void)setupBeautySDK {
//    [[FUManager shareManager] loadFilter];
//    [FUManager shareManager].isRender = YES;
//    [FUManager shareManager].flipx = YES;
//    [FUManager shareManager].trackFlipx = YES;
}

- (void)showRemoteUserViewWith:(NSString *)userId {
    if (self.remoteUserIdSet.count < RemoteUserMaxNum) {
        NSInteger count = self.remoteUserIdSet.count;
        [self.remoteUserIdSet addObject:userId];
        UIView *userView = [self.view viewWithTag:count + 200];
        UILabel *userIdLabel = [self.view viewWithTag:count + 300];
        userView.alpha = 1;
        userIdLabel.text = localizeReplace(localize(@"TRTC-API-Example.ThirdBeauty.UserIdxx"), userId);
        [self.trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeSmall view:userView];
    }
}

- (void)hiddenRemoteUserViewWith:(NSString *)userId {
    NSInteger viewTag = [self.remoteUserIdSet indexOfObject:userId];
    UIView *userView = [self.view viewWithTag:viewTag + 200];
    UILabel *userIdLabel = [self.view viewWithTag:viewTag + 300];
    userView.alpha = 0;
    userIdLabel.text = @"";
    [self.trtcCloud stopRemoteView:userId streamType:TRTCVideoStreamTypeSmall];
    [self.remoteUserIdSet removeObject:userId];
}

#pragma mark - IBActions
- (IBAction)onPushStreamClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self startPushStream];
    } else {
        [self stopPushStream];
    }
}

#pragma mark - Slider ValueChange
- (IBAction)setBeautySliderValueChange:(UISlider *)sender {
//    self.beautyParam.mValue = sender.value;
//    [[FUManager shareManager] filterValueChange:self.beautyParam];
    NSInteger value = sender.value * 6;
    self.beautyNumLabel.text = [NSString stringWithFormat:@"%ld",value];
}

#pragma mark - TRTCCloudDelegate
- (void)onRemoteUserEnterRoom:(NSString *)userId {
    NSInteger index = [self.remoteUserIdSet indexOfObject:userId];
    if (index == NSNotFound) {
        [self showRemoteUserViewWith:userId];
    }
}

- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason {
    NSInteger index = [self.remoteUserIdSet indexOfObject:userId];
    if (index) {
        [self hiddenRemoteUserViewWith:userId];
    }
}

#pragma mark - TRTCVideoFrameDelegate
- (uint32_t)onProcessVideoFrame:(TRTCVideoFrame *_Nonnull)srcFrame dstFrame:(TRTCVideoFrame *_Nonnull)dstFrame {

    //todo --- facebeauty start ---
    if (!_isRenderInit) {
        [[FaceBeauty shareInstance] releaseTextureRenderer];
        _isRenderInit = [[FaceBeauty shareInstance] initTextureRenderer:(int)srcFrame.width height:(int)srcFrame.height rotation:FBRotationClockwise0 isMirror:YES maxFaces:5];
    }
    GLuint dstTextureId = [[FaceBeauty shareInstance] processTexture:srcFrame.textureId];
    dstFrame.textureId = dstTextureId;
    //todo --- facebeauty end ---
    
    return 0;
}

#pragma mark - StartPushStream & StopPushStream
- (void)startPushStream {
    self.title = localizeReplace(localize(@"TRTC-API-Example.ThirdBeauty.Title"), self.roomIdTextField.text);
    [self.trtcCloud startLocalPreview:true view:self.view];

    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = SDKAppID;
    params.roomId = [self.roomIdTextField.text intValue];
    params.userId = self.userIdTextField.text;
    params.userSig = [GenerateTestUserSig genTestUserSig:self.userIdTextField.text];
    params.role = TRTCRoleAnchor;
    
//    [self.trtcCloud setLocalVideoProcessDelegete:self pixelFormat:TRTCVideoPixelFormat_Texture_2D bufferType:TRTCVideoBufferType_Texture];
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneLIVE];
    [self.trtcCloud startLocalAudio:TRTCAudioQualityMusic];
    
    TRTCVideoEncParam *videoEncParam = [[TRTCVideoEncParam alloc] init];
    videoEncParam.videoFps = 24;
    videoEncParam.resMode = TRTCVideoResolutionModePortrait;
    videoEncParam.videoResolution = TRTCVideoResolution_960_540;
    [self.trtcCloud setVideoEncoderParam:videoEncParam];
}

- (void)stopPushStream {
    [self.trtcCloud stopLocalPreview];
    [self.trtcCloud stopLocalAudio];
    [self.trtcCloud exitRoom];
    
    for (int i = 0; i < self.remoteUserIdSet.count; i++) {
        UIView *remoteView = [self.view viewWithTag: i + 200];
        UILabel *remoteLabel = [self.view viewWithTag: i + 300];
        remoteView.alpha = 0;
        remoteLabel.text = @"";
        [self.trtcCloud stopRemoteView:self.remoteUserIdSet[i] streamType:TRTCVideoStreamTypeSmall];
    }
    [self.remoteUserIdSet removeAllObjects];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.userIdTextField resignFirstResponder];
    [self.roomIdTextField resignFirstResponder];
}

- (void)dealloc {
    [self removeKeyboardObserver];
    [self.trtcCloud stopLocalPreview];
    [self.trtcCloud stopLocalAudio];
    [self.trtcCloud exitRoom];
//    [[FUManager shareManager] destoryItems];
    [TRTCCloud destroySharedIntance];
    
    //todo --- facebeauty start ---
    [[FaceBeauty shareInstance] releaseTextureRenderer];
    [[FBUIManager shareManager] destroy];
    //todo --- facebeauty end ---
}

@end
