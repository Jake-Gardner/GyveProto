#import <UIKit/UIKit.h>

@interface ItemModel : NSObject

@property UIImage* image;
@property NSString* title;

-(ItemModel*)initWithImage:(UIImage*)image title:(NSString*)title;

@end
