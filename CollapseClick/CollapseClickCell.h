//
//  CollapseClickCell.h
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClickArrow.h"
#import "CollapseClickAdd.h"
#define kCCHeaderHeight 50

@interface CollapseClickCell : UIView

// Header
@property (weak, nonatomic) IBOutlet UIView *TitleView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *TitleButton;
@property (weak, nonatomic) IBOutlet CollapseClickArrow *TitleArrow;
@property (weak, nonatomic) IBOutlet CollapseClickAdd  *TitleAdd;
// Body
@property (weak, nonatomic) IBOutlet UIView *ContentView;
@property (strong, nonatomic) IBOutlet UIButton *AddBtn;

// Properties
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) int index;

// Init
+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title index:(int)index content:(UIView *)content;

@end
