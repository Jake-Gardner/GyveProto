//
//  FakeDB.h
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface FakeDB : NSObject

+(FakeDB*)sharedDB;
-(void)saveItem:(ItemModel*)item;
-(void)getNextItem:(void(^)(ItemModel*))callback;
-(void)removeItem:(ItemModel*)item;

@end
