


#import <UIKit/UIKit.h>

@interface NLImageViewer : UIView
{
    UIImageView* _imageView;
    UIImage* _image;
    float _scalingFactor;
}
@property (nonatomic, retain) UIImage* image;

@end
