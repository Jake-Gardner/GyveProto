#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

-(void) homeSelected;
-(void) profileSelected;

@end

@interface FooterViewController : UIViewController

@property (weak) id<FooterViewDelegate> footerViewDelegate;

@end