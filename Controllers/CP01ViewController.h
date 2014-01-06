//
//  CP01ViewController.h
//  FaceBookNav2
//
//  Created by Hao Zheng on 4/1/13.
//  Copyright (c) 2013 Hao Zheng. All rights reserved.
//
//hao
#import <UIKit/UIKit.h>
#import "AFPickerView.h"
#import "AUIAnimatableLabel.h"
#import "JDFlipNumberView.h"
@interface CP01ViewController : UIViewController <AFPickerViewDataSource, AFPickerViewDelegate>
{
    AFPickerView *defaultPickerView;
    AFPickerView *daysPickerView;
    NSMutableArray *daysData;
    NSMutableArray *daysDataIntValue;
    
}
@property (nonatomic) NSInteger ToCP02choseDate;
@property (strong, nonatomic) IBOutlet AUIAnimatableLabel *DisplayLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *NextBtn;


//flip number property
@property (strong, nonatomic) IBOutlet JDFlipNumberView *flipView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;


- (IBAction)DismissCP01:(id)sender;
@end
