//
//  Ble.h
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class AMSmoothAlertView;

@protocol DeviceListDelegate <NSObject>

- (void)addNewDevice:(CBPeripheral*)device RSSI:(NSNumber *)RSSI;

@end

@interface Ble : NSObject<CBCentralManagerDelegate>{
    CBCentralManager *bleManager;
    AMSmoothAlertView * alertView;
}

@property (weak, nonatomic) id<DeviceListDelegate> deviceListDelegate;

+ (id)sharedManager;
- (void) startScan;
- (void) stopScan;
- (void) connectPeripheral:(CBPeripheral*)device;
- (void) disconnectPeripheral:(CBPeripheral*)device;
- (void) showNotifiaction:(NSString*)name;

@end
