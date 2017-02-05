#import "ViewController.h"
#import "UIView+UIViewExtensions.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "ViewItemViewController.h"
#import "ThingService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ItemSelectorViewController.h"
#import "NetworkManager.h"
#import "LocationManager.h"
#import "UserManager.h"

@interface ItemSelectorViewController ()<CLLocationManagerDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIView *itemActionWrapper;
@property (strong, nonatomic) IBOutlet UIView *fbLoginWrapper;
@property (strong, nonatomic) IBOutlet UIView *fbButtonWrapper;

@property (nonatomic) BOOL loggedIn;
@property (nonatomic) ItemModel* currentItem;

@end

@implementation ItemSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupFBLogin];

    [self refreshItemView];

    [[LocationManager shared] registerForUpdates:15.0 predicate:^(CLLocation* location) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayDistance];
        });
    }];
}

- (void) setupFBLogin {
    self.fbLoginWrapper.hidden = YES;

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(0,0, self.fbButtonWrapper.frame.size.width, self.fbButtonWrapper.frame.size.height)];
    
//    loginButton.readPermissions = @[@"email", @"public_profile"];
    [self.fbButtonWrapper addSubview:loginButton];
    loginButton.delegate = [UserManager shared];
//    [NetworkManager sharedManager].userId = [FBSDKAccessToken currentAccessToken].userID;
    self.loggedIn = [FBSDKAccessToken currentAccessToken];
}

#define METERS_TO_MILES 1609.344

- (void ) displayDistance {
    if (self.currentItem) {
        CLLocationDistance meters = [[LocationManager shared] metersFromLocation:self.currentItem.location];

        self.distanceLabel.text = [NSString stringWithFormat:@"%4.1f Miles Away", meters/METERS_TO_MILES];
    }
}

-(void)refreshItemView {
    __weak id me = self;
    [[ThingService sharedService] loadNextThing:^(ItemModel* nextItem) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [me setCurrentItem:nextItem];
        });
    }];
}

-(void)setCurrentItem:(ItemModel *)currentItem {
    _currentItem = currentItem;
    
    self.viewWrapper.hidden = !currentItem;
    
    if (currentItem) {
        self.itemImage.image = currentItem.image;
        self.itemTitle.text = currentItem.title;
    }

    [self displayDistance];
}

#pragma mark - Interface interactions

- (IBAction)onSelectJunk:(id)sender {
    [[ThingService sharedService] junkThing:self.currentItem];
    [self refreshItemView];
}

- (IBAction)onSelectPass:(id)sender {
    [[ThingService sharedService] passThing:self.currentItem];
    [self refreshItemView];
}

- (IBAction)onSelectWant:(id)sender {
    if (self.loggedIn) {
        [[ThingService sharedService] getThing:self.currentItem];
        [self goToViewItemVC];
    } else {
        self.fbLoginWrapper.hidden = NO;
        self.itemActionWrapper.hidden = YES;
    }
}

-(void) goToViewItemVC {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    ViewItemViewController* vc = [sb instantiateViewControllerWithIdentifier:@"viewItem"];
    
    vc.selectedItem = self.currentItem;
    
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - FBSDKLoginButtonDelegate
- (void) loginButton: (FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error: (NSError *)error {
    if ([result.grantedPermissions containsObject:@"email"]) {
//        [NetworkManager sharedManager].userId = result.token.userID;
//        [[UserManager shared] logIn:result.token.userID];
        self.loggedIn = YES;
        self.fbLoginWrapper.hidden = YES;
        
        self.itemActionWrapper.hidden = NO;
        
        [self goToViewItemVC];
    }
    //todo deny permissions
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

//- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
//    return YES;
//}

@end
