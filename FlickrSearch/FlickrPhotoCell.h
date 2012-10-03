//
//  FlickrPhotoCell.h
//  FlickrSearch
//
//  Created by Rob Eberhardt on 10/3/12.
//  Copyright (c) 2012 Rob Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;

@interface FlickrPhotoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) FlickrPhoto *photo;

@end
