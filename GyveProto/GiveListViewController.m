#import "GiveListViewController.h"
#import "GiveListTableViewCell.h"

@interface GiveListViewController ()

@end

@implementation GiveListViewController 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveListTableViewCell"];
    
    cell.parentVC = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end