


#import <Foundation/Foundation.h>
#import "NLImageShowcaseCellDelegate.h"
@interface NLImageShowCaseCell : UIView
{
    @private
    id<NLImageShowcaseCellDelegate> __unsafe_unretained _cellDelegate;
    UIImage* _image;
    NSInteger _Pid;
    UILabel* _labelTop;
    UIButton* _deleteButton;
    UIButton* _mainImage;
    UIButton* _bottomImage;
    NSTimer* _timer;
    NSInteger _index;
    BOOL _deleteMode;
}
@property (nonatomic, readonly) UIImage* image;
@property (nonatomic, unsafe_unretained) id<NLImageShowcaseCellDelegate> cellDelegate;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, readwrite) BOOL deleteMode;
- (id)initWithImage:(UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate;
- (id)setMainImage:(UIImage*)image andPid:(NSInteger) Pid andCreateDate:(NSInteger) CreateDate
;
- (IBAction)buttonClicked;
- (IBAction) deleteImage;
- (IBAction)touchCancel;
- (IBAction)touchDown;
- (IBAction)imagePushedLonger;
- (NSInteger)getInfo;
@end
