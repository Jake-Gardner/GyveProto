//
//  GiveGetList.m
//  GyveProto
//
//  Created by Nick Zankich on 3/23/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "GiveGetList.h"
#import "BorderView.h"

@interface GiveGetList()
@property (strong, nonatomic) IBOutlet UIButton *getToggleButton;
@property (strong, nonatomic) IBOutlet UIButton *giveToggleButton;
@property (strong, nonatomic) IBOutlet UIView *getToggleTab;
@property (strong, nonatomic) IBOutlet UIView *giveToggleTab;

@property (strong, nonatomic) IBOutlet UIView *getContainer;
@property (strong, nonatomic) IBOutlet UIView *giveContainer;

@end

@implementation GiveGetList

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self showGetList];
}

-(void) showGetList {
    self.getContainer.hidden = NO;
    self.giveContainer.hidden = YES;
    
    self.getToggleTab.hidden = NO;
    self.giveToggleTab.hidden = YES;
    
    [self.getToggleButton setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:195.0f/255.0f blue:74.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self.giveToggleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void) showGiveList {
    self.getContainer.hidden = YES;
    self.giveContainer.hidden = NO;

    self.getToggleTab.hidden = YES;
    self.giveToggleTab.hidden = NO;
    
    [self.getToggleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.giveToggleButton setTitleColor:[UIColor colorWithRed:138.0f/255.0f green:195.0f/255.0f blue:74.0f/255.0f alpha:1] forState:UIControlStateNormal];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getTogglePressed:(id)sender {
    [self showGetList];
}

- (IBAction)giveTogglePressed:(id)sender {
    [self showGiveList];
}

@end
