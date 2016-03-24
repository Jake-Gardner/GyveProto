//
//  RatingView.m
//  GyveProto
//
//  Created by Nick Zankich on 3/24/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "RatingView.h"

@interface RatingView()
@property (nonatomic) UIView *wrapper;
@end

@implementation RatingView


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

#define STAR_PADDING 5

-(void) setup {
    if (self) {
        [self.wrapper removeFromSuperview];
        
        self.wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.wrapper];
        
        //todo clean out old stars
        UIImage *image;
        int starWidth = self.frame.size.width/5;
        int starHeight = self.frame.size.height;
        int rating = round(MAX(MIN(self.rating, 5), 0) * 1000)/1000;
        
        for (int i = 0; i < 5; i++) {
            if (rating-- > 0) {
                 image = [UIImage imageNamed:@"star_gold_big.png"];
            } else {
                 image = [UIImage imageNamed:@"star_grey_big.png"];
            }
            UIImageView* star = [[UIImageView alloc] initWithFrame:CGRectMake(i * starWidth + i * STAR_PADDING, 0, starWidth, starHeight)];
            star.image = image;
            [self.wrapper addSubview:star];
        }
    }
}

-(void) setRating:(double)rating {
    [self setup];
}



@end
