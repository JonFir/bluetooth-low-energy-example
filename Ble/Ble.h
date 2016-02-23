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

- (void)addNewDevice:(CBPeripheral*)device RSSI:(NSNumber *)RSSI serviceCount:(NSNumber*)serviceCount;
- (void)deviceDiconnected;

@end


@protocol DeviceDelegate <NSObject>

- (void)addServices:(NSArray*)newServices;

@end

@protocol DeviceCharacteristicDelegate <NSObject>

- (void)addCharacteristics:(NSArray*)newCharacteristic;

@end

@protocol CharacteristicDelegate <NSObject>

- (void)updateValue:(NSData*)newValue forCharacteristic:(CBCharacteristic*)forCharacteristic;

@end

@interface Ble : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>{
    CBCentralManager *bleManager;
    AMSmoothAlertView * alertView;
    NSArray* serviceUUIDs;
}

@property (weak, nonatomic) id<DeviceListDelegate> deviceListDelegate;
@property (weak, nonatomic) id<DeviceDelegate> deviceDelegate;
@property (weak, nonatomic) id<DeviceCharacteristicDelegate> deviceCharacteristicDelegate;
@property (weak, nonatomic) id<CharacteristicDelegate> characteristicDelegate;

+ (id)sharedManager;
- (void) startScan;
- (void) stopScan;
- (void) connectPeripheral:(CBPeripheral*)device;
- (void) disconnectPeripheral:(CBPeripheral*)device;
- (void) findCharacteristics:(CBService *)service device:(CBPeripheral *)device;
- (void) readCharacteristic:(CBCharacteristic *)characteristic device:(CBPeripheral *)device;
- (void) showNotifiaction:(NSString*)name;

@end
