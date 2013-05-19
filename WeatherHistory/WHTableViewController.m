//
//  WHTableViewController.m
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "WHTableViewController.h"
#import "WHGraphViewController.h"
#import "CacheManager.h"

#define kCellProverbsNameFont [UIFont boldSystemFontOfSize:17.0]
#define kCellProverbsDescriptionFont [UIFont systemFontOfSize:14.0]

@implementation WHTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:@"Weather"];
	
	_forecast = nil;
	_sections = [NSMutableArray new];
	_dataSourceProverbs	= [NSMutableArray new];
	
	_sectionHidden = [NSMutableArray new];
	for (int i = 0; i< 10; i++)
		[_sectionHidden addObject:[NSNumber numberWithBool:YES]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSString *str = [dateFormatter stringFromDate:[NSDate date]];
	
	_timeIntervalForDay = [[dateFormatter dateFromString:str] timeIntervalSince1970];
	
//	[_sections removeAllObjects];
	
	[_sections addObject:[NSNumber numberWithInteger:TableViewSectionDay]];
	
//	if ([[_forecast observations] count] >0)
	{
		[_sections addObject:[NSNumber numberWithInteger:TableViewSectionForecast]];
	}
	
//	if ([_dataSourceProverbs count] >0)
	{
		[_sections addObject:[NSNumber numberWithInteger:TableViewSectionProverbs]];
	}
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showHistory:)];
	[self.navigationItem setRightBarButtonItem:button];
	[button release];
	
	[self updateDataSource];
}

- (void)showHistory:(UIBarButtonItem *)button
{
	WHGraphViewController *viewControllerGraph = [[WHGraphViewController alloc] initWithNibName:@"WHGraphViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:viewControllerGraph animated:YES];
	[viewControllerGraph release];
}

- (void)updateDataSource
{
	[WHForecastModelController forecastForDate:_timeIntervalForDay localData:^(WHForecastDataObject *forecast){
		[self updateSectionForecast:forecast];
	}remouteData:^(WHForecastDataObject *forecast) {
		[self updateSectionForecast:forecast];
	}];
	
	[WHProverbsModelController proverbsForDate:_timeIntervalForDay localData:^(NSArray *array) {
		[self updateSectionProverbs:array];
	} remouteData:^(NSArray *array) {
		[self updateSectionProverbs:array];
	}];
}

- (void)updateSectionForecast:(WHForecastDataObject *)forecast
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (_forecast) [_forecast release];
		_forecast = [forecast retain];
		[self.tableView reloadData];
//        [self.tableView beginUpdates];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionForecast] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
	});
}

- (void)updateSectionProverbs:(NSArray *)proverbs
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[_dataSourceProverbs removeAllObjects];
		[_dataSourceProverbs addObjectsFromArray:proverbs];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionProverbs] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
	});
}

- (void)rotateArrowAtIndex:(int)index
{
    for (UIImageView *img in _arrowImagesArray) {
        if (img.tag == index) {
            if ([[_sectionHidden objectAtIndex:index] boolValue] == YES)
                img.transform = CGAffineTransformMakeRotation(0);
            else
                img.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    }
}

- (IBAction)buttonAction:(id)sender
{
	UIButton *button = (UIButton*)sender;

        int numberOfRowsToUpdate = [self tableView:self.tableView numberOfRowsInSection:button.tag];
        [_sectionHidden replaceObjectAtIndex:button.tag withObject:[NSNumber numberWithBool:![[_sectionHidden objectAtIndex:button.tag] boolValue]]];
        
        NSMutableArray *arrayTMP = [[NSMutableArray alloc] initWithCapacity:0];
		
        if (![[_sectionHidden objectAtIndex:button.tag] boolValue])
		{
            for (int i = 0; i<numberOfRowsToUpdate; i++)
                [arrayTMP addObject:[NSIndexPath indexPathForRow:i inSection:button.tag]];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:arrayTMP withRowAnimation:UITableViewRowAnimationTop];
			//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:[self numberOfSectionsInTableView:_tableView]-1], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        else
        {
            numberOfRowsToUpdate = [self tableView:self.tableView numberOfRowsInSection:button.tag];
            for (int i = 0; i<numberOfRowsToUpdate; i++)
                [arrayTMP addObject:[NSIndexPath indexPathForRow:i inSection:button.tag]];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arrayTMP withRowAnimation:UITableViewRowAnimationTop];
			//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:[self numberOfSectionsInTableView:_tableView]-1], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            
        }
        [self rotateArrowAtIndex:button.tag];
		
        [arrayTMP release];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if ([[_sections objectAtIndex:section] integerValue] == TableViewSectionForecast || [[_sections objectAtIndex:section] integerValue] == TableViewSectionProverbs)
	{
		return 35.0f;
	}
	
	return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if ([[_sections objectAtIndex:section] integerValue] == TableViewSectionForecast || [[_sections objectAtIndex:section] integerValue] == TableViewSectionProverbs)
	{
		UIView	*headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section])];
		
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AL_header_schet.png"]];
		CGRect frame = [backgroundImage frame];
		frame.origin.y -=1;
		[backgroundImage setFrame:frame];
        [headerView addSubview:backgroundImage];
        [backgroundImage release];
		
		UIButton *buttonHideSection = [UIButton buttonWithType:UIButtonTypeCustom];
		[buttonHideSection setFrame:backgroundImage.frame];
		[buttonHideSection setTag:section];
		[buttonHideSection addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
		[headerView addSubview:buttonHideSection];
		
        UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AL_arrow_open.png"]];
        arrowImg.center = CGPointMake(8, 18);
        [headerView addSubview:arrowImg];
        [arrowImg release];
		
        arrowImg.tag = section;
        if (!_arrowImagesArray) {
            _arrowImagesArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_arrowImagesArray addObject:arrowImg];
        
		if ([[_sectionHidden objectAtIndex:section] boolValue] == YES)
			arrowImg.transform = CGAffineTransformMakeRotation(0);
		else
			arrowImg.transform = CGAffineTransformMakeRotation(-M_PI_2);
		
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 300, 38)];
		[headerTitle setBackgroundColor:[UIColor clearColor]];
        headerTitle.text = [[self tableView:tableView titleForHeaderInSection:section] uppercaseString];
        [headerView addSubview:headerTitle];
        [headerTitle release];
        
		return [headerView autorelease];
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = 0;
	NSInteger sectionType = [[_sections objectAtIndex:section] integerValue];
	switch (sectionType)
	{
		case TableViewSectionDay:
			result = 1;
			break;
		case TableViewSectionForecast:
			if ([[_sectionHidden objectAtIndex:section] boolValue])
				result = [[_forecast observations] count];
			break;
		case TableViewSectionProverbs:
			if ([[_sectionHidden objectAtIndex:section] boolValue])
				result = [_dataSourceProverbs count];
			break;
		default:
			break;
	}
	
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger result = 0;
	NSInteger sectionType = [[_sections objectAtIndex:indexPath.section] integerValue];
	switch (sectionType)
	{
		case TableViewSectionDay:
			result = 44.0f;
			break;
		case TableViewSectionForecast:
			{
				//WHForecastDataObject *forecastObject = [_dataSourceForecast objectAtIndex:indexPath.row];
				result = 44.0f;
			}
			break;
		case TableViewSectionProverbs:
			{
				WHProverbsDataObject *proverbsObject = [_dataSourceProverbs objectAtIndex:indexPath.row];
				CGSize sizeName = [[proverbsObject name] sizeWithFont:kCellProverbsNameFont constrainedToSize:CGSizeMake(280.0, 1000)];
				CGSize sizeDescription = [[proverbsObject description] sizeWithFont:kCellProverbsDescriptionFont constrainedToSize:CGSizeMake(280.0, 1000)];
				result += sizeName.height;
				result += sizeDescription.height;
				result += 26;
			}
			break;
		default:
			break;
	}
	
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"Cell_Day";
	
    UITableViewCell *cell = nil;// [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSInteger sectionType = [[_sections objectAtIndex:indexPath.section] integerValue];
	switch (sectionType)
	{
		case TableViewSectionDay:
			{
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) 
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
					[cell.contentView addSubview:_scrollViewDays];
					[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
				}
				if (_forecast)
				{
					[cell.textLabel setText:[_forecast dateAsSring]];
				}
			}
			break;
		case TableViewSectionForecast:
			{
				CellIdentifier = @"Cell_Forecast";
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				
				if (cell == nil) 
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
					[cell setBackgroundView:nil];
					[cell.textLabel setBackgroundColor:[UIColor clearColor]];
					[cell.textLabel setNumberOfLines:0];
					[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
					[cell.detailTextLabel setNumberOfLines:0];
				}
				WHForecastTemp  *forecastTemp = [[_forecast observations] objectAtIndex:indexPath.row];
				[cell.imageView setImage:[CacheManager image:[NSString stringWithFormat:@"@%",[forecastTemp ]] success:<#^(UIImage *img)success#> failure:<#^(NSError *error)failure#>]];
				//http://icons.wxug.com/i/c/a/partlycloudy.gif

				[cell.textLabel setText:[forecastTemp temp]];
				[cell.detailTextLabel setText:[forecastTemp time]];
				//[cell.contentView setBackgroundColor:[WHDataModel colorOfTemp:[[forecastTemp temp] floatValue]]];
			}
			break;
		case TableViewSectionProverbs:
			{
				CellIdentifier = @"Cell_Proverbs";
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) 
				{
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
					[cell.textLabel setBackgroundColor:[UIColor clearColor]];
					[cell.textLabel setNumberOfLines:0];
					[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
					[cell.detailTextLabel setNumberOfLines:0];
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
				}
				
				WHProverbsDataObject *proverbsObject = [_dataSourceProverbs objectAtIndex:indexPath.row];
				[cell.textLabel setText:[proverbsObject name]];
				[cell.detailTextLabel setText:[proverbsObject description]];
			}
			break;
		default:
			break;
	}
		
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *result = @"";
	NSInteger sectionType = [[_sections objectAtIndex:section] integerValue];
	switch (sectionType)
	{
		case TableViewSectionDay:
			result = @"day";
			break;
		case TableViewSectionForecast:
			result = @"Forecast";
			break;
		case TableViewSectionProverbs:
			result = @"Proverbs";
			break;
		default:
			break;
	}
	
    return result;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		UIActionSheet	*action = [[UIActionSheet alloc] initWithTitle:@"Select action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"True", @"False", @"Notification", nil];
		[action showInView:self.view];
		[action release];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"Change status";
}

@end
