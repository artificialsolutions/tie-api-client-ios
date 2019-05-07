//
//  ViewController.m
//  TieExampleObjC
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

#import "ViewController.h"
@import TieApiClient;

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextView *message;
@property (nonatomic, weak) IBOutlet UITextField *param1Key;
@property (nonatomic, weak) IBOutlet UITextField *param1Value;
@property (nonatomic, weak) IBOutlet UITextField *param2Key;
@property (nonatomic, weak) IBOutlet UITextField *param2Value;
@property (nonatomic, weak) IBOutlet UILabel *response;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = [NSError new];
    
    // NOTE: Replace with correct base url and endpoint
    // the base url, including https://
    NSString *BASE_URL = @"replace_with_base_url_of_teneo_engine";
    // engine path, like /solution_0x383bjp5a8e6tscbjd9x03tvb/ note: make sure it ends with a slash (/)
    NSString *ENDPOINT = @"replace_with_path_of_teneo_engine";
    
    [TieApiService.sharedInstance setup:BASE_URL endpoint:ENDPOINT error:&error];
    }

- (IBAction)sendMessage:(id)sender {
    NSString *msg = self.message.text;
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.param1Key.text != nil && self.param1Value.text != nil) {
        params[self.param1Key.text] = self.param1Value.text;
    }
    if (self.param2Key.text != nil && self.param2Value.text != nil) {
        params[self.param2Key.text] = self.param2Value.text;
    }
    
    
    [TieApiService.sharedInstance sendInput:msg parameters:params success:^(TieResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.response.text = response.output.text;
        });
    } failure:nil];
}

- (IBAction)closeSession:(id)sender {
    [TieApiService.sharedInstance closeSession:^(TieCloseSessionResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.response.text = response.message;
        });
    } failure:nil];
}

@end
