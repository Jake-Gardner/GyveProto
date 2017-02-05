#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserManager : NSObject<FBSDKLoginButtonDelegate>

@property (nonatomic, readonly) UIView* profilePicture;
@property (nonatomic, readonly) NSString* userName;
@property (nonatomic, readonly) NSString* userId;

+(UserManager*)shared;

@end
