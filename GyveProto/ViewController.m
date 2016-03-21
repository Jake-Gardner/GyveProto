#import "ViewController.h"
#import "UIView+UIViewExtensions.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "ViewItemViewController.h"
#import "ThingService.h"
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

@property (nonatomic) ItemModel* currentItem;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleView];
    [self startStandardUpdates];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshItemView];
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

-(void)styleView {
    //todo is this an expected gradient?  it looks wrong
    //[self.bottomOverlay addLinearGradient:[UIColor darkGrayColor] topColor:[UIColor clearColor]];
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
    
//    self.noItemsLabel.hidden = !!currentItem;
//    self.itemWrapper.hidden = !currentItem;
//    
//    if (currentItem) {
//        self.itemImage.image = currentItem.image;
//        self.itemTitle.text = currentItem.title;
//    }
}

#pragma mark - Interface interactions

-(IBAction)onSelectCamera:(id)sender {
    [self navigateToViewController:@"imageSelector" fromStoryboard:@"Main"];
}

- (IBAction)onSelectJunk:(id)sender {
    // TODO: post to server, show next item
    [self refreshItemView];
}

- (IBAction)onSelectPass:(id)sender {
    // TODO: post to server, show next item
    [self refreshItemView];
}

- (IBAction)onSelectWant:(id)sender {
    ViewItemViewController* vc = (ViewItemViewController*)[self navigateToViewController:@"viewItem" fromStoryboard:@"Main"];
    vc.selectedItem = self.currentItem;
}
- (IBAction)onProfileSelected:(id)sender {
    [self navigateToViewController:@"LoginViewController" fromStoryboard:@"Main"];
}

@end
