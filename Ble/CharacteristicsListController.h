//
//  CharacteristicsListController.h
//  Ble
//
//  Created by Евгений Елчев on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ble.h"

@interface CharacteristicsListController : UITableViewController<UITableViewDataSource, UITableViewDelegate, DeviceCharacteristicDelegate>{
     NSArray* characteristics;
}



@property (strong, nonatomic) CBPeripheral* device;
@property (strong, nonatomic) CBService* service;

@end
