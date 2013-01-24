//
//  Memory.h
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <CouchCocoa/CouchCocoa.h>

@interface Memory : CouchModel

@property (copy) NSString *type;
@property (copy) NSDate *creationDate;
@property (copy) NSDate *lastModified;
@property (copy) NSString *text;
@property (copy) UIImage *image;

- (id) initWithDatabase: (CouchDatabase*) database;

@end
