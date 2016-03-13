#import "FakeDB.h"
#import "NetworkRequest.h"

@interface FakeDB()
@end

@implementation FakeDB

+(void)saveItem:(ItemModel*)item {
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

    [NetworkRequest makePostRequest:@"http://localhost:3000/image" headers:headers body:body completion:^(NSError* err, NSData* data) {
        NSLog(@"Success!");
    }];
}

+(void)getNextItem:(void(^)(ItemModel*))callback {
    [NetworkRequest makeGetRequest:@"http://localhost:3000/buffer" completion:^(NSError* err, NSData* data) {
        if (data) {
            callback([[ItemModel alloc] initWithImage:[UIImage imageWithData:data] title:@""]);
        } else {
            callback(nil);
        }
    }];
}

+(void)removeItem:(ItemModel *)item {
}

@end
