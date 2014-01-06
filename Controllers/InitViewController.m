//
//  InitViewController.m
//  PlanEveryday
//
//  Created by Hao Zheng on 4/3/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//

#import "InitViewController.h"
#import "SQLHelper.h"
#import "OperationsWithDB.h"
#import "Event.h"
@interface InitViewController ()

@end

@implementation InitViewController

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
	
    //Select the Main view and can also help refreshing since in the Viewdidload it will load again
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Main View"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
