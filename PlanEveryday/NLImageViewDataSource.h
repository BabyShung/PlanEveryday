


#import <Foundation/Foundation.h>

@class NLImageShowCase;
@protocol NLImageViewDataSource <NSObject>

- (CGSize)imageViewSizeInShowcase:(NLImageShowCase *) imageShowCase;
- (CGFloat)imageLeftOffsetInShowcase:(NLImageShowCase *) imageShowCase;
- (CGFloat)imageTopOffsetInShowcase:(NLImageShowCase *) imageShowCase;
- (CGFloat)rowSpacingInShowcase:(NLImageShowCase *) imageShowCase;
- (CGFloat)columnSpacingInShowcase:(NLImageShowCase *) imageShowCase;
- (void)imageClicked:(NLImageShowCase *)imageShowCase imageShowCaseCell:(NLImageShowCaseCell*)imageShowCaseCell;
- (void)imageTouchLonger:(NLImageShowCase *)imageShowCase imageIndex:(NSInteger)index;
@end
