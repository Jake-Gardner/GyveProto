//
//  UploadEditViewController.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "UploadEditViewController.h"
#import "FakeDB.h"

@interface UploadEditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UITextView *titleField;

@end

@implementation UploadEditViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.previewImage.image = self.image;
}

#pragma mark - Interface interactions

- (IBAction)onPostSelected:(id)sender {
    ItemModel* item = [[ItemModel alloc] initWithImage:self.image title:self.titleField.text];
    [FakeDB saveItem:item];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
