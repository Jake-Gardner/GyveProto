#import "FooterViewController.h"
#import "UIViewController+UIViewControllerExtensions.h"

@interface FooterViewController()
@property (strong, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@end

@implementation FooterViewController

- (IBAction)homeSelected:(id)sender {
    [self.footerViewDelegate homeSelected];
    
    [self.homeButton setImage:[UIImage imageNamed:@"home_blue.png"] forState:UIControlStateNormal];
    
    //TODO update to grey
    [self.profileButton setImage:[UIImage imageNamed:@"profile_blue.png"] forState:UIControlStateNormal];
}

- (IBAction)onProfileSelected:(id)sender {
    [self.footerViewDelegate profileSelected];
    
    [self.homeButton setImage:[UIImage imageNamed:@"home_grey.png"] forState:UIControlStateNormal];
    
    [self.profileButton setImage:[UIImage imageNamed:@"profile_blue.png"] forState:UIControlStateNormal];
}

-(IBAction)onSelectCamera:(id)sender {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"uploadEdit"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
