//
//  CCEditTaskViewController.h
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTaskObject.h"

@protocol EditTaskVCDelegate <NSObject>

- (void)saveButtonPressed;

@end

@interface CCEditTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) id <EditTaskVCDelegate> delegate;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) CCTaskObject *taskObject;
@property (nonatomic) NSInteger indexPathRow;

@end
