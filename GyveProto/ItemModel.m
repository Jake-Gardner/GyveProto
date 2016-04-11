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

-(ItemModel*)initWithJson:(NSDictionary*)json {
    if (self = [super init]) {
        self._id = json[@"_id"];
        self.title = json[@"title"];
        self.imageId = json[@"image"];
    }

    return self;
}

@end
