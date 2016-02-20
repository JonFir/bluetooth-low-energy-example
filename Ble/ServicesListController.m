//
//  ServicesListController.m
//  Ble
//
//  Created by Елчев Евгений on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "ServicesListController.h"

@implementation ServicesListController
@synthesize device;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self conectDevice];
}

- (void) conectDevice{
    [[Ble sharedManager] connectPeripheral:device];
    self.title = device.name;
    self.navigationItem.prompt = [NSString stringWithFormat:@"UUID %@", device.identifier.UUIDString];

}

- (void) disconectDevice{
    
}



@end
