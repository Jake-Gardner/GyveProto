#import "MesssageViewController.h"
#import "GyveProto-Swift.h"

@interface MesssageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *sendMessageTextField;
@property (strong, nonatomic) SocketIOClient *socket;

@property NSMutableArray* messages;

@end

@implementation MesssageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messages = [NSMutableArray new];

    [self initSocket];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];

    cell.textLabel.text = [self.messages objectAtIndex:indexPath.row];

    return cell;
}

-(void) addMessage:(NSDictionary*)msg {
    NSString* name = msg[@"sender"][@"fbId"];
    [self.messages addObject:[NSString stringWithFormat:@"%@: %@", name, msg[@"text"]]];
    [self.chatTableView reloadData];
}

- (IBAction)sendClicked:(id)sender {
    [self.sendMessageTextField resignFirstResponder];

    [self.socket emit:@"message" withItems:@[self.sendMessageTextField.text]];

    self.sendMessageTextField.text = @"";
}

-(void) initSocket {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");

        [self.socket emit:@"init chat" withItems:@[@{
                                                       @"senderId": @"Rosencrantz",
                                                       @"receiverId": @"Guildenstern"
                                                       }]];
    }];
    
    [self.socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSDictionary* message = [data firstObject];
        
        [self addMessage:message];
    }];

    [self.socket on:@"message list" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSArray* messages = [data firstObject];

        for (int i = 0; i < messages.count; i++) {
            [self addMessage:[messages objectAtIndex:i]];
        }
    }];
    
    [self.socket connect];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end