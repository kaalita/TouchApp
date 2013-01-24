//
//  Memory.m
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "Memory.h"
#import "WBImage.h"

@interface Memory ()
{
    UIImage *_image;
}

@end

@implementation Memory

@dynamic type, creationDate, lastModified, text;
@synthesize image = _image;

- (id) initWithDatabase:(CouchDatabase *)database
{
    if(self = [super init]) {
        self.database = database;
        self.type = @"memory";
    }
    return self;
}

- (UIImage*) image
{
    if (!_image)
    {
        NSData* imageData = [self attachmentNamed: @"image"].body;
        if(imageData)
            _image = [[UIImage alloc] initWithData: imageData];
    }
    return _image;
}

- (void)setImage:(UIImage *)newImage
{
    _image = [newImage rotateAndScaleFromCameraWithMaxSize:280];
    [self createAttachmentWithName:@"image" type:@"image/png" body:UIImagePNGRepresentation(_image)];
}

/**
 * Overwrite save method to add a creation date and last modified date to the object
 */
- (RESTOperation *)save
{
    NSDate *currentDate = [NSDate date];
    if(!self.creationDate) {
        self.creationDate = currentDate;
    }
    self.lastModified = currentDate;
    
    return [super save];
}

@end
