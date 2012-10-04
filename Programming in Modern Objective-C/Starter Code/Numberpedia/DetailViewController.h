@class DetailViewController;

typedef void (^DetailViewControllerCompletionBlock)(BOOL success);

@interface DetailViewController : UIViewController



@property (nonatomic, copy) DetailViewControllerCompletionBlock completionBlock;

@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, assign) NSUInteger indexInSection;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *value;

@end
