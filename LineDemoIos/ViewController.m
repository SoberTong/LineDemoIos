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
    
- (IBAction)lineSend:(id)sender {
    NSURL *appURL = [NSURL URLWithString:@"line://msg/text/IamHappyMan:)"];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}
@end
