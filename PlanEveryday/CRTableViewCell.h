//
//  CRTableViewCell.h
//  CRMultiRowSelector
//
//  Created by Christian Roman on 6/17/12.
//  Copyright (c) 2012 chroman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabeltop;

@property (nonatomic, strong) UILabel *detailLabelbottom;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UIImage *renderedMark;

@end