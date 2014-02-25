//
//  CCAddTaskViewController.m
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import "CCAddTaskViewController.h"

@interface CCAddTaskViewController ()

@end

@implementation CCAddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.taskNameTextField.delegate = self;
    self.taskDescriptionTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTaskButtonPressed:(UIButton *)sender {
    //BOOL completion = NO;
    //NSDictionary *newTaskDictionary = @{TASK_TITLE: self.taskNameTextField.text, TASK_DESCRIPTION: self.taskDescriptionTextView.text, TASK_DATE: self.datePicker.date, TASK_COMPLETION: [NSNumber numberWithBool:completion]};
    //CCTaskObject *newTaskObject = [[CCTaskObject alloc] initWithData:newTaskDictionary];
    //[self.delegate didAddTask:newTaskObject];
    [self.delegate didAddTask:[self createdTaskObject]];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
}

-(CCTaskObject *)createdTaskObject {
    NSDate *date = self.datePicker.date;
    
    NSString *taskName = self.taskNameTextField.text;
    NSString *taskDescription = self.taskDescriptionTextView.text;
    
    NSDictionary *newTaskDictionary = @{TASK_TITLE: taskName, TASK_DESCRIPTION: taskDescription, TASK_DATE: date, TASK_COMPLETION: @NO};
    CCTaskObject *newTask = [[CCTaskObject alloc]initWithData:newTaskDictionary];
    
    return newTask;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
