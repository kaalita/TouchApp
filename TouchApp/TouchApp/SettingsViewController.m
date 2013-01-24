//
//  SettingsViewController.m
//  TouchApp
//
//  Created by Katrin on 1/18/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "SettingsViewController.h"
#import "CouchSettings.h"

@interface SettingsViewController ()
{
    UITextField *_syncPoint;
    UISwitch *_continuousSwitch;
}

@end

@implementation SettingsViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Settings";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave
                                                                                           target: self
                                                                                           action: @selector(saveSettings)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                          target: self
                                                                                          action: @selector(dismissModalViewControllerAnimated:)];


    
    UILabel *syncPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,
                                                                        12,
                                                                        [UIScreen mainScreen].applicationFrame.size.width - 12,
                                                                        20)];
    syncPointLabel.font = [UIFont boldSystemFontOfSize:16];
    syncPointLabel.text = @"Sync Point URL:";
    [self.view addSubview:syncPointLabel];    

    _syncPoint = [[UITextField alloc] initWithFrame:CGRectMake(12,
                                                               syncPointLabel.frame.origin.y
                                                               + syncPointLabel.frame.size.height
                                                               + 12,
                                                               [UIScreen mainScreen].applicationFrame.size.width - 24,
                                                               30)];
    _syncPoint.borderStyle = UITextBorderStyleRoundedRect;
    _syncPoint.text = [CouchSettings sharedInstance].syncPoint.absoluteString;
    _syncPoint.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _syncPoint.autocorrectionType = UITextAutocorrectionTypeNo;
    _syncPoint.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_syncPoint becomeFirstResponder];
    [self.view addSubview:_syncPoint];
    
    UILabel *continuousLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,
                                                                        _syncPoint.frame.origin.y
                                                                        + _syncPoint.frame.size.height
                                                                        + 24,
                                                                        [UIScreen mainScreen].applicationFrame.size.width - 24,
                                                                         20)];
    continuousLabel.font = [UIFont boldSystemFontOfSize:16];
    continuousLabel.text = @"Continuous replication:";
    [self.view addSubview:continuousLabel];
    
    _continuousSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(12,
                                                                   continuousLabel.frame.origin.y
                                                                   + continuousLabel.frame.size.height
                                                                   + 6,
                                                                   60,
                                                                   30)];
    _continuousSwitch.on = [CouchSettings sharedInstance].continuousReplication;
    [self.view addSubview:_continuousSwitch];
}

- (void) saveSettings
{
    NSURL *syncPoint = [NSURL URLWithString:_syncPoint.text];
    if(syncPoint) {
        [CouchSettings sharedInstance].syncPoint = syncPoint;
    }
    
    [CouchSettings sharedInstance].continuousReplication = _continuousSwitch.on;
    
    if([_delegate respondsToSelector: @selector(didChangeSettings)])
        [_delegate didChangeSettings];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
