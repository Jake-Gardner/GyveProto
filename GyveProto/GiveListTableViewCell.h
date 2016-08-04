#import <UIKit/UIKit.h>

@protocol GiveListTableViewCellDelegate <NSObject>

-(void)onChatSelected:(NSDictionary*)item;

@end


@interface GiveListTableViewCell : UITableViewCell

@property NSDictionary* item;
@property (nonatomic, weak) id<GiveListTableViewCellDelegate> delegate;

@end
