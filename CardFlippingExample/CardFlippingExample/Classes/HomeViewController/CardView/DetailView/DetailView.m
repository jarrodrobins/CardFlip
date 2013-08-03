//
//  DetailView.m
//  CardFlippingExample
//
//  Created by Jarrod Robins on 3/08/13.
//  Copyright (c) 2013 Jarrod Robins. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

#pragma mark UIView

- (void)awakeFromNib {
	// create the close button.
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Detail View"];
	UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton:)];
    [navigationItem setLeftBarButtonItem:closeBarButton];
	
    [self.navigationBar setItems:@[navigationItem]];
}

#pragma mark DetailView

- (IBAction)didPressCloseButton:(id)sender {
	[self.delegate showFront];
}

@end
