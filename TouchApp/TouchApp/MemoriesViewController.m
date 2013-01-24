//
//  RootViewController.m
//  TouchApp
//
//  Created by Katrin on 1/9/13.
//  Copyright (c) 2013 Katrin Apel. All rights reserved.
//

#import "MemoriesViewController.h"
#import "Memories.h"
#import "AddMemoryViewController.h"
#import "MemoryViewController.h"
#import "SettingsViewController.h"
#import "CouchSettings.h"

@interface MemoriesViewController () <AddMemoryViewControllerDelegate, SettingsViewControllerDelegate>

@property (nonatomic, strong) Memories *memories;

@end

@implementation MemoriesViewController

@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize memories = _memories;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _memories = [[Memories alloc] init];
    
    self.title = @"Memories";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                                           target: self
                                                                                           action: @selector(addMemory)];
    
    // Setup toolbar
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle: @"Settings"
                                                                       style: UIBarButtonItemStyleBordered
                                                                      target: self
                                                                      action: @selector(editSettings)];
    [self setToolbarItems:@[settingsButton]];
    
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Setup tableview with a CouchLiveQuery as datasource
    // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    [CouchUITableSource class];     // Prevents class from being dead-stripped by linker
    _dataSource = [[CouchUITableSource alloc] init];
    _dataSource.query = [[_memories allMemories] asLiveQuery];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0,
                                                                    0.0,
                                                                    [[UIScreen mainScreen] bounds].size.width,
                                                                    [UIScreen mainScreen].applicationFrame.size.height
                                                                    - self.navigationController.navigationBar.frame.size.height
                                                                    - self.navigationController.toolbar.frame.size.height)
                                                  style: UITableViewStylePlain];
    _tableView.rowHeight = 58;
    _tableView.delegate = self;
    _tableView.dataSource = self.dataSource;
    _tableView.allowsSelection = YES;
    
    self.dataSource.tableView = _tableView;
    
    [self.view addSubview:_tableView];
    
    [_memories updateSync];
    
    [_memories.conflicts addObserver: self
                          forKeyPath: @"rows"
                             options: 0
                             context: 0];
}

- (void) addMemory
{
    AddMemoryViewController *addMemoryVC = [[AddMemoryViewController alloc] initWithMemory: [_memories getNewMemory]];
    addMemoryVC.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: addMemoryVC];
    
    [self presentModalViewController: navigationController
                            animated: YES];
}

- (void) editSettings
{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: settingsVC];
    
    [self presentModalViewController: navigationController
                            animated: YES];
}

#pragma mark - SettingsViewControllerDelegate
- (void) didChangeSettings
{
    [_memories updateSync];
}

#pragma mark - Couch table source delegate

/** Allows delegate to return its own custom cell, just like -tableView:cellForRowAtIndexPath:.
 If this returns nil the table source will create its own cell, as if this method were not implemented. */
- (UITableViewCell *)couchTableSource:(CouchUITableSource*)source
                cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [source.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    CouchQueryRow *row = [source.rows objectAtIndex: indexPath.row];
    CouchDocument *doc = row.document;
    Memory *memory = [Memory modelForDocument:doc];
    cell.textLabel.text = memory.text;
    cell.imageView.image = memory.image;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Memory *selectedMemory = [Memory modelForDocument: [_dataSource rowAtIndex:indexPath.row].document];
    
    MemoryViewController *memoryVC = [[MemoryViewController alloc] init];
    memoryVC.memory = selectedMemory;
    [self.navigationController pushViewController: memoryVC
                                         animated: true];
}

#pragma mark - AddMemoryViewControllerDelegate
- (void) addMemoryViewController:(AddMemoryViewController *)vc didSaveMemory:(Memory *)memory
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
