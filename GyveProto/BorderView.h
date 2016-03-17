//
//  BorderView.h
//  GyveProto
//
//  Created by Nick Zankich on 3/17/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface BorderView : UIView

@property (nonatomic) IBInspectable NSInteger topWidth;
@property (nonatomic) IBInspectable UIColor *topColor;

@property (nonatomic) IBInspectable NSInteger rightWidth;
@property (nonatomic) IBInspectable UIColor *rightColor;

@property (nonatomic) IBInspectable NSInteger bottomWidth;
@property (nonatomic) IBInspectable UIColor *bottomColor;

@property (nonatomic) IBInspectable NSInteger leftWidth;
@property (nonatomic) IBInspectable UIColor *leftColor;

@end
