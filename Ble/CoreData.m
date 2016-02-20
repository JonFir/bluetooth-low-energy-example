//
//  CoreData.m
//  Ble
//
//  Created by Елчев Евгений on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSDate*)saveDevice:(NSString*)name UUID:(NSString*)UUID date:(NSDate*)date{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    NSManagedObject * device = [self findDeviceAtName:name uuid:UUID];
    NSDate* prevDate = nil;
    if (!device){
        device = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        [device setValue:name forKey:@"name"];
        [device setValue:UUID forKey:@"uuid"];
    }else{
        prevDate = [device valueForKey:@"time"];
    }
    
    [device setValue:date forKey:@"time"];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    return prevDate;
}

-(NSArray*)loadDevices{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    
    return [managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

-(NSManagedObject*) findDeviceAtName:(NSString*)name uuid:(NSString*)uuid{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(name LIKE[c] %@) AND (uuid LIKE[c] %@)", name, uuid];
    [fetchRequest setPredicate:predicate];
    NSArray* findedDevice = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if (findedDevice.count > 0){
        return [findedDevice objectAtIndex:0];
    }else{
        return nil;
    }
}

@end
