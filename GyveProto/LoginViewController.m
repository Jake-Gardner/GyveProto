//
//  LoginViewController.m
//  GyveProto
//
//  Created by Nick Zankich on 3/18/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController()
@property (strong, nonatomic) IBOutlet UIView *wrapperView;

@end

@implementation LoginViewController

-(void) viewDidLoad {
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.wrapperView.center;
    [self.wrapperView addSubview:loginButton];
}

@end
