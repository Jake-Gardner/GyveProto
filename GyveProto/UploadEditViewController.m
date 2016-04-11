#import "UploadEditViewController.h"
#import "ThingService.h"

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
    [[ThingService sharedService] saveThing:self.image title:self.titleField.text];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
