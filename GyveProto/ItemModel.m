#import "ItemModel.h"

@interface ItemModel()

@end

@implementation ItemModel

-(ItemModel *)initWithImage:(UIImage *)image title:(NSString *)title {
    if (self = [super init]) {
        self.image = image;
        self.title = title;
    }
    
    return self;
}

@end
