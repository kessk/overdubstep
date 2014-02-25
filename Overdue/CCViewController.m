//
//  CCViewController.m
//  Overdue
//
//  Created by Kessler Koh on 2/11/14.
//  Copyright (c) 2014 Bentee. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

-(NSMutableArray *)taskObjects
{
    if (!_taskObjects) {
        _taskObjects = [[NSMutableArray alloc]init];
    }
    return _taskObjects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *tasksArray = [[NSUserDefaults standardUserDefaults] objectForKey:TASK_ARRAY];
    for (NSDictionary *dictionary in tasksArray) {
        [self.taskObjects addObject:[self dictionaryAsTaskObject:dictionary]];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(CCTaskObject *)dictionaryAsTaskObject:(NSDictionary *)dictionary
{
    CCTaskObject *dictionaryAsTaskObject = [[CCTaskObject alloc]initWithData:dictionary];
    return dictionaryAsTaskObject;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTaskButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskVC" sender:sender];
}

- (IBAction)reorderButtonPressed:(UIBarButtonItem *)sender {
    if (self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - reordering delegate methods

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    CCTaskObject *task1 = [self.taskObjects objectAtIndex:sourceIndexPath.row];
//    CCTaskObject *task2 = [self.taskObjects objectAtIndex:destinationIndexPath.row];
    
//    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
//    [self.taskObjects insertObject:task2 atIndex:sourceIndexPath.row];
//    
//    [self.taskObjects removeObjectAtIndex:destinationIndexPath.row];
//    [self.taskObjects insertObject:task1 atIndex:destinationIndexPath.row];
    
    for (NSInteger i = sourceIndexPath.row; i <= destinationIndexPath.row; i++) {
        if (i != destinationIndexPath.row) {
            [self.taskObjects replaceObjectAtIndex:i withObject:[self.taskObjects objectAtIndex:i+1]];
        } else {
            [self.taskObjects replaceObjectAtIndex:i withObject:task1];
        }
        
    }
    
//    [self.taskObjects replaceObjectAtIndex:sourceIndexPath.row withObject:task2];
//    [self.taskObjects replaceObjectAtIndex:destinationIndexPath.row withObject:task1];
    
    
    NSMutableArray *replacementUserDefaultsArray = [[NSMutableArray alloc] init];
    for (CCTaskObject *tempObject in self.taskObjects) {
        [replacementUserDefaultsArray addObject:[self taskObjectAsAPropertyList:tempObject]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:replacementUserDefaultsArray forKey:TASK_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CCAddTaskViewController class]])
    {
        CCAddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    } else if ([segue.destinationViewController isKindOfClass:[CCDetailTaskViewController class]])
    {
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *path = sender;
            CCDetailTaskViewController *detailTaskVC = segue.destinationViewController;
            detailTaskVC.taskObject = [self.taskObjects objectAtIndex:path.row];
            detailTaskVC.indexPathRow = path.row;
            detailTaskVC.delegate = self;
        }
        
    }
}

#pragma mark - AddTaskVC Delegate Methods

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(CCTaskObject *)task
{
    [self.taskObjects addObject:task];
    
    NSMutableArray *taskArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ARRAY] mutableCopy];
    if (!taskArray) {
        taskArray = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *newTaskObject = [self taskObjectAsAPropertyList:task];
    //[self.taskObjects addObject:newTaskObject];
    [taskArray addObject:newTaskObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:taskArray forKey:TASK_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

-(NSDictionary *)taskObjectAsAPropertyList:(CCTaskObject *)taskObject {
    NSDictionary *taskObjectAsDictionary = @{TASK_TITLE: taskObject.title, TASK_DESCRIPTION: taskObject.description, TASK_DATE: taskObject.date, TASK_COMPLETION: [NSNumber numberWithBool:taskObject.completion]};
    return taskObjectAsDictionary;
}

#pragma mark - UITableViewDataSource delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%d", self.taskObjects.count);
    return [self.taskObjects count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //NSLog(@"I am here in cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //NSLog(@"indexPath.row value: %d", indexPath.row);
    CCTaskObject *tempTaskObject = [self.taskObjects objectAtIndex:indexPath.row];
    NSDictionary *tempDictionary = [self taskObjectAsAPropertyList:tempTaskObject];
    
        //NSLog(@"%@", tempDictionary);
    
    NSDate *tempDate = tempDictionary[TASK_DATE];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:tempDate];
    
    cell.textLabel.text = tempDictionary[TASK_TITLE];
    cell.detailTextLabel.text = stringFromDate;
    
    if (tempTaskObject.completion == YES) {
        cell.backgroundColor = [UIColor greenColor];
    } else if ([self isDateGreaterThanDate:tempDate and:[NSDate date]])
    {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTaskObject *selectedTaskObject = [self.taskObjects objectAtIndex:indexPath.row];
    if (selectedTaskObject.completion == NO) {
        selectedTaskObject.completion = YES;
    } else selectedTaskObject.completion = NO;

    [self.taskObjects replaceObjectAtIndex:indexPath.row withObject:selectedTaskObject];
    [self updateCompletionOfTask:selectedTaskObject forIndexPath:indexPath];
    [self.tableView reloadData];
}

-(void)updateCompletionOfTask:(CCTaskObject *)task forIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ARRAY]mutableCopy];
    CCTaskObject *tempTaskObject = [self dictionaryAsTaskObject:[tempArray objectAtIndex:indexPath.row]];
    
    if (task.completion == NO) {
        tempTaskObject.completion = NO;
        NSLog(@"Object at indexPath row %d is NO", indexPath.row);
    } else {
        tempTaskObject.completion = YES;
        NSLog(@"Object at indexPath row %d is YES", indexPath.row);
    }
    
    [tempArray replaceObjectAtIndex:indexPath.row withObject:[self taskObjectAsAPropertyList:tempTaskObject]];
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:TASK_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isDateGreaterThanDate:(NSDate*)date and:(NSDate*)toDate
{
    //if first is greater than the second
    int fromDateInt = [date timeIntervalSince1970];
    int toDateInt = [toDate timeIntervalSince1970];
    if (fromDateInt > toDateInt) {
        return YES;
    } else return NO;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *tempArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TASK_ARRAY] mutableCopy];
        [tempArray removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *revisedArray = [[NSMutableArray alloc] init];
        for (NSMutableArray *array in tempArray) {
            [revisedArray addObject:array];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:revisedArray forKey:TASK_ARRAY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskVC" sender:indexPath];
}

- (void)updateTasks
{
    [self.tableView reloadData];
}

@end
