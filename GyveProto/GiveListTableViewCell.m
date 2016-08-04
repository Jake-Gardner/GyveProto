#import "GiveListTableViewCell.h"

@implementation GiveListTableViewCell

- (IBAction)messageButtonPressed:(id)sender {
    [self.delegate onChatSelected:self.item];
}

@end