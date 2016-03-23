//
//  FooterViewController.m
//  GyveProto
//
//  Created by Nick Zankich on 3/21/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "FooterViewController.h"
#import "UploadEditViewController.h"
#import "UIViewController+UIViewControllerExtensions.h"

@interface FooterViewController()

@end

@implementation FooterViewController

- (IBAction)onProfileSelected:(id)sender {
    //todo go to profile
}

-(IBAction)onSelectCamera:(id)sender {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"imageSelector"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
