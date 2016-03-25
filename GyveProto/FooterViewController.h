//
//  FooterViewController.h
//  GyveProto
//
//  Created by Nick Zankich on 3/21/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

-(void) homeSelected;
-(void) profileSelected;

@end

@interface FooterViewController : UIViewController

@property (weak) id<FooterViewDelegate> footerViewDelegate;

@end