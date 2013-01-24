//
//  AddMemoryViewController.m
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "AddMemoryViewController.h"

@interface AddMemoryViewController ()
{
    UITextView *_textInput;
    UIImageView *imageView;
}

@end

@implementation AddMemoryViewController

@synthesize memory = _memory, delegate = _delegate;

- (id)initWithMemory: (Memory*) memory
{
    if(self = [super init])
    {
        self.memory = memory;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"New memory";
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                  target: self
                                                  action: @selector(dismissModalViewControllerAnimated:)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave
                                                  target: self
                                                  action: @selector(saveMemory)];
    
    _textInput = [[UITextView alloc] initWithFrame:
                 CGRectMake(12,
                            12,
                            [[UIScreen mainScreen] bounds].size.width - 12*2,
                            120)];
    _textInput.textColor = [UIColor darkGrayColor];
    _textInput.font = [UIFont systemFontOfSize:17.0];
    _textInput.returnKeyType = UIReturnKeyDone;
    _textInput.text = _memory.text;
    [_textInput becomeFirstResponder];
    [self.view addSubview:_textInput];
        
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pictureButton.frame = CGRectMake(12,
                                     _textInput.frame.origin.y
                                     + _textInput.frame.size.height
                                     + 12,
                                     [[UIScreen mainScreen] bounds].size.width - 12*2,
                                     30);
    [pictureButton setTitle: @"Add picture"
                   forState: UIControlStateNormal];
    pictureButton.tintColor = [UIColor lightGrayColor];
    [pictureButton addTarget: self
                      action: @selector(addPicture)
            forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:pictureButton];
}

- (void) addPicture
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
            
    [self presentModalViewController: imagePicker
                            animated: YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated: YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
	_memory.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
}

- (void) saveMemory
{
    _memory.text = _textInput.text;
    [[_memory save] wait];
    
    if([_delegate respondsToSelector:@selector(addMemoryViewController:didSaveMemory:)])
       [_delegate addMemoryViewController:self didSaveMemory:_memory];
}

@end
