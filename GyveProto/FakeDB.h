#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface FakeDB : NSObject

+(void)saveItem:(ItemModel*)item;
+(void)getNextItem:(void(^)(ItemModel*))callback;
+(void)removeItem:(ItemModel*)item;

@end
