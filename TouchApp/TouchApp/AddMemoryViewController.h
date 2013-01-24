//
//  AddMemoryViewController.h
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"

@protocol AddMemoryViewControllerDelegate;

@interface AddMemoryViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id <AddMemoryViewControllerDelegate> delegate;
@property (nonatomic, strong) Memory *memory;

- (id)initWithMemory: (Memory*) memory;

@end

@protocol AddMemoryViewControllerDelegate <NSObject>

- (void)addMemoryViewController: (AddMemoryViewController*) vc didSaveMemory: (Memory*) memory;

@end
