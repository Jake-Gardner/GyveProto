#import "UserManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKCoreKit/FBSDKProfilePictureView.h>

@interface UserManager ()

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* userId;

@end

@implementation UserManager

+(id)shared {
    static UserManager *sharedManager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}

-(instancetype)init {
    self = [super init];

    if (self) {
        _userId = [FBSDKAccessToken currentAccessToken].userID;
    }

    return self;
}

-(UIView *)profilePicture {
    if (!self.userId) {
        return nil;
    }

    FBSDKProfilePictureView *profilePictureView = [[FBSDKProfilePictureView alloc] init];
    profilePictureView.profileID = self.userId;

    return profilePictureView;
}

//-(NSString *)userName {
//    return _userName;
//}

-(void)logIn:(NSString *)userId {
    if (userId) {
        self.userId = userId;

        [[[FBSDKGraphRequest alloc] initWithGraphPath:userId parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            NSLog(@"%@, %@", result[@"id"], result[@"name"]);
            _userName = result[@"name"];
        }];
    }
}

-(void)logOut {
    self.userId = nil;
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    _userId = result.token.userID;

    [[[FBSDKGraphRequest alloc] initWithGraphPath:_userId parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSLog(@"%@, %@", result[@"id"], result[@"name"]);
        _userName = result[@"name"];
    }];
}

-(void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    _userId = nil;
}

@end
