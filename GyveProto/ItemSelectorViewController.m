#import "ViewController.h"
#import "UIView+UIViewExtensions.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "ViewItemViewController.h"
#import "ThingService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ItemSelectorViewController.h"

@import CoreLocation;

@interface ItemSelectorViewController ()<CLLocationManagerDelegate, FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,retain) CLLocationManager *locationManager;
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
    //todo login button for intial give

    [self refreshItemView];
}

- (void) setupFBLogin {
    self.fbLoginWrapper.hidden = YES;
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(0,0, self.fbButtonWrapper.frame.size.width, self.fbButtonWrapper.frame.size.height)];
    
    loginButton.readPermissions = @[@"email"];
    [self.fbButtonWrapper addSubview:loginButton];
    loginButton.delegate = self;
    [self startStandardUpdates];
    self.loggedIn = [FBSDKAccessToken currentAccessToken];
}

- (void)startStandardUpdates {
    // Create the location manager if this object does not
    // already have one.
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    [self displayDistance];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        [self displayDistance];
    }
}

#define METERS_TO_MILES 1609.344

- (void ) displayDistance {
    if (self.currentItem) {
        CLLocationDistance meters = [self.locationManager.location distanceFromLocation:self.currentItem.location];

        self.distanceLabel.text = [NSString stringWithFormat:@"%4.1f Miles Away", meters/METERS_TO_MILES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //todo log error
    if ([error code] != kCLErrorLocationUnknown) {
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
    
    self.noItemsLabel.hidden = !!currentItem;
    
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
        self.loggedIn = YES;
        self.fbLoginWrapper.hidden = YES;
        
        self.itemActionWrapper.hidden = NO;
        
        [self goToViewItemVC];
    }
    //todo deny permissions
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    return YES;
}

@end
