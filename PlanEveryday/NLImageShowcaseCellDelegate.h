


#import <Foundation/Foundation.h>
@class NLImageShowCaseCell;
@protocol NLImageShowcaseCellDelegate <NSObject>

- (void)imageClicked:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index;

- (void)imageTouchLonger:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index;

- (void) deleteImage:(NLImageShowCaseCell *)imageShowCaseCell imageIndex:(NSInteger)index;

@end
