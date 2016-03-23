//
//  RoundedBorderImage.m
//  GyveProto
//
//  Created by Nick Zankich on 3/23/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "RoundedBorderImage.h"

@implementation RoundedBorderImage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

-(void) setup {
    if (self) {
        self.layer.cornerRadius = self.layer.frame.size.height/2;
        
        if (self.borderColor && self.borderWidth) {
            self.layer.borderColor = self.borderColor.CGColor;
            self.layer.borderWidth = self.borderWidth;
        } else {
            self.layer.borderWidth = 0;
        }
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    [self setup];
}


@end
