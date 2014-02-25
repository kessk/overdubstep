//
//  CCViewController.h
//  Overdue
//
//  Created by Kessler Koh on 2/11/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAddTaskViewController.h"
#import "CCDetailTaskViewController.h"

@interface CCViewController : UIViewController <AddTaskViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, DetailTaskVCDelegate>

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *taskObjects;

@end
