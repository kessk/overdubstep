//
//  CCEditTaskViewController.m
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import "CCEditTaskViewController.h"

@interface CCEditTaskViewController ()

@end

@implementation CCEditTaskViewController

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
	self.taskDescriptionTextView.delegate = self;
    self.taskNameTextField.delegate = self;
    
    self.taskNameTextField.text = self.taskObject.title;
    self.taskDescriptionTextView.text = self.taskObject.description;
    self.datePicker.date = self.taskObject.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    NSMutableArray *originalTaskArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ARRAY] mutableCopy];
    
//    CCTaskObject *newTaskObject = self.taskObject;
//    newTaskObject.title = self.taskNameTextField.text;
//    newTaskObject.description = self.taskDescriptionTextView.text;
//    newTaskObject.date = self.datePicker.date;
    self.taskObject.title = self.taskNameTextField.text;
    self.taskObject.description = self.taskDescriptionTextView.text;
    self.taskObject.date = self.datePicker.date;
    NSDictionary *revisedTaskObjectDictionary = [self taskObjectAsAPropertyList:self.taskObject];

    NSLog(@"The indexpath row is %d", self.indexPathRow);
    [originalTaskArray removeObjectAtIndex:self.indexPathRow];
    [originalTaskArray insertObject:revisedTaskObjectDictionary atIndex:self.indexPathRow];
    [[NSUserDefaults standardUserDefaults] setObject:originalTaskArray forKey:TASK_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate saveButtonPressed];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CCTaskObject *)dictionaryAsTaskObject:(NSDictionary *)dictionary
{
    CCTaskObject *dictionaryAsTaskObject = [[CCTaskObject alloc]initWithData:dictionary];
    return dictionaryAsTaskObject;
}

-(NSDictionary *)taskObjectAsAPropertyList:(CCTaskObject *)taskObject {
    NSDictionary *taskObjectAsDictionary = @{TASK_TITLE: taskObject.title, TASK_DESCRIPTION: taskObject.description, TASK_DATE: taskObject.date, TASK_COMPLETION: [NSNumber numberWithBool:taskObject.completion]};
    return taskObjectAsDictionary;
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
