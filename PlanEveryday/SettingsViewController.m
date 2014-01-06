//
//  SettingsViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 5/6/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "SettingsViewController.h"
//#import "SettingDetailViewController.h"


@interface SettingsViewController (){

    NSIndexPath* checkedIndexPath;
    SettingData* settings;
    NSInteger prindex;
    NSInteger colindex;
}
@property (strong, nonatomic) SettingData * settings;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end

@implementation SettingsViewController


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
	// Do any additional setup after loading the view.
    self.settingview.delegate = self;
    self.settingview.dataSource = self;
    //NSMutableArray *selectedCellPaths = [[NSMutableArray alloc] init];
    SettingData *settings = [[SettingData alloc] init];
    self.section1 = [NSArray arrayWithObjects:@"Trivia", @"Normal", @"Urgent", nil];
    self.section2 = [NSArray arrayWithObjects:@"Light Gray", @"Dark Gray", @"Blue", @"Green", nil];
    self.group = [NSArray arrayWithObjects:self.section1, self.section2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.group count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return [self.section1 count];
        
    } else if (section == 1) {
        
        return [self.section2 count];
    }
    else    //need modification
        return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Default Priority";
        
    } else if (section == 1) {
        
        return @"Theme Color";
    }
    else    //need modification
        return 0;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {   //section 1
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section1 objectAtIndex:indexPath.row]];
        
        
    } else if (indexPath.section == 1) {    //section 2
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.section2 objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //the height of every cell
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        if (indexPath.section == 0){
            prindex = indexPath.row;
            NSLog(@"%d", prindex);
        }else{
            colindex = indexPath.row;
            NSLog(@"%d", colindex);
        }
    }
    
   /*if(self.checkedIndexPath)
    {
        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:self.checkedIndexPath];
        
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }*/
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath = nil;
    }
    /*else
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedIndexPath = indexPath;
    }*/
    
    
    
}

/*- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
        if ( selectedIndexPath.section == indexPath.section )
            [tableView deselectRowAtIndexPath:selectedIndexPath animated:NO] ;
    }
    return indexPath ;
}*/

/*- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	SettingDetailViewController * childVC = segue.destinationViewController;
	NSInteger selectedCellNum = [self.settingview indexPathForSelectedRow].row;
	childVC.section = [self.settingData dataStringForIndex:selectedCellNum];
}*/

- (void)saveSelections: (SettingData *)settings{
    settings.pindex = prindex;
    settings.cindex = colindex;
    NSLog(@"%d",settings.pindex);
}

- (IBAction)DismissSettings:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //refresh main view
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainView" object:nil];
}

- (IBAction)DoneWithSetting:(id)sender {
    [self saveSelections:settings];
    //refresh table and reset the topview
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MainNC" object:nil];
    //dismiss the current presenting view
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
@end
