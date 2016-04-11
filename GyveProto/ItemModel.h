#import <UIKit/UIKit.h>

@interface ItemModel : NSObject

@property UIImage* image;
@property NSString* title;
@property NSString* imageId;
@property NSString* _id;

-(ItemModel*)initWithImage:(UIImage*)image title:(NSString*)title;
-(ItemModel*)initWithJson:(NSDictionary*)json;

@end
