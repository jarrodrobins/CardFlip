//
//  FlipContainerView.m
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import "FlipContainerView.h"
#import <QuartzCore/QuartzCore.h>

@interface FlipContainerView ()

@property (nonatomic, assign, readwrite, getter = isShowingBack) BOOL showingBack;

@property (nonatomic, assign, getter = isSwiping) BOOL swiping;
@property (nonatomic, assign, getter = isDragging) BOOL dragging;

@property (nonatomic, strong) UIView *frontContainerView;
@property (nonatomic, strong) UIView *backContainerView;

@property (nonatomic, strong) UIView *frontShadowView;
@property (nonatomic, strong) UIView *backShadowView;

@end

@implementation FlipContainerView

static const double VelocityAnimationSensitivityTrigger = 600.0f;

#pragma mark UIView

- (void)awakeFromNib {
	// if we don't do this, the view will become ugly and low res on non-retina displays once we start
	// flipping the view.
	self.layer.shouldRasterize = YES;
	self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
	// create the gesture recognizer.
	self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanContainer:)];
	[self addGestureRecognizer:self.panGestureRecognizer];
	
	// create the container views.
	self.frontContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.backContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	self.frontContainerView.backgroundColor = self.backContainerView.backgroundColor = [UIColor clearColor];
	
	[self addSubview:self.frontContainerView];
	[self addSubview:self.backContainerView];
	
	// now add the overlay views (the shadow which becomes visible as the containers rotate)
	self.frontShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.backShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	self.frontShadowView.backgroundColor = self.backShadowView.backgroundColor = [UIColor blackColor];
	self.frontShadowView.alpha = self.backShadowView.alpha = 0.0f;
	
	[self.frontContainerView addSubview:self.frontShadowView];
	[self.backContainerView addSubview:self.backShadowView];
	
	self.backContainerView.hidden = YES;
}

#pragma mark FlipContainerView - Overridden setters

- (void)setFrontView:(UIView *)frontView {
	if (self.frontView && self.frontView.superview) {
		// the user has added a front view before.
		[self.frontView removeFromSuperview];
	}
	_frontView = frontView;
	[self.frontContainerView addSubview:_frontView];
	
	[self.frontContainerView bringSubviewToFront:self.frontShadowView];
}

- (void)setBackView:(UIView *)backView {
	if (self.backView && self.backView.superview) {
		// the user has added a front view before.
		[self.backView removeFromSuperview];
	}
	_backView = backView;
	[self.backContainerView addSubview:_backView];
	
	[self.backContainerView bringSubviewToFront:self.backShadowView];
}

#pragma mark FlipContainerView

- (IBAction)didPanContainer:(UIPanGestureRecognizer *)recognizer {
	if (!self.isShowingBack) {
		CGPoint velocity = [recognizer velocityInView:self];
		
		if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
			// ensure nothing happens while we're swiping (since the animation is probably running).
			if (!self.swiping) {
				// are we showing the back side of the card already?
				if (!self.isShowingBack) {
					if (velocity.y > VelocityAnimationSensitivityTrigger) {
						// we're swiping fast enough to trigger the animation.
						self.showingBack = YES;
						self.dragging = NO;
						self.swiping = YES;
						
						[self flipToBack];
					} else {
						// we haven't triggered the swipe behaviour, just let the user play with
						// the view.
						self.dragging = YES;
						CGPoint translation = [recognizer translationInView:self];
						
						// rotation in radians.
						CGFloat rotation = translation.y / 2 * M_PI / 180;
						
						if (rotation >= M_PI / 3) {
							// the user has rotated the view far enough to trigger the animation.
							self.swiping = YES;
							self.showingBack = YES;
							self.dragging = NO;
							
							[self flipToBack];
						} else if (rotation > 0) {
							// let the user rotate the view back down towards 0; they must have moved it before.
							CATransform3D transform = CATransform3DIdentity;
							transform.m34 = 1.0 / 1000.0;

							transform = CATransform3DRotate(transform, rotation, 1.0f, 0.0f, 0.0f);
							
							self.frontContainerView.layer.transform = transform;
							self.frontShadowView.alpha = 0.3f * (rotation / M_PI_2);
							self.backContainerView.layer.transform = transform;
						}
					}
				}
			}
		} else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
			self.swiping = NO;
			
			if (self.isDragging) {
				// if the user was dragging the view (ie, playing with it)
				// we want to move it back to the default state.
				self.dragging = NO;
				
				CATransform3D transform = CATransform3DIdentity;
				transform.m34 = 1.0 / 1000.0;
				transform = CATransform3DRotate(transform, 0, 1.0f, 0.0f, 0.0f);
				
				[UIView animateWithDuration:0.5f animations:^{
					self.frontContainerView.layer.transform = transform;
					self.backContainerView.layer.transform = transform;
					
					self.frontShadowView.alpha = 0.0f;
					self.backShadowView.alpha = 0.3f;
				} completion:^(BOOL finished) {

				}];
			}
		}
	}
}

- (void)flipToBack {
	// this will cancel the gesture so the user can't keep screwing around with the card.
	self.panGestureRecognizer.enabled = NO;
	self.panGestureRecognizer.enabled = YES;
	
	CATransform3D initialTransform = CATransform3DIdentity;
	initialTransform.m34 = 1.0 / 1000.0;
	initialTransform = CATransform3DRotate(initialTransform, M_PI_2, 1.0f, 0.0f, 0.0f);
	
	CATransform3D secondTransform = CATransform3DIdentity;
	secondTransform.m34 = 1.0 / 1000.0;
	secondTransform = CATransform3DRotate(secondTransform, M_PI, 1.0f, 0.0f, 0.0f);
	secondTransform = CATransform3DScale(secondTransform, 1.2f, 2.5f, 1.5f);
	
	[UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.frontContainerView.layer.transform = initialTransform;
		self.frontShadowView.alpha = 0.3f;
		self.backContainerView.layer.transform = initialTransform;
	} completion:^(BOOL finished){
		if (finished) {
			self.frontContainerView.hidden = YES;
			self.backContainerView.hidden = NO;
			self.backShadowView.alpha = 0.3f;
			[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.frontContainerView.layer.transform = secondTransform;
				self.backContainerView.layer.transform = secondTransform;
				self.backShadowView.alpha = 0.0f;
			} completion:^(BOOL finished){
				self.dragging = self.swiping = NO;
				self.showingBack = YES;
				[self didShowBack];
			}];
		}
	}];

}

- (void)didShowBack {
	[self.delegate didShowBack];
}

- (void)flipToFront {
	CATransform3D initialTransform = CATransform3DIdentity;
	initialTransform.m34 = 1.0 / 1000.0;
	initialTransform = CATransform3DRotate(initialTransform, M_PI, 1.0f, 0.0f, 0.0f);
	initialTransform = CATransform3DScale(initialTransform, 1.2f, 2.5f, 1.5f);
	
	self.frontContainerView.layer.transform = initialTransform;
	self.backContainerView.layer.transform = initialTransform;
	
	CATransform3D firstTransform = CATransform3DIdentity;
	firstTransform.m34 = 1.0 / 1000.0;
	firstTransform = CATransform3DRotate(firstTransform, M_PI_2, 1.0f, 0.0f, 0.0f);
	firstTransform = CATransform3DScale(firstTransform, 1.0f, 1.0f, 1.0f);
	
	CATransform3D secondTransform = CATransform3DIdentity;
	secondTransform.m34 = 1.0 / 1000.0;
	secondTransform = CATransform3DRotate(secondTransform, 0, 1.0f, 0.0f, 0.0f);
	
	[UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.frontContainerView.layer.transform = firstTransform;
		self.backContainerView.layer.transform = firstTransform;
		self.backShadowView.alpha = 0.0f;
	} completion:^(BOOL finished){
		if (finished) {
			self.frontContainerView.hidden = NO;
			self.backContainerView.hidden = YES;
			
			// this will prevent nasty artefacting.
			[self.backContainerView setNeedsDisplay];
			
			self.frontShadowView.alpha = 0.3f;
			[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.frontContainerView.layer.transform = secondTransform;
				self.backContainerView.layer.transform = secondTransform;
				self.frontShadowView.alpha = 0.0f;
			} completion:^(BOOL finished) {
				self.backContainerView.hidden = YES;
				
				self.dragging = self.swiping = NO;
				self.showingBack = NO;
				[self didShowFront];
			}];
		}
	}];
}

- (void)didShowFront {
	[self.delegate didShowFront];
}

@end
