//
//  ViewController.m
//  LineDemoIos
//
//  Created by Avidly on 2017/4/5.
//  Copyright © 2017年 Avidly. All rights reserved.
//

#import "ViewController.h"
#import <LineSDK/LineSDK.h>

@interface ViewController () <LineSDKLoginDelegate>
@property (nonatomic, strong) LineSDKAPI *apiClient;
@end

@implementation ViewController
@synthesize apiClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LineSDKLogin sharedInstance].delegate = self;
    apiClient = [[LineSDKAPI alloc] initWithConfiguration:[LineSDKConfiguration defaultConfig]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lineLoginAppToApp:(id)sender {
    [[LineSDKLogin sharedInstance] startLogin];
}

- (IBAction)lineLoginWeb:(id)sender {
    [[LineSDKLogin sharedInstance] startWebLoginWithSafariViewController:YES];
}
    
- (void)didLogin:(LineSDKLogin *)login
      credential:(LineSDKCredential *)credential
         profile:(LineSDKProfile *)profile
           error:(NSError *)error {
    if (error) {
        NSLog(@"Login error. info: %@", error.description);
    }else {
        NSString *accessToken = credential.accessToken.accessToken;
        NSLog(@"Login success. accessToken: %@", accessToken);
        
        NSString * userID = profile.userID;
        NSString * displayName = profile.displayName;
        NSString * statusMessage = profile.statusMessage;
        NSURL * pictureURL = profile.pictureURL;
        
        NSString * pictureUrlString;
        
        // If the user does not have a profile picture set, pictureURL will be nil
        if (pictureURL) {
            pictureUrlString = profile.pictureURL.absoluteString;
        }
        NSLog(@"Login success. userID: %@; displayName: %@; statusMessage: %@; pictureUrlStringios: %@", userID, displayName, statusMessage, pictureUrlString);
    }
}
    
- (IBAction)logout:(id)sender {
    [apiClient logoutWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Logout success.");
        }else {
            NSLog(@"Logout error. info: %@", error.description);
        }
    }];
    /*
    [apiClient logoutWithCallbackQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"Logout success.");
            }else {
                NSLog(@"Logout error. info: %@", error.description);
            }
        }];
     */
}

//分享文字
- (IBAction)lineShareText:(id)sender {
    NSString *contentType = @"text";
    NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, @"来自IosDemo的文字分享"];
    NSString *urlStringUtf8 = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *appURL = [NSURL URLWithString:urlStringUtf8];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}

//分享图片
- (IBAction)lineShareImage:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //这是图片url http://pics.sc.chinaz.com/files/pic/pic9/201508/apic14052.jpg
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pics.sc.chinaz.com/files/pic/pic9/201508/apic14052.jpg"]];
    UIImage *image = [UIImage imageWithData:data];
    [pasteboard setData:UIImageJPEGRepresentation(image, 0.9) forPasteboardType:@"public.jpeg"];
    NSString *contentType =@"image";
    NSString *contentKey = [pasteboard.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, contentKey];
    NSURL *appURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}

@end
