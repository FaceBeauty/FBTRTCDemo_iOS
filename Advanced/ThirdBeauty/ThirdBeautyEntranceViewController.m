//
//  ThirdBeautyEntranceViewController.m
//  TRTC-API-Example-OC
//
//  Created by WesleyLei on 2021/8/17.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "ThirdBeautyEntranceViewController.h"
#import "ThirdBeautyFacebeautyViewController.h"
#import "ThirdBeautyTencentEffectViewController.h"

@interface ThirdBeautyEntranceViewController ()
@property(nonatomic, strong) UIButton *beautyButton;
@property(nonatomic, strong) UIButton *xMagicButton;
@end

@implementation ThirdBeautyEntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = localize(@"TRTC-API-Example.Home.ThirdBeauty");
    [self setupUI];
}


- (void)setupUI{
    self.beautyButton.frame = CGRectMake(22,
                                         UIScreen.mainScreen.bounds.size.height * 0.5 - 90, UIScreen.mainScreen.bounds.size.width-44, 50);
    self.xMagicButton.frame = CGRectMake(22,
                                         UIScreen.mainScreen.bounds.size.height * 0.5, UIScreen.mainScreen.bounds.size.width-44, 50);
    [self.view addSubview:self.beautyButton];
    [self.view addSubview:self.xMagicButton];
}

#pragma mark - Touch Even
- (void)clickBeautyButton {
    UIViewController *controller =
    [[ThirdBeautyFacebeautyViewController alloc] initWithNibName:@"ThirdBeautyFacebeautyViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:true];
}


#pragma mark - Touch Even
- (void)clickXmagicButton {
    UIViewController *controller =
    [[ThirdBeautyTencentEffectViewController alloc] initWithNibName:@"ThirdBeautyTencentEffectViewController"
                                                     bundle:nil];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - Gettter
- (UIButton *)beautyButton {
    if (!_beautyButton) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beautyButton.layer.cornerRadius = 5;
        [_beautyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _beautyButton.backgroundColor = [UIColor greenColor];
        [_beautyButton setTitle:localize(@"TRTC-API-Example.ThirdBeauty.faceBeauty") forState:UIControlStateNormal];
        [_beautyButton addTarget:self
                          action:@selector(clickBeautyButton)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;
}

- (UIButton *)xMagicButton {
    if (!_xMagicButton) {
        _xMagicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xMagicButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _xMagicButton.layer.cornerRadius = 5;
        _xMagicButton.backgroundColor = [UIColor greenColor];
        [_xMagicButton setTitle:localize(@"TRTC-API-Example.ThirdBeauty.xmagic") forState:UIControlStateNormal];
        [_xMagicButton addTarget:self
                          action:@selector(clickXmagicButton)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _xMagicButton;
}



@end

