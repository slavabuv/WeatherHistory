//
//  WHTableViewController.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHForecastModelController.h"
#import "WHProverbsModelController.h"

typedef enum
{
	TableViewSectionDay = 0,
	TableViewSectionForecast,
	TableViewSectionProverbs
} TableViewSection;

@interface WHTableViewController : UITableViewController <UIActionSheetDelegate>
{
	UIScrollView			*_scrollViewDays;
	NSMutableArray			*_sections;
	NSMutableArray			*_sectionHidden;
	WHForecastDataObject	*_forecast;
	NSMutableArray			*_dataSourceProverbs;
	NSTimeInterval			_timeIntervalForDay;

	NSMutableArray          *_arrowImagesArray;
}

@end
