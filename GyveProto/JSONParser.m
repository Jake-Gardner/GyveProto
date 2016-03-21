#import "JSONParser.h"

@implementation JSONParser

+(NSDictionary*)parseDictionary:(NSData*)data {
    NSError* err;
    NSDictionary* res = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];

    return err ? nil : res;
}

@end
