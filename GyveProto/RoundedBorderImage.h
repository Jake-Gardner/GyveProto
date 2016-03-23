//
//  RoundedBorderImage.h
//  GyveProto
//
//  Created by Nick Zankich on 3/23/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//


#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RoundedBorderImage : UIImageView
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;


@end
