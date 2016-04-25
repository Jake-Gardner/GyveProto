//
//  GiveListTableViewCell.m
//  GyveProto
//
//  Created by Nick Zankich on 3/26/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "GiveListTableViewCell.h"

@implementation GiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)messageButtonPressed:(id)sender {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MesssageViewController"];

    [self.parentVC.navigationController pushViewController:vc animated:YES];
}

@end