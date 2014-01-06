

#import <UIKit/UIKit.h>


@interface DDAlertPrompt : UIAlertView <UITableViewDelegate, UITableViewDataSource> {
	@private
	UITableView *tableView_;
	UITextField *plainTextField_;
	UITextField *secretTextField_;
}

@property(nonatomic, retain, readonly) UITextField *plainTextField;
@property(nonatomic, retain, readonly) UITextField *secretTextField;

@property (nonatomic, strong) NSString *CategoryName;
@property (nonatomic) NSInteger indexInMutableArray;


- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles andCategoryName:(NSString *) name andindexInArray:(NSInteger) index;

@end
