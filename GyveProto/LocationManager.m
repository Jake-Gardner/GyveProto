#import "LocationManager.h"

@import CoreLocation;

@interface LocationManager ()<CLLocationManagerDelegate>
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^handler)(CLLocation*);
@property double updateFrequency;
@end


@implementation LocationManager

+(id)shared {
    static LocationManager *sharedManager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 500;  //meters
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = [locations lastObject];
    NSTimeInterval howRecent = [location.timestamp timeIntervalSinceNow];

    if (self.handler && fabs(howRecent) < self.updateFrequency) {
        self.handler(location);
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(void)registerForUpdates:(double)frequency predicate:(void (^)(CLLocation *))predicate {
    self.handler = predicate;
    self.updateFrequency = frequency;
}

-(CLLocationDistance)metersFromLocation:(CLLocation *)location {
    return [self.locationManager.location distanceFromLocation:location];
}

@end
