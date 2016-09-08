#import "NetworkManager.h"

@interface NetworkManager ()
@end

@implementation NetworkManager

+(id)sharedManager {
    static NetworkManager *sharedManager;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}

-(void)makeGetRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"GET" headers:nil body:nil queryParams:nil completion:completion];
}

-(void)makeGetRequest:(NSString*)url queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"GET" headers:nil body:nil queryParams:queryParams completion:completion];
}

-(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:headers body:body queryParams:nil completion:completion];
}

-(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:headers body:body queryParams:queryParams completion:completion];
}

-(void)makePostRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion {
    [self makeNetworkRequest:url type:@"POST" headers:nil body:[NSData new] queryParams:nil completion:completion];
}

-(void)makeNetworkRequest:(NSString*)url type:(NSString*)type headers:(NSDictionary*)headers body:(NSData*)body queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion {
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
    NSURL* baseUrl = [NSURL URLWithString:@"http://localhost:3000/"];       //TODO: config-drive this
    NSURL* relativeUrl = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:baseUrl];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:relativeUrl];
    req.HTTPMethod = type;

    if (headers) {
        for (NSString* key in headers) {
            [req setValue:headers[key] forHTTPHeaderField:key];
        }
    }

    [req setValue:self.userId forHTTPHeaderField:@"authorization"];

    if ([type isEqualToString:@"GET"]) {
        NSURLSessionDataTask* task = [session dataTaskWithRequest:req completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
            if (err != nil) {
                completion(err, nil);
            } else if (((NSHTTPURLResponse*)res).statusCode >= 400) {
                NSError* httpErr = [NSError errorWithDomain:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] code:((NSHTTPURLResponse*)res).statusCode userInfo:nil];
                completion(httpErr, nil);
            } else {
                completion(nil, data);
            }
        }];
        [task resume];
    } else if ([type isEqualToString:@"POST"]) {
        NSURLSessionUploadTask* task = [session uploadTaskWithRequest:req fromData:body completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
            if (err != nil) {
                completion(err, nil);
            } else if (((NSHTTPURLResponse*)res).statusCode >= 400) {
                NSError* httpErr = [NSError errorWithDomain:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] code:((NSHTTPURLResponse*)res).statusCode userInfo:nil];
                completion(httpErr, nil);
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
