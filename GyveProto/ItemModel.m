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
        NSArray* coords = json[@"location"];
        self.location = [[CLLocation alloc] initWithLatitude:((NSNumber*)coords[1]).doubleValue longitude:((NSNumber*)coords[0]).doubleValue];
    }

    return self;
}

@end
