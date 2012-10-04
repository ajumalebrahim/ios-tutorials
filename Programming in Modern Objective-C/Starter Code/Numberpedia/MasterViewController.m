#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MasterViewController 
{
	// Private instance variables
	NSDictionary *namesDictionary;
	NSMutableDictionary *valuesDictionary;
	NSArray *sortedSectionNames;
	
	// For the "sorted by value" screen
	BOOL sortedByName;
	NSArray *sortedNames;
	NSArray *sortedValues;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSArray *physicsNames = [NSArray arrayWithObjects:
			@"Avogadro",
			@"Boltzman",
			@"Planck",
			@"Rydberg",
			nil];

		NSArray *physicsValues = [NSArray arrayWithObjects:
			[NSNumber numberWithDouble:6.02214129e23],
			[NSNumber numberWithDouble:1.3806503e-23],
			[NSNumber numberWithDouble:6.626068e-34],
			[NSNumber numberWithDouble:1.097373e-7],
			nil];

		NSArray *mathematicsNames = [NSArray arrayWithObjects:
			@"e",
			@"Pi (π)",
			@"Pythagoras’ constant",
			@"Tau (τ)",
			nil];

		NSArray *mathematicsValues = [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:2.71828183],
			[NSNumber numberWithFloat:3.14159265],
			[NSNumber numberWithFloat:1.414213562],
			[NSNumber numberWithFloat:6.2831853],
			nil];

		NSArray *funNames = [NSArray arrayWithObjects:
			@"Absolute Zero",
			@"Beverly Hills",
			@"Golden Ratio",
			@"Number of Human Bones",
			@"Unlucky Number",
			nil];

		NSArray *funValues = [NSArray arrayWithObjects:
			[NSNumber numberWithFloat:-273.15],
			[NSNumber numberWithInt:90210],
			[NSNumber numberWithFloat:1.618],
			[NSNumber numberWithInt:214],
			[NSNumber numberWithInt:13],
			nil];

		namesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
			physicsNames, @"Physics Constants",
			mathematicsNames, @"Mathematics",
			funNames, @"Fun Numbers",
			nil];

		valuesDictionary = [[NSDictionary dictionaryWithObjectsAndKeys:
			physicsValues, @"Physics Constants",
			mathematicsValues, @"Mathematics",
			funValues, @"Fun Numbers",
			nil] mutableCopy];

		sortedSectionNames = [[namesDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];

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
		sortedNames = nil;
		sortedValues = nil;
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
				NSMutableArray *valuesArray = [[valuesDictionary objectForKey:controller.sectionName] mutableCopy];
				[valuesArray replaceObjectAtIndex:controller.indexInSection withObject:controller.value];
				[valuesDictionary setObject:valuesArray forKey:controller.sectionName];
				
				// This will cause the table of values to be // resorted if necessary.
				sortedNames = nil;
				[self updateTableContents];
			}
			
			[self dismissViewControllerAnimated:YES completion:nil];
		};
		
		UITableViewCell *cell = sender;
			
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

		if (sortedByName)
		{
			NSString *sectionName = [sortedSectionNames objectAtIndex:indexPath.section];
			controller.sectionName = sectionName;
			controller.indexInSection = indexPath.row;

			NSArray *namesArray = [namesDictionary objectForKey:sectionName];
			controller.name = [namesArray objectAtIndex:indexPath.row];

			NSArray *valuesArray = [valuesDictionary objectForKey:sectionName];
			controller.value = [valuesArray objectAtIndex:indexPath.row];
		}
		else
		{
			NSString *name = [sortedNames objectAtIndex:indexPath.row];
			controller.name = name;

			NSNumber *value = [sortedValues objectAtIndex:indexPath.row];
			controller.value = value;

			// For the "Sorted by Value" list we have to look up in which
			// section the name and value belong, and what their index is
			// in the array.

			for (NSString *sectionName in namesDictionary)
			{
				NSArray *array = [namesDictionary objectForKey:sectionName];
				NSInteger index = [array indexOfObject:name];
				if (index != NSNotFound)
				{
					controller.sectionName = sectionName;
					controller.indexInSection = index;
					break;
				}
			}
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
	if (!sortedByName && sortedNames == nil)
	{
		[self sortByValue];
	}

	[self.tableView reloadData];
}

- (void)sortByValue
{

	// First put all the values into one big array.
	NSMutableArray *allValues = [NSMutableArray arrayWithCapacity:50];
	for (NSString *key in valuesDictionary)
	{
		NSArray *array = [valuesDictionary objectForKey:key];
		[allValues addObjectsFromArray:array];
	}

	// Also put all the names into a big array. The order of the names
	// in this array corresponds to the order of values in "allValues".
	NSMutableArray *allNames = [NSMutableArray arrayWithCapacity:50];
	for (NSString *key in namesDictionary)
	{
		NSArray *array = [namesDictionary objectForKey:key];
		[allNames addObjectsFromArray:array];
	}

	// Sort the array of values.
	sortedValues = [allValues sortedArrayUsingSelector:@selector(compare:)];

	// We have to put the names in the same order as the sorted values.
	// For each sorted value, find its index in the un-sorted allValues
	// array, then use that index to find the name from allNames.
	NSMutableArray *theSortedNames = [NSMutableArray arrayWithCapacity:[sortedValues count]];
	for (NSNumber *number in sortedValues)
	{
		NSUInteger index = [allValues indexOfObject:number];
		[theSortedNames addObject:[allNames objectAtIndex:index]];
	}

	sortedNames = theSortedNames;
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
		return [sortedSectionNames objectAtIndex:section];
	else
		return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (sortedByName)
	{
		NSString *sectionName = [sortedSectionNames objectAtIndex:section];
		return [[namesDictionary objectForKey:sectionName] count];
	}
	else
	{
		return [sortedValues count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumberCell"];

	if (sortedByName)
	{
		NSString *sectionName = [sortedSectionNames objectAtIndex:indexPath.section];

		NSArray *namesArray = [namesDictionary objectForKey:sectionName];
		cell.textLabel.text = [namesArray objectAtIndex:indexPath.row];

		NSArray *valuesArray = [valuesDictionary objectForKey:sectionName];
		NSNumber *value = [valuesArray objectAtIndex:indexPath.row];
		cell.detailTextLabel.text = [value description];
	}
	else
	{
		cell.textLabel.text = [sortedNames objectAtIndex:indexPath.row];
		NSNumber *value = [sortedValues objectAtIndex:indexPath.row];
		cell.detailTextLabel.text = [value description];
	}

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
