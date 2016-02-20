//
//  CoreData.h
//  Ble
//
//  Created by Елчев Евгений on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

-(NSManagedObjectContext *)managedObjectContext;
-(NSDate*)saveDevice:(NSString*)name UUID:(NSString*)UUID date:(NSDate*)date;
-(NSArray*)loadDevices;
-(NSManagedObject*) findDeviceAtName:(NSString*)name uuid:(NSString*)uuid;
@end
