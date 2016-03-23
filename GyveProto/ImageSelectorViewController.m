//
//  ImageSelectorViewController.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "ImageSelectorViewController.h"
#import "UIViewController+UIViewControllerExtensions.h"
#import "UploadEditViewController.h"

@implementation ImageSelectorViewController

#pragma mark - Interface interactions

-(IBAction)onSelectCamera:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No device" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(IBAction)onSelectGallery:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    UploadEditViewController* vc = (UploadEditViewController*)[self navigateToViewController:@"uploadEdit" fromStoryboard:@"Main"];
    vc.image = info[UIImagePickerControllerEditedImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
