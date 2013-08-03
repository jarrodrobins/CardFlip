//
//  HomeViewController.h
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipContainerView.h"

@interface HomeViewController : UIViewController<FlipContainerDelegate>

@property (nonatomic, weak) IBOutlet FlipContainerView *flipContainer;

@end
