//
//  HeaderViewController.m
//  GyveProto
//
//  Created by Nick Zankich on 3/23/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "HeaderViewController.h"

@implementation HeaderViewController

- (IBAction)giveGetButtonPressed:(id)sender {
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"GiveGetList"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
