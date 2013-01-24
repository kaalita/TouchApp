//
//  Memories.m
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "Memories.h"
#import <CouchCocoa/CouchCocoa.h>
#import "CouchSettings.h"

@implementation Memories

@synthesize database = _database,
            push = _push,
            pull = _pull,
            conflicts = _conflicts;

- (id)init
{
    if(self = [super init])
    {
        // +++++++++++++++++++++++++++++++++++++++++++++
        //     TouchDB setup
        // +++++++++++++++++++++++++++++++++++++++++++++        
        
        //gRESTLogLevel = kRESTLogRequestHeaders;
        gCouchLogLevel = 1;
        
        // Creating TouchDB server
        CouchTouchDBServer* server = [CouchTouchDBServer sharedInstance];
        NSAssert(!server.error, @"Error creating TouchDBServer: %@", [server.error localizedDescription]);
        
        // Creating a local database (db name must be lowercase)
        self.database = [server databaseNamed: @"memories"];
        NSError* error;
        if (![self.database ensureCreated: &error]) {
            NSLog(@"Error creating database: %@", [error localizedDescription]);
        };
        self.database.tracksChanges = YES;
                
        // +++++++++++++++++++++++++++++++++++++++++++++
        //     Create views to retrieve the data
        // +++++++++++++++++++++++++++++++++++++++++++++
        
        // Create a 'view' for retrieving all memories
        CouchDesignDocument* memoriesDesignDoc = [_database designDocumentWithName: @"memories"];
        [memoriesDesignDoc defineViewNamed: @"all"
                                  mapBlock: MAPBLOCK({
            
            NSString* type = [doc objectForKey: @"type"];
            NSDate *creationDate = [doc objectForKey: @"creationDate"];
            if ([type isEqualToString:@"memory"]) emit(creationDate, doc);
        })
                                   version: @"1.0"];
        

        // Create a 'view' for retrieving all documents with conflicts
        CouchDesignDocument* conflictsDesignDoc = [_database designDocumentWithName: @"conflicts"];
        [conflictsDesignDoc defineViewNamed: @"all"
                                  mapBlock: MAPBLOCK({

            NSString *docId = [doc objectForKey: @"_id"];
            NSArray *conflicts = [doc objectForKey: @"_conflicts"];
            if (conflicts) emit(docId, conflicts);
        })
                                   version: @"1.0"];
                
        _conflicts = [[[_database designDocumentWithName: @"conflicts"] queryViewNamed: @"all"] asLiveQuery];
        
    }
    return self;
}

- (void) updateSync
{
    if (!self.database)
        return;
    
    // +++++++++++++++++++++++++++++++++++++++++++++
    //     Create replications for data synching
    // +++++++++++++++++++++++++++++++++++++++++++++
    
    NSArray* repls = [self.database replicateWithURL: [CouchSettings sharedInstance].syncPoint
                                         exclusively: NO];
    _pull = [repls objectAtIndex: 0];
    _pull.continuous = [CouchSettings sharedInstance].continuousReplication;
    _push = [repls objectAtIndex: 1];
    _push.continuous = [CouchSettings sharedInstance].continuousReplication;
}

- (Memory *)getNewMemory
{
    Memory* memory = [[Memory alloc] initWithDatabase:_database];
    return memory;
}

- (CouchQuery*) allMemories
{
    CouchQuery *query = [[_database designDocumentWithName: @"memories"] queryViewNamed: @"all"];
    query.descending = YES;
    return query;
}

@end
