#import "GiveListViewController.h"
#import "GiveListTableViewCell.h"

@interface GiveListViewController () <GiveListTableViewCellDelegate>

@property NSArray* fakeData;

@end

@implementation GiveListViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.fakeData = @[@{}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveListTableViewCell"];

    cell.delegate = self;
    cell.item = [self.fakeData objectAtIndex:indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fakeData.count;
}

-(void)onChatSelected:(NSDictionary*)item {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MesssageViewController"];

    [self.navigationController pushViewController:vc animated:YES];
}

@end