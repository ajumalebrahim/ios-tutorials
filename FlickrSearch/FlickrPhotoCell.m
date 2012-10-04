//
//  FlickrPhotoCell.m
//  FlickrSearch
//
//  Created by Rob Eberhardt on 10/3/12.
//  Copyright (c) 2012 Rob Eberhardt. All rights reserved.
//

#import "FlickrPhotoCell.h"
#import "FlickrPhoto.h"

@implementation FlickrPhotoCell

- (id)initWithFrame:(CGRect)frame
{
	NSLog(@"%@", @"blarg");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setPhoto:(FlickrPhoto *)photo {
	if (_photo != photo) {
		_photo = photo;
	}
	self.imageView.image = _photo.thumbnail;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
