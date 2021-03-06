//
//  RoundedBorderButton.h
//  GyveProto
//
//  Created by Nick Zankich on 3/17/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RoundedBorderButton : UIButton
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable int radius;

@end