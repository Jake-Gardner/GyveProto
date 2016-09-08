#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

@property NSString* userId;

+(NetworkManager*)sharedManager;

-(void)makeGetRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion;
-(void)makeGetRequest:(NSString*)url queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion;
-(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body completion:(void(^)(NSError*, NSData*))completion;
-(void)makePostRequest:(NSString*)url headers:(NSDictionary*)headers body:(NSData*)body queryParams:(NSDictionary*)queryParams completion:(void(^)(NSError*, NSData*))completion;
-(void)makePostRequest:(NSString*)url completion:(void(^)(NSError*, NSData*))completion;

@end
