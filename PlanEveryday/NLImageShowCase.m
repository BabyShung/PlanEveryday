


#import "NLImageShowCase.h"
#import <QuartzCore/QuartzCore.h>

@implementation NLImageShowCase
@synthesize deleteMode = _deleteMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    itemsInShowCase = [[NSMutableArray alloc] init];
    lastIndex = -1;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[self frame]];
    [self addSubview:_scrollView];
        
    _scrollView.contentMode = (UIViewContentModeScaleAspectFit);
    _scrollView.contentSize =  CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    _scrollView.pagingEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight);
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1;
    _scrollView.clipsToBounds = YES;
    
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        // Ignore touch: As we do not want to handle gesture here, so pass it to NLImageShowCaseCell
        return NO;
    }
    return YES;
}

- (id)setDataSource:(id<NLImageViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _cellSize  = [_dataSource imageViewSizeInShowcase:self];
    _leftOffset = [_dataSource imageLeftOffsetInShowcase:self];
    _topOffset = [_dataSource imageTopOffsetInShowcase:self];
    _rowSpacing = [_dataSource rowSpacingInShowcase:self];
    _columnSpacing = [_dataSource columnSpacingInShowcase:self];
    _itemsInRowCount = (self.frame.size.width - _leftOffset + _columnSpacing) / (_cellSize.width + _columnSpacing);
//    NSLog(@"self.frame.size.width--- %f",self.frame.size.width);
//    NSLog(@"_leftOffset--- %f",_leftOffset);
//    NSLog(@"_columnSpacing--- %f",_columnSpacing);
//    NSLog(@"_cellSize.width --- %f",_cellSize.width );
//    NSLog(@"3--- %i",_itemsInRowCount);
    return self;
}

- (void)rearrageItems:(CGFloat)frameWidth fromIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.4 animations:
     ^{
         NLImageShowCaseCell* curCell = nil;
         NSInteger itemsCount = [itemsInShowCase count];
         int itr = index;
         for (; itr < itemsCount; itr++)
         {
             curCell = itemsInShowCase[itr];
             CGFloat newXPos = _leftOffset + (itr % _itemsInRowCount) * (_cellSize.width + _columnSpacing);
             CGFloat newYPos = _topOffset +  (itr / _itemsInRowCount) * (_cellSize.height + _rowSpacing);
             curCell.frame = CGRectMake(newXPos,newYPos,_cellSize.width,_cellSize.height);
         }
         if(itemsCount > 0)
         {
             curCell = itemsInShowCase[itemsCount-1 ];
             CGFloat scrollHeight = curCell.frame.origin.y + (_cellSize.height + _rowSpacing);
             _scrollView.contentSize =  CGSizeMake(frameWidth,scrollHeight);
         }
     }];
}

- (void) setFrame:(CGRect)frame
{
    // Call the parent class to move the view
    [super setFrame:frame];
    if(_dataSource == nil)
        _scrollView.contentSize =  CGSizeMake(frame.size.width,frame.size.height);
    else
    {
        _itemsInRowCount = (frame.size.width - _leftOffset + _columnSpacing) / (_cellSize.width + _columnSpacing);
        CGFloat frameWidth = frame.size.width;
        [self rearrageItems:frameWidth fromIndex:0];
    }
}

- (bool)addImage: (UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate
{
    NSUInteger itemCount = [itemsInShowCase count];
    NSLog(@"1--- %i",itemCount);
    NSLog(@"2--- %i",_itemsInRowCount);
    NSUInteger rowCount = itemCount/_itemsInRowCount;
    CGFloat xPos = _leftOffset + (itemCount % _itemsInRowCount) * (_cellSize.width + _columnSpacing);
    CGFloat yPos = _topOffset + rowCount * (_cellSize.height + _rowSpacing);
    
    NLImageShowCaseCell* showCaseCell = [[NLImageShowCaseCell alloc] initWithFrame:CGRectMake(xPos, yPos, _cellSize.width, _cellSize.height)];
    showCaseCell.cellDelegate = self;
    
    //hao modified
    [showCaseCell setMainImage:image andPid:Pid andCreateDate:CreateDate];
    
    showCaseCell.index = ++lastIndex;
    showCaseCell.deleteMode = _deleteMode;
    [itemsInShowCase addObject:showCaseCell];
    
    [_scrollView addSubview:showCaseCell];
    CGFloat contentHeight = yPos+_cellSize.height + _rowSpacing;
    if(contentHeight > _scrollView.contentSize.height)
    {
        _scrollView.contentSize =  CGSizeMake(self.bounds.size.width,contentHeight);
    }
    return true;
}

-(void) setDeleteMode:(BOOL)deleteMode
{
    _deleteMode = deleteMode;
    NSEnumerator *enumerator = [itemsInShowCase objectEnumerator];
    for (NLImageShowCaseCell *curItem in enumerator) {
        [curItem setDeleteMode:deleteMode];
    }
}

- (void) viewClicked
{
    if (_deleteMode) {
        [self setDeleteMode:false];
    }
}
- (void) deleteImage:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index
{
    NSLog(@"Deleting item with key: %d",index);
    NSInteger indexOfCell = [itemsInShowCase indexOfObject:imageShowCaseCell];
    [imageShowCaseCell removeFromSuperview];
    [itemsInShowCase removeObject:imageShowCaseCell ];
    [self rearrageItems:self.bounds.size.width fromIndex:indexOfCell];
}

- (void)imageClicked:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index
{
    [_dataSource imageClicked:self imageShowCaseCell:imageShowCaseCell];
}

- (void)imageTouchLonger:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index
{
    [_dataSource imageTouchLonger:self imageIndex:index];
    
}

@end
