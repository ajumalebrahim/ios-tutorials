//
//  ViewController.m
//  FlickrSearch
//
//  Created by Rob Eberhardt on 10/2/12.
//  Copyright (c) 2012 Rob Eberhardt. All rights reserved.
//

// flickr api key: d2ced3e2e77e852ba7b524d98af561fa
// flickr api secret: cb94b71d01ab2fbe

#import "ViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSMutableArray *searches;
@property (nonatomic, strong) Flickr *flickr;

- (IBAction)shareButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
	
	UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
	[self.toolbar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	
	UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
	[self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	UIImage *textFieldImage = [[UIImage imageNamed:@"search_field.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
	[self.textField setBackground:textFieldImage];
	
	self.searches = [@[] mutableCopy];
	self.searchResults = [@{} mutableCopy];
	self.flickr = [[Flickr alloc] init];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonTapped:(id)sender {
		// TODO
}

#pragma mark - UITextFieldDelegateMethods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	// 1
	[self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
		if (results && [results count] > 0)
		{
			//2
			if (![self.searches containsObject:searchTerm])
			{
				NSLog(@"Found %d photos matching %@",
					  [results count], searchTerm);
				[self.searches insertObject:searchTerm atIndex:0];
				self.searchResults[searchTerm] = results;
			}
			// 3
			dispatch_async(dispatch_get_main_queue(), ^{
				// Placeholder: reload collectionview data
			});
		} else {
			// 1
			NSLog(@"Error searching Flickr: %@", error.localizedDescription);
		}
	}];
	
	[textField resignFirstResponder];
	return YES;
}

@end
