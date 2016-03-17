//
//  BorderView.m
//  GyveProto
//
//  Created by Nick Zankich on 3/17/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "BorderView.h"

@implementation BorderView

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

-(void) layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

-(void) setup {
    if (self) {
        //self.layer
        [self topBorderSetup];
        [self rightBorderSetup];
        [self bottomBorderSetup];
        [self leftBorderSetup];
    }
}

-(void) topBorderSetup {
    if (!self.topWidth || !self.topColor) {
        return;
    }
    
    CALayer *border = [CALayer layer];

    border.backgroundColor = self.topColor.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, self.topWidth);
    [self.layer addSublayer:border];
}

-(void) rightBorderSetup {
    if (!self.rightWidth || !self.rightColor) {
        return;
    }
    
    CALayer *border = [CALayer layer];

    border.backgroundColor = self.rightColor.CGColor;

    border.frame = CGRectMake(self.frame.size.width - self.rightWidth, 0, self.rightWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

-(void) bottomBorderSetup {
    if (!self.bottomWidth || !self.bottomColor) {
        return;
    }
    
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = self.bottomColor.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - self.bottomWidth, self.frame.size.width, self.bottomWidth);
    [self.layer addSublayer:border];
}

-(void) leftBorderSetup {
    if (!self.leftWidth || !self.leftColor) {
        return;
    }
    
    CALayer *border = [CALayer layer];
    
    border.backgroundColor = self.leftColor.CGColor;
    border.frame = CGRectMake(0, 0, self.leftWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

@end
