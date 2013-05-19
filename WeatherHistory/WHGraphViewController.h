//
//  WHGraphViewController.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import "ControlChart.h"

@interface WHGraphViewController : UIViewController
{
@private
    IBOutlet UIView *hostingView;
	ControlChart *detailItem;
}

@end
