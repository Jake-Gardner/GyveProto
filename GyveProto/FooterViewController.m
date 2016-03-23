//
//  FooterViewController.m
//  GyveProto
//
//  Created by Nick Zankich on 3/21/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "FooterViewController.h"
#import "UIViewController+UIViewControllerExtensions.h"

@interface FooterViewController()

@end

@implementation FooterViewController

- (IBAction)onProfileSelected:(id)sender {
    //[self navigateToViewController:@"LoginViewController" fromStoryboard:@"Main"];
}

-(IBAction)onSelectCamera:(id)sender {
    [self navigateToViewController:@"imageSelector" fromStoryboard:@"Main"];
}

@end
