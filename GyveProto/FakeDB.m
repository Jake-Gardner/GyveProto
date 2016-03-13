//
//  FakeDB.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "FakeDB.h"

@interface FakeDB()
@end

@implementation FakeDB

+(FakeDB*)sharedDB {
    static FakeDB* shared;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

-(void)saveItem:(ItemModel*)item {
    NSURLSession* session = [NSURLSession sharedSession];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/image"]];
    req.HTTPMethod = @"POST";
    NSData* imageData = UIImagePNGRepresentation(item.image);
    NSString *boundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSMutableData *body = [NSMutableData data];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryConstant];
    [req setValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSString* filename = @"image file";
    NSString* fileParamConstant = @"image";
    NSString* fileType = @"image/png";
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileParamConstant, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *postLength = [NSString stringWithFormat:@"%zu", [body length]];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];

    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:req fromData:body completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
        NSLog(@"Success!");
    }];
    [task resume];
}

-(void)getNextItem:(void(^)(ItemModel*))callback {
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithURL:[NSURL URLWithString:@"http://localhost:3000/buffer"] completionHandler:^(NSData* data, NSURLResponse* res, NSError* err) {
        ItemModel* item = [[ItemModel alloc] initWithImage:[UIImage imageWithData:data] title:@""];
        callback(item);
    }];
    [task resume];
}

-(void)removeItem:(ItemModel *)item {
}

@end
