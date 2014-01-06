


#import <Foundation/Foundation.h>
#import "NLImageShowCaseCell.h"

#import "NLImageViewDataSource.h"
#import "NLImageShowcaseCellDelegate.h"

@interface NLImageShowCase : UIView <NLImageShowcaseCellDelegate,UIGestureRecognizerDelegate>
{
    @private
    UIScrollView* _scrollView;
    NSMutableArray* itemsInShowCase;
    id<NLImageViewDataSource> __unsafe_unretained _dataSource;
    
    NSUInteger _itemsInRowCount;
    CGSize _cellSize;
    CGFloat _leftOffset;
    CGFloat _topOffset;
    CGFloat _rowSpacing;
    CGFloat _columnSpacing;
    
    BOOL _deleteMode;
    CGFloat _lastXPos;
    CGFloat _lastYPos;
    int lastIndex;
}

@property (nonatomic, readwrite) BOOL deleteMode;
- (bool)addImage: (UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate
;
- (id)setDataSource:(id<NLImageViewDataSource>)dataSource;
- (void)rearrageItems:(CGFloat)frameWidth fromIndex:(NSInteger) index;
- (void) viewClicked;

@end
