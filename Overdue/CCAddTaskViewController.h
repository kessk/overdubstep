//
//  CCAddTaskViewController.h
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTaskObject.h"

@protocol AddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(CCTaskObject *)task;

@end

@interface CCAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id <AddTaskViewControllerDelegate> delegate;

- (IBAction)addTaskButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDescriptionTextView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

-(CCTaskObject *)createdTaskObject;
@end
