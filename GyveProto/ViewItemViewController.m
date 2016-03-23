//
//  ViewItemViewController.m
//  GyveProto
//
//  Created by Jake Gardner, CTO on 2/14/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "ViewItemViewController.h"


@interface ViewItemViewController()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@end

@implementation ViewItemViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemImage.image = self.selectedItem.image;
    self.itemTitle.text = self.selectedItem.title;
}
     
     
@end
