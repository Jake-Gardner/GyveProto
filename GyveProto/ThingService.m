#import "ThingService.h"
#import "NetworkRequest.h"
#import "JSONParser.h"

@interface ThingService()

@property NSMutableArray* ids;

@end

@implementation ThingService

+(ThingService*)sharedService {
    static ThingService* shared;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });

    return shared;
}

-(void)refreshThingList:(void(^)())callback {
    [NetworkRequest makeGetRequest:@"things" completion:^(NSError* err, NSData* data) {
        if (data) {
            NSDictionary* res = [JSONParser parseDictionary:data];
            self.ids = [NSMutableArray new];
            for (NSDictionary* thing in res[@"things"]) {
                // TODO: get other data from json here
                [self.ids addObject:thing[@"image"]];
            }
        }

        callback();
    }];
}

-(void)loadNextThing:(void(^)(ItemModel*))callback {
    void(^doLoad)() = ^() {
        NSString* next = [self.ids firstObject];
        if (!next) {
            callback(nil);
            return;
        }

        [self.ids removeObject:next];
        [NetworkRequest makeGetRequest:[@"thing/" stringByAppendingString:next] completion:^(NSError* err, NSData* data) {
            if (data) {
                callback([[ItemModel alloc] initWithImage:[UIImage imageWithData:data] title:@""]);
            } else {
                callback(nil);
            }
        }];
    };

    if (!self.ids) {
        [self refreshThingList:doLoad];
    } else {
        doLoad();
    }
}

-(void)saveThing:(ItemModel*)item {
    NSData* imageData = UIImagePNGRepresentation(item.image);
    NSString *boundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString* filename = @"image file";
    NSString* fileParamConstant = @"image";
    NSString* fileType = @"image/png";

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileParamConstant, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryConstant];
    NSString *postLength = [NSString stringWithFormat:@"%zu", body.length];
    NSDictionary* headers = @{
                              @"Content-Type": contentType,
                              @"Content-Length": postLength
                              };

    NSDictionary* params = @{
                             @"user": @"USER_ID",
                             @"title": item.title
                             };
    [NetworkRequest makePostRequest:@"thing" headers:headers body:body queryParams:params completion:^(NSError* err, NSData* data) {
    }];
}

@end
