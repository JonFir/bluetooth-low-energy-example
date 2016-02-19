//
//  DeviceListController.h
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ble.h"

@interface DeviceListController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DeviceListDelegate>{
    NSMutableArray* devices;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ScanIndicator;
@property (weak, nonatomic) IBOutlet UIButton *ScanButton;

- (void) startScan;
- (void) stopScan;

@end
