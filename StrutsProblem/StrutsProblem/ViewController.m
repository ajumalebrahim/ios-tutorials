//
//  ViewController.m
//  StrutsProblem
//
//  Created by Rob Eberhardt on 10/6/12.
//  Copyright (c) 2012 Rob Eberhardt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//	
//	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//	{
//		CGRect rect = self.topLeftView.frame;
//		rect.size.width = 210;
//		rect.size.height = 120;
//		self.topLeftView.frame = rect;
//		
//		rect = self.topRightView.frame;
//		rect.origin.x = 250;
//		rect.size.width = 210;
//		rect.size.height = 120;
//		self.topRightView.frame = rect;
//		
//		rect = self.bottomView.frame;
//		rect.origin.y = 160;
//		rect.size.width = 440;
//		rect.size.height = 120;
//		self.bottomView.frame = rect;
//	}
//	else
//	{
//		CGRect rect = self.topLeftView.frame;
//		rect.size.width = 130;
//		rect.size.height = 200;
//		self.topLeftView.frame = rect;
//		
//		rect = self.topRightView.frame;
//		rect.origin.x = 170;
//		rect.size.width = 130;
//		rect.size.height = 200;
//		
//		self.topRightView.frame = rect;
//		rect = self.bottomView.frame;
//		rect.origin.y = 240;
//		rect.size.width = 280;
//		rect.size.height = 200;
//		self.bottomView.frame = rect;
//	}
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
