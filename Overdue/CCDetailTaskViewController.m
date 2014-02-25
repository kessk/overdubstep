//
//  CCDetailTaskViewController.m
//  Overdue
//
//  Created by Kessler Koh on 2/13/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import "CCDetailTaskViewController.h"

@interface CCDetailTaskViewController ()

@end

@implementation CCDetailTaskViewController

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
	self.taskNameTextLabel.text = self.taskObject.title;
    self.taskDescriptionTextLabel.text = self.taskObject.description;
    NSDate *date = self.taskObject.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    self.dateLabel.text = dateString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toEditTaskVC" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CCEditTaskViewController class]]) {
        CCEditTaskViewController *editTaskVC = segue.destinationViewController;
        editTaskVC.taskObject = self.taskObject;
        editTaskVC.indexPathRow = self.indexPathRow;
        editTaskVC.delegate = self;
    }
}

- (void)saveButtonPressed
{
    [self viewDidLoad];
    [self.delegate updateTasks];
}
@end
