#import "ViewController.h"
#import "FooterViewController.h"

@interface ViewController () <FooterViewDelegate>

@property (nonatomic) BOOL homeShown;
@property (strong, nonatomic) IBOutlet UIView *navControllerContainer;
@property (strong, nonatomic) UINavigationController *subNavController;
@property (nonatomic) FooterViewController *footerVC;
@end

@implementation ViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.homeShown = YES;
}

-(void) homeSelected {
    if (!self.homeShown) {
        self.homeShown = YES;
        
        [self.subNavController.view removeFromSuperview];
        
        UINavigationController *navCon = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavController"];
        
        [self addChildViewController:navCon];
        
        navCon.view.frame = CGRectMake(0, 0, self.navControllerContainer.frame.size.width, self.navControllerContainer.frame.size.height);
        [self.navControllerContainer addSubview:navCon.view];
        [navCon didMoveToParentViewController:self];
        
        self.subNavController = navCon;
    }
}

-(void) profileSelected {
    if (self.homeShown) {
        self.homeShown = NO;
        
         [self.subNavController.view removeFromSuperview];

        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        UINavigationController *navCon = [sb instantiateViewControllerWithIdentifier:@"ProfileNavController"];

        [self addChildViewController:navCon];
        
        navCon.view.frame = CGRectMake(0, 0, self.navControllerContainer.frame.size.width, self.navControllerContainer.frame.size.height);
        [self.navControllerContainer addSubview:navCon.view];
        [navCon didMoveToParentViewController:self];
        
        self.subNavController = navCon;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FooterViewController"]) {
        self.footerVC = segue.destinationViewController;
        self.footerVC.footerViewDelegate = self;
    } else if ([segue.identifier isEqualToString:@"HomeNavController"]) {
        self.subNavController = segue.destinationViewController;
    }
}

@end
