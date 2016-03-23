#import "ViewController.h"
#import "UIView+UIViewExtensions.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "ViewItemViewController.h"
#import "ThingService.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import CoreLocation;

@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomOverlay;
@property (weak, nonatomic) IBOutlet UIButton *junkButton;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (weak, nonatomic) IBOutlet UIButton *wantButton;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (weak, nonatomic) IBOutlet UIView *itemWrapper;
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

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    [self startStandardUpdates];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //breaking app
    //[self refreshItemView];
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
    //TODO get item location
    CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:10 longitude:5];
    
    CLLocationDistance meters = [self.locationManager.location distanceFromLocation:itemLocation];
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%4.0f Miles Away", meters/METERS_TO_MILES];
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
    self.itemWrapper.hidden = !currentItem;
    
    if (currentItem) {
        self.itemImage.image = currentItem.image;
        self.itemTitle.text = currentItem.title;
    }
}

#pragma mark - Interface interactions

- (IBAction)onSelectJunk:(id)sender {
    // TODO: post to server, show next item
    // [self refreshItemView];
}

- (IBAction)onSelectPass:(id)sender {
    // TODO: post to server, show next item
    //  [self refreshItemView];
}

- (IBAction)onSelectWant:(id)sender {
    if (self.loggedIn) {
        ViewItemViewController* vc = (ViewItemViewController*)[self navigateToViewController:@"viewItem" fromStoryboard:@"Main"];
        vc.selectedItem = self.currentItem;
    } else {
        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
        loginButton.frame = self.fbButtonWrapper.frame;//CGRectMake(0,0,0,0);//   .size.height = self.fbButtonWrapper.frame.size.height;
        
        loginButton.center = self.fbButtonWrapper.center;
        [self.fbButtonWrapper addSubview:loginButton];
        
        self.fbLoginWrapper.hidden = NO;
        
        self.itemActionWrapper.hidden = YES;
    }
}


@end
