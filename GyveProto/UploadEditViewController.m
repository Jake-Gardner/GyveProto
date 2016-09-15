#import "UploadEditViewController.h"
#import "ThingService.h"

@interface UploadEditViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *conditionSelector;

@property UIImage* image;

@end

@implementation UploadEditViewController

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

- (IBAction)onPostSelected:(id)sender {
    if (self.titleField.text.length == 0) {
        return;
    }

    NSString* condition;
    switch (self.conditionSelector.selectedSegmentIndex) {
        case 0:
            condition = @"new";
            break;
        case 1:
            condition = @"good";
            break;
        case 2:
            condition = @"okay";
            break;
        case 3:
            condition = @"bad";
            break;
    }

    [[ThingService sharedService] saveThing:self.image title:self.titleField.text condition:condition];

    // TODO: wait for success
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    self.image = info[UIImagePickerControllerEditedImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
