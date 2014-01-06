//
//  IZValueSelectorView.m
//  IZValueSelector
//
//  Created by Iman Zarrabian on 02/11/12.
//  Copyright (c) 2012 Iman Zarrabian. All rights reserved.
//

#import "IZValueSelectorView.h"
#import <QuartzCore/QuartzCore.h>


@implementation IZValueSelectorView {
    //UITableView *_contentTableView;
    CGRect _selectionRect;
}

@synthesize shouldBeTransparent = _shouldBeTransparent;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.horizontalScrolling = NO;
    }
    return self;
}

- (void)layoutSubviews {
    if (self.contentTableView == nil) {
        [self createContentTableView];
    }
    [super layoutSubviews];
}



- (void)createContentTableView {

    UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectorRect"]];
    
    _selectionRect = [self.dataSource rectForSelectionInSelector:self];
    selectionImageView.frame = _selectionRect;
    if (self.shouldBeTransparent) {
        selectionImageView.alpha = 0.5;
    }
    
    if (self.horizontalScrolling) { 
        //In this case user might have created a view larger than taller
        self.contentTableView  = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.width)];
    }
    else {
        self.contentTableView  = [[UITableView alloc] initWithFrame:self.bounds];
    }
    
    if (self.debugEnabled) {
        self.contentTableView .layer.borderColor = [UIColor blueColor].CGColor;
        self.contentTableView .layer.borderWidth = 1.0;
        self.contentTableView .layer.cornerRadius = 10.0;
        
        self.contentTableView .tableHeaderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentTableView .tableFooterView.layer.borderColor = [UIColor blackColor].CGColor;
    }

    //[self.contentTableView  setAllowsSelection:YES];
    
    // Initialization code
    CGFloat OffsetCreated;
    
    //If this is an horizontal scrolling we have to rotate the table view
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
        self.contentTableView .transform = rotateTable;
        
        OffsetCreated = self.contentTableView .frame.origin.x;
        self.contentTableView .frame = self.bounds;
    }

    self.contentTableView .backgroundColor = [UIColor clearColor];
    self.contentTableView .delegate = self;
    self.contentTableView .dataSource = self;
    self.contentTableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.horizontalScrolling) {
        self.contentTableView .rowHeight = [self.dataSource rowWidthInSelector:self];
    }
    else {
        self.contentTableView .rowHeight = [self.dataSource rowHeightInSelector:self];
    }
    
    if (self.horizontalScrolling)
    {
        self.contentTableView .contentInset = UIEdgeInsetsMake( _selectionRect.origin.x ,  0,self.contentTableView .frame.size.height - _selectionRect.origin.x - _selectionRect.size.width - 2*OffsetCreated, 0);
    }
    else {
        self.contentTableView .contentInset = UIEdgeInsetsMake( _selectionRect.origin.y, 0, self.contentTableView .frame.size.height - _selectionRect.origin.y - _selectionRect.size.height  , 0);
    }
    self.contentTableView .showsVerticalScrollIndicator = NO;
    self.contentTableView .showsHorizontalScrollIndicator = NO;

    [self addSubview:self.contentTableView ];
    [self addSubview:selectionImageView];
    
    [self.delegate passTableReference:self.contentTableView];
    
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.dataSource numberOfRowsInSelector:self];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *contentSubviews = [cell.contentView subviews];
    //We the content view already has a subview we just replace it, no need to add it again
    //hopefully ARC will do the rest and release the old retained view
    if ([contentSubviews count] >0 ) {
        UIView *contentSubV = [contentSubviews objectAtIndex:0];

        //This will release the previous contentSubV
        [contentSubV removeFromSuperview];
        
        UIView *viewToAdd = [self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        contentSubV = viewToAdd;
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:contentSubV];
    }
    else {
        
        UILabel *viewToAdd = (UILabel *)[self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        //This is a new cell so we just have to add the view        
        if (self.debugEnabled) {
            viewToAdd.layer.borderWidth = 1.0;
            viewToAdd.layer.borderColor = [UIColor redColor].CGColor;
        }
        [cell.contentView addSubview:viewToAdd];

    }
    
    if (self.debugEnabled) {
        cell.layer.borderColor = [UIColor greenColor].CGColor;
        cell.layer.borderWidth = 1.0;
    }
    
    if (self.horizontalScrolling) {
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = rotateTable;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (tableView == self.contentTableView ) {
 
        [self.contentTableView  scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:indexPath.row];
    }
    NSLog(@"selector will stay");
}

#pragma mark Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell {
    CGRect selectionRectConverted = [self convertRect:_selectionRect toView:self.contentTableView ];
    NSArray *indexPathArray = [self.contentTableView  indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0.0;
    NSIndexPath *selectedIndexPath = nil;
    
    for (NSIndexPath *index in indexPathArray) {
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [self.contentTableView  cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
      
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    if (selectedIndexPath!=nil) {
        //As soon as we elected an indexpath we just have to scroll to it
        [self.contentTableView  scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath.row];
    }
}



- (void)reloadData {
    [self.contentTableView reloadData];
}

@end
