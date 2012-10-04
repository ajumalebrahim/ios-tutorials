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
#import "FlickrPhotoCell.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, strong) NSMutableArray *searches;
@property (nonatomic, strong) Flickr *flickr;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

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
	
	[self.collectionView registerClass:[FlickrPhotoCell class] forCellWithReuseIdentifier:@"FlickrCell "];
	
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
				[self.collectionView reloadData];
			});
		} else {
			// 1
			NSLog(@"Error searching Flickr: %@", error.localizedDescription);
		}
	}];
	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - UICollectionView Datasource

	// 1
- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	NSString *searchTerm = self.searches[section];
	return [self.searchResults[searchTerm] count];
}

	// 2
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [self.searches count];
}

	// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    NSString *searchTerm = self.searches[indexPath.section];
	cell.photo = self.searchResults[searchTerm][indexPath.row];
    return cell;
}

	// 4
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//	return [[UICollectionReusableView alloc] init];
//}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
		// TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
		// TODO: Deselect Item
}

#pragma mark - UICollectionViewDelegateFlowLayout

	// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *searchTerm = self.searches[indexPath.section];
	FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
	
		// 2
	CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
	retval.height += 35;
	retval.width += 35;
	NSLog(@"%@", NSStringFromCGSize(retval));
	return retval;
}

	// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(50, 20, 50, 20);
}


@end
