//
//  HomeViewController.m
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import "HomeViewController.h"
#import "CardFrontView.h"
#import "CardBackView.h"
#import "DetailView.h"

@interface HomeViewController ()

@property (nonatomic, strong) DetailView *detailView;

@end

@implementation HomeViewController

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// it's only set to a different colour in the XIB so we can easily see it.
	self.flipContainer.backgroundColor = [UIColor clearColor];
	
	// create our views for each side of the card.
	CardFrontView *cardFront = [[[NSBundle mainBundle] loadNibNamed:@"CardFrontView" owner:nil options:nil] objectAtIndex:0];
	CardBackView *cardBack = [[[NSBundle mainBundle] loadNibNamed:@"CardBackView" owner:nil options:nil] objectAtIndex:0];
	
	self.flipContainer.frontView = cardFront;
	self.flipContainer.backView = cardBack;
}

#pragma mark HomeViewController

- (DetailView *)detailView {
	if (!_detailView) {
		_detailView = [[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:nil options:nil] objectAtIndex:0];
		_detailView.delegate = self;
	}
	return _detailView;
}

#pragma mark FlipContainerDelegate

- (void)didShowFront {
	
}

- (void)didShowBack {
	if (!self.detailView.superview) {
		// don't do anything if the detail view already has a superview.
		self.detailView.alpha = 0.0f;
		
		[self.view addSubview:self.detailView];
		
		// animate in.
		[UIView animateWithDuration:0.3f animations:^{
			self.detailView.alpha = 1.0f;
		}];
	}
}

- (void)showFront {
	if (self.flipContainer.isShowingBack) {
		[UIView animateWithDuration:0.3f animations:^{
			self.detailView.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[self.detailView removeFromSuperview];
			[self.flipContainer flipToFront];
		}];
	}
}

- (void)showBack {
	if (!self.flipContainer.isShowingBack) {
		[self.flipContainer flipToBack];
	}
}

@end
