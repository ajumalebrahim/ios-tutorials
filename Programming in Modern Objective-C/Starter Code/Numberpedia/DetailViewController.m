
#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationBar.topItem.title = self.name;
	self.textField.text = [self.value description];

	[self.textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
	if (self.completionBlock != nil)
		self.completionBlock(NO);
}

- (IBAction)done:(id)sender
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *newValue = [formatter numberFromString:self.textField.text];

	if (newValue != nil)
		self.value = newValue;
	else
		self.value = [NSNumber numberWithInt:0];

	if (self.completionBlock != nil)
		self.completionBlock(YES);
}

@end
