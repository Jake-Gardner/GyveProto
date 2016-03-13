#import "NetworkRequest.h"

@implementation NetworkRequest

+(void)makeGetRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"GET" headers:nil body:nil completion:completion];
}

+(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:headers body:body completion:completion];
}

+(void)makeNetworkRequest:(NSString*)url type:(NSString*)type headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion {
    NSURLSession* session = [NSURLSession sharedSession];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    req.HTTPMethod = type;

    if (headers) {
        for (NSString* key in headers) {
            [req setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    if ([type isEqualToString:@"GET"]) {
        NSURLSessionDataTask* task = [session dataTaskWithRequest:req completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
            if (err != nil || ((NSHTTPURLResponse*)res).statusCode >= 400) {
                completion(err, nil);
            } else {
                completion(nil, data);
            }
        }];
        [task resume];
    } else if ([type isEqualToString:@"POST"]) {
        NSURLSessionUploadTask* task = [session uploadTaskWithRequest:req fromData:body completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
            if (err != nil || ((NSHTTPURLResponse*)res).statusCode >= 400) {
                completion(err, nil);
            } else {
                completion(nil, data);
            }
        }];
        [task resume];
    } else {
        NSLog(@"Unsupported network request type made: %@", type);
    }
}

@end
