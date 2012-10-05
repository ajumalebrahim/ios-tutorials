#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NSDictionary+RWFlatten.h"
#import "Item.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MasterViewController 
{
	// Private instance variables
	NSDictionary *dictionary;
	NSArray *sortedSectionNames;
	
	// For the "sorted by value" screen
	BOOL sortedByName;
	NSArray *sortedItems;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSArray *physics = @[
			[Item itemWithName:@"Avogadro" value:@6.02214129e23],
			[Item itemWithName:@"Boltzman" value:@1.3806503e-23],
			[Item itemWithName:@"Planck" value:@6.626068e-34],
			[Item itemWithName:@"Rydberg" value:@1.097373e-7]
		];
		
		NSArray *mathematics = @[
			[Item itemWithName:@"e" value:@2.71828183],
			[Item itemWithName:@"π" value:@3.14159265],
			[Item itemWithName:@"Pythagoras’ constant" value:@1.414213562],
			[Item itemWithName:@"Tau (τ)" value:@6.2831853]
		];
		
		NSArray *fun = @[
			[Item itemWithName:@"Absolute Zero" value:@-273.15],
			[Item itemWithName:@"Beverly Hills" value:@90210],
			[Item itemWithName:@"Golden Ratio" value:@1.618],
			[Item itemWithName:@"Number of Human Bones" value:@214],
			[Item itemWithName:@"Unlucky Number" value:@13]
		];
		
		dictionary = @{
			@"Physics Constants" : physics,
			@"Mathematics" : mathematics,
			@"Fun Numbers" : fun,
		};
		
		sortedSectionNames = [[dictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
		
		sortedByName = YES;
	}
	return self;
}

- (void)viewDidLoad
{
	NSLog(@"viewDidLoad");
	[super viewDidLoad];

	if (sortedByName)
		self.segmentedControl.selectedSegmentIndex = 0;
	else
		self.segmentedControl.selectedSegmentIndex = 1;

	[self updateTableContents];
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"didReceiveMemoryWarning");
	
	[super didReceiveMemoryWarning];
	
	if ([self isViewLoaded] && self.view.window == nil)
	{
		NSLog(@"will unload view");
		self.view = nil;
		sortedItems = nil;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowDetail"])
	{
		DetailViewController *controller = segue.destinationViewController;
		
		controller.completionBlock = ^(BOOL success)
		{
			if (success)
			{
				sortedItems = nil;
				[self updateTableContents];
			}
			[self dismissViewControllerAnimated:YES completion:nil];
		};
		
		UITableViewCell *cell = sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		
		if (sortedByName)
		{
			NSString *sectionName = sortedSectionNames[indexPath.section];
			NSArray *itemsArray = dictionary[sectionName];
			controller.itemToEdit = itemsArray[indexPath.row];
		} else {
			controller.itemToEdit = sortedItems[indexPath.row];
		}
	}
}

- (IBAction)sortChanged:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == 0)
		sortedByName = YES;
	else
		sortedByName = NO;

	[self updateTableContents];
}

#pragma mark - Application Logic

- (void)updateTableContents
{
	// Lazily sort the list by value if we haven't done that yet.
	if (!sortedByName && sortedItems == nil)
	{
		[self sortByValue];
	}

	[self.tableView reloadData];
}

- (void)sortByValue
{
	
	NSArray *allItems = [dictionary rw_flattenIntoArray];
	sortedItems = [allItems sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (sortedByName)
		return [sortedSectionNames count];
	else
		return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (sortedByName)
		return sortedSectionNames[section];
	else
		return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (sortedByName)
	{
		NSString *sectionName = sortedSectionNames[section];
		return [dictionary[sectionName] count];
	}
	else
	{
		return [sortedItems count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumberCell"];
	
	Item *item;

	if (sortedByName)
	{
		NSString *sectionName = sortedSectionNames[indexPath.section];

		NSArray *itemsArray = dictionary[sectionName];
		item = itemsArray[indexPath.row];
		
	} else {
		item = sortedItems[indexPath.row];
	}
		
	cell.textLabel.text = item.name;
	cell.detailTextLabel.text = [item.value description];

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
