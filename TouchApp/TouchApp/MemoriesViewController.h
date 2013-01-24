//
//  RootViewController.h
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchCocoa/CouchUITableSource.h>

@interface MemoriesViewController : UIViewController <CouchUITableDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CouchUITableSource* dataSource;

@end
