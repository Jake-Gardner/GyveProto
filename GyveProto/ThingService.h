#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface ThingService : NSObject

+(ThingService*)sharedService;
-(void)refreshThingList:(void(^)())callback;
-(void)loadNextThing:(void(^)(ItemModel*))callback;
-(void)saveThing:(UIImage*)image title:(NSString*)title condition:(NSString*)condition;
-(void)getThing:(ItemModel*)item;
-(void)passThing:(ItemModel*)item;
-(void)junkThing:(ItemModel*)item;

@end
