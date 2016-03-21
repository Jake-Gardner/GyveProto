#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface ThingService : NSObject

+(ThingService*)sharedService;
-(void)refreshThingList:(void(^)())callback;
-(void)loadNextThing:(void(^)(ItemModel*))callback;
-(void)saveThing:(ItemModel*)item;

@end
