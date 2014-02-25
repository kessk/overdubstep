//
//  CCDetailTaskViewController.h
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTaskObject.h"
#import "CCEditTaskViewController.h"

@protocol DetailTaskVCDelegate <NSObject>

-(void)updateTasks;

@end
@interface CCDetailTaskViewController : UIViewController <EditTaskVCDelegate>

@property (weak, nonatomic) id <DetailTaskVCDelegate> delegate;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UILabel *taskNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskDescriptionTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) CCTaskObject *taskObject;
@property (nonatomic) NSInteger indexPathRow;

@end
