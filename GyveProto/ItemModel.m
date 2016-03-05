//
//  ItemModel.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "ItemModel.h"

@interface ItemModel()

@end

@implementation ItemModel

-(ItemModel *)initWithImage:(UIImage *)image title:(NSString *)title {
    if (self = [super init]) {
        self.image = image;
        self.title = title;
    }
    
    return self;
}

@end