//
//  CouchSettings.m
//  TouchApp
//
//  Created by Katrin on 1/18/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "CouchSettings.h"

@implementation CouchSettings

static CouchSettings *sharedInstance = nil;

+ (CouchSettings *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

- (NSURL *)syncPoint
{
    return [NSURL URLWithString: [[NSUserDefaults standardUserDefaults] objectForKey:@"syncpoint"]];
}

- (BOOL)continuousReplication
{
    BOOL continuous = ((NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"continuous"]).boolValue;
    return continuous;
}

- (void)setSyncPoint: (NSURL *)syncPoint
{
    [[NSUserDefaults standardUserDefaults] setObject: [syncPoint absoluteString]
                                              forKey: @"syncpoint"];
}

- (void) setContinuousReplication: (BOOL)continuous
{
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithBool:continuous]
                                              forKey: @"continuous"];
}

@end
