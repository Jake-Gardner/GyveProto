#import <Foundation/Foundation.h>

@import CoreLocation;

@interface LocationManager : NSObject

+(LocationManager*)shared;

-(void)registerForUpdates:(double)frequency predicate:(void (^)(CLLocation*))predicate;
-(CLLocationDistance)metersFromLocation:(CLLocation*)location;

@end
