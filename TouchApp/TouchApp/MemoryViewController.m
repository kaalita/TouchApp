//
//  MemoryViewController.m
//  TouchApp
//
//  Created by Katrin on 1/15/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "MemoryViewController.h"
#import "AddMemoryViewController.h"

@interface MemoryViewController () <AddMemoryViewControllerDelegate>
{
    UITextView *_textView;
    UIImageView *_imageView;
}

@end

@implementation MemoryViewController

@synthesize memory = _memory;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
                                                                                           target: self
                                                                                           action: @selector(editMemory)];
    
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             [UIScreen mainScreen].applicationFrame.size.width,
                                                             60)];
    _textView.text = _memory.text;
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
    
    if(_memory.image)
    {
        _imageView = [[UIImageView alloc] initWithImage:_memory.image];
        _imageView.frame = CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 280)/2,
                                      _textView.frame.origin.y
                                      + _textView.frame.size.height
                                      + 12,
                                      280,
                                      280);
        [self.view addSubview:_imageView];

    }
}

- (void) editMemory
{
    AddMemoryViewController *addMemoryVC = [[AddMemoryViewController alloc] initWithMemory: _memory];
    addMemoryVC.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: addMemoryVC];
    
    [self presentModalViewController: navigationController
                            animated: YES];
}

#pragma mark - AddMemoryViewControllerDelegate
- (void) addMemoryViewController:(AddMemoryViewController *)vc didSaveMemory:(Memory *)memory
{
    _textView.text = memory.text;
    _imageView.image = memory.image;
    [_textView setNeedsDisplay];
    [_imageView setNeedsDisplay];

    [self dismissModalViewControllerAnimated:YES];
}


@end
