//
//  ServicesListController.h
//  Ble
//
//  Created by Елчев Евгений on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ble.h"

@interface ServicesListController : UITableViewController<UITableViewDataSource, UITableViewDelegate, DeviceDelegate>{
    NSArray* services;
}

@property (strong, nonatomic) CBPeripheral* device;

- (void) conectDevice;
- (void) disconectDevice;


@end
