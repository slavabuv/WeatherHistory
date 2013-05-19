//
//  WHAppDelegate.h
//  WeatherHistory
//
//  Created by Slava Budnikov on 18.05.13.
//  Copyright (c) 2013 Slava Budnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
