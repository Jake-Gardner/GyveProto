#import "NetworkRequest.h"

@implementation NetworkRequest

+(void)makeGetRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"GET" headers:nil body:nil queryParams:nil completion:completion];
}

+(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:headers body:body queryParams:nil completion:completion];
}

+(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:headers body:body queryParams:queryParams completion:completion];
}

+(void)makeNetworkRequest:(NSString*)url type:(NSString*)type headers:(NSDictionary*)headers body:(NSData*)body queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion {
    NSMutableString* fullUrl = [NSMutableString stringWithString:url];
    if (queryParams) {
        [fullUrl appendString:@"?"];
        NSMutableArray* components = [NSMutableArray new];
        for (NSString* key in queryParams) {
            [components addObject:[NSString stringWithFormat:@"%@=%@", key, queryParams[key]]];
        }
        [fullUrl appendString:[components componentsJoinedByString:@"&"]];
    }

    NSURLSession* session = [NSURLSession sharedSession];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
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
