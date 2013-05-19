//
//  WHGraphViewController.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHGraphViewController.h"

@implementation WHGraphViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	detailItem = [[ControlChart alloc] init];
	[detailItem renderInView:hostingView withTheme:[self currentTheme] animated:YES];
	UIBarButtonItem *buttonGraph = [[UIBarButtonItem alloc] initWithTitle:@"Graph" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
	UIBarButtonItem *buttonPie = [[UIBarButtonItem alloc] initWithTitle:@"Pie" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];
	UIBarButtonItem *buttonColumn = [[UIBarButtonItem alloc] initWithTitle:@"Column" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction:)];

	[self.navigationItem setRightBarButtonItems:@[buttonGraph, buttonPie, buttonColumn]];
}

-(void)dealloc
{
    [detailItem release];
    [hostingView release];
	
    [super dealloc];
}

- (void)barButtonAction:(UIBarButtonItem *)button
{
	
}

#pragma mark -
#pragma mark Rotation support

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ) 
	{
        hostingView.frame = self.view.bounds;
    }
	
    [detailItem renderInView:hostingView withTheme:[self currentTheme] animated:YES];
}

#pragma mark -
#pragma mark Theme Selection

-(CPTTheme *)currentTheme
{
    CPTTheme *theme = [[CPTTheme alloc] init];
	
    return theme;
}

@end
