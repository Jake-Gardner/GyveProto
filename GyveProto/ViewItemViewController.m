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
    
    //FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    
//    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         
//         if (error) {
//             // Process error
//         } else if (result.isCancelled) {
//             // Handle cancellations
//         } else {
             FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
             content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com/"];
             
             FBSDKMessageDialog *messageDialog = [[FBSDKMessageDialog alloc] init];
             messageDialog.delegate = self;
             [messageDialog setShareContent:content];
             
             
             if ([messageDialog canShow]) {
                 [messageDialog show];
             } else {
                 // Messenger isn't installed. Redirect the person to the App Store.
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/en/app/facebook-messenger/id454638411?mt=8"]];
             }
//         }
//     }];
}

-(void)
sharer:	(id<FBSDKSharing>)sharer
didCompleteWithResults:	(NSDictionary *)results {
    
}

- (void)
sharer:	(id<FBSDKSharing>)sharer
didFailWithError:	(NSError *)error {
    
}

- (void) sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}
        
//
//
//- (IBAction)messageUser:(id)sender {
//    
//    [FBSDKMessengerSharer
//}

     
     
@end
