#import <Foundation/Foundation.h>

@interface NetworkRequest : NSObject

+(void)makeGetRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion;
+(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion;

@end
