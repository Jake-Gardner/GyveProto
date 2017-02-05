#import "ProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UserManager.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.readPermissions = @[@"email", @"public_profile", @"user_photos"];
    loginButton.delegate = [UserManager shared];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];

    UIView* profilePic = [UserManager shared].profilePicture;
    profilePic.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:profilePic];
}

@end
