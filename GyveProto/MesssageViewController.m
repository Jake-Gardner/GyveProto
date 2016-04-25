//
//  MesssageViewController.m
//  GyveProto
//
//  Created by Nick Zankich on 4/3/16.
//  Copyright © 2016 Jake Gardner, CTO. All rights reserved.
//

#import "MesssageViewController.h"
#import "GyveProto-Swift.h"

@interface MesssageViewController ()
@property (strong, nonatomic) IBOutlet UITextView *messsageTextView;
@property (strong, nonatomic) IBOutlet UITextField *sendMessageTextField;
@property (strong, nonatomic) SocketIOClient *socket;

@end

@implementation MesssageViewController


- (IBAction)sendClicked:(id)sender {
    [self.sendMessageTextField resignFirstResponder];

    [self.socket emit:@"message" withItems:@[self.sendMessageTextField.text]];

    self.sendMessageTextField.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSocket];
}

-(void) initSocket {
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:3000/admin/chat"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [self.socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSString* message = [data objectAtIndex:0];
        
        self.messsageTextView.text = [NSString stringWithFormat: @"%@\n%@", self.messsageTextView.text, message];
    }];
    
    [self.socket connect];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end