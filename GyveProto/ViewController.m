//
//  ViewController.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/13/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "ViewController.h"
#import "UIView+UIViewExtensions.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "FakeDB.h"
#import "ViewItemViewController.h"
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

@property (nonatomic) ItemModel* currentItem;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleView];
    [self startStandardUpdates];
}

- (void)startStandardUpdates {
    // Create the location manager if this object does not
    // already have one.
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshItemView];
}

-(void)styleView {
    [self.junkButton setBorder:[UIColor whiteColor] width:1.0];
    [self.passButton setBorder:[UIColor whiteColor] width:1.0];
    [self.wantButton setBorder:[UIColor whiteColor] width:1.0];
    
    [self.bottomOverlay addLinearGradient:[UIColor darkGrayColor] topColor:[UIColor clearColor]];
}

-(void)refreshItemView {
    __weak id me = self;
    [[FakeDB sharedDB] getNextItem:^(ItemModel* nextItem) {
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

-(IBAction)onSelectCamera:(id)sender {
    [self navigateToViewController:@"imageSelector" fromStoryboard:@"Main"];
}

- (IBAction)onSelectJunk:(id)sender {
    [[FakeDB sharedDB] removeItem:self.currentItem];
    [self refreshItemView];
}

- (IBAction)onSelectPass:(id)sender {
    [[FakeDB sharedDB] removeItem:self.currentItem];
    [self refreshItemView];
}

- (IBAction)onSelectWant:(id)sender {
    ViewItemViewController* vc = (ViewItemViewController*)[self navigateToViewController:@"viewItem" fromStoryboard:@"Main"];
    vc.selectedItem = self.currentItem;
}

@end
