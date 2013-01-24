//
//  Memories.h
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Memory.h"

@class CouchQuery, CouchDatabase, CouchPersistentReplication;

@interface Memories : NSObject

@property (nonatomic, strong) CouchDatabase *database;
@property (nonatomic, strong) CouchPersistentReplication *pull;
@property (nonatomic, strong) CouchPersistentReplication *push;
@property (nonatomic, strong) CouchLiveQuery *conflicts;

- (Memory*) getNewMemory;
- (CouchQuery*) allMemories;

- (void) updateSync;

@end
