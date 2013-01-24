//
//  CouchSettings.h
//  TouchApp
//
//  Created by Katrin on 1/18/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouchSettings : NSObject

@property (nonatomic, strong) NSURL *syncPoint;
@property BOOL continuousReplication;

+(CouchSettings *) sharedInstance;

@end
