//
//  AppDelegate.h
//  TuiJi_T.B.E
//
//  Created by TUIJI on 16/5/30.
//  Copyright © 2016年 TUIJI. All rights reserved.
//


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@end

