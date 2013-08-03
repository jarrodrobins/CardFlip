//
//  FlipContainerView.h
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipContainerDelegate <NSObject>

- (void)showFront;
- (void)showBack;
- (void)didShowFront;
- (void)didShowBack;

@end

@interface FlipContainerView : UIView

@property (nonatomic, unsafe_unretained) IBOutlet id<FlipContainerDelegate> delegate;

@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign, readonly, getter = isShowingBack) BOOL showingBack;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

- (void)flipToBack;
- (void)flipToFront;

@end
