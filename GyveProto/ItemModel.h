#import <UIKit/UIKit.h>
@import CoreLocation;

@interface ItemModel : NSObject

@property UIImage* image;
@property NSString* title;
@property NSString* imageId;
@property NSString* _id;
@property CLLocation* location;

-(ItemModel*)initWithImage:(UIImage*)image title:(NSString*)title;
-(ItemModel*)initWithJson:(NSDictionary*)json;

@end
