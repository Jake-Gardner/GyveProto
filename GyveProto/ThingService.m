#import "ThingService.h"
#import "NetworkRequest.h"
#import "JSONParser.h"

@interface ThingService()

@property NSMutableArray* things;

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
        if (err) {
            NSLog(@"Error making things get request: %@", err);
        } else if (data) {
            NSDictionary* res = [JSONParser parseDictionary:data];
            self.things = [NSMutableArray new];
            for (NSDictionary* thing in res[@"things"]) {
                [self.things addObject:[[ItemModel alloc] initWithJson:thing]];
            }
        }

        callback();
    }];
}

-(void)loadNextThing:(void(^)(ItemModel*))callback {
    void(^doLoad)() = ^() {
        ItemModel* next = [self.things firstObject];
        if (!next) {
            callback(nil);
            return;
        }

        [self.things removeObject:next];
        [NetworkRequest makeGetRequest:[@"image/" stringByAppendingString:next.imageId] completion:^(NSError* err, NSData* data) {
            if (err) {
                NSLog(@"Error making thing get request: %@", err);
                callback(nil);
            } else if (data) {
                next.image = [UIImage imageWithData:data];
                callback(next);
            } else {
                callback(nil);
            }
        }];
    };

    if (!self.things) {
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
                             @"title": item.title
                             };
    [NetworkRequest makePostRequest:@"thing" headers:headers body:body queryParams:params completion:^(NSError* err, NSData* data) {
        if (err) {
            NSLog(@"Error making thing save request: %@", err);
        }
    }];
}

-(void)getThing:(ItemModel*)item {
    [NetworkRequest makePostRequest:[@"thing/get/" stringByAppendingString:item._id] completion:^(NSError* err, NSData* data) {
        if (err) {
            NSLog(@"Error making thing get request: %@", err);
        }
    }];
}

-(void)passThing:(ItemModel*)item {
    [NetworkRequest makePostRequest:[@"thing/pass/" stringByAppendingString:item._id] completion:^(NSError* err, NSData* data) {
        if (err) {
            NSLog(@"Error making thing pass request: %@", err);
        }
    }];
}

-(void)junkThing:(ItemModel*)item {
    [NetworkRequest makePostRequest:[@"thing/junk/" stringByAppendingString:item._id] completion:^(NSError* err, NSData* data) {
        if (err) {
            NSLog(@"Error making thing junk request: %@", err);
        }
    }];
}

@end
