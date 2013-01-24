//
//  SettingsViewController.h
//  TouchApp
//
//  Created by Katrin on 1/18/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id delegate;

@end

@protocol SettingsViewControllerDelegate <NSObject>

- (void) didChangeSettings;

@end