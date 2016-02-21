//
//  Ble.m
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "Ble.h"
#import "AMSmoothAlertView.h"
#import "CoreData.h"

@implementation Ble

@synthesize deviceListDelegate;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Ble *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerOptionShowPowerAlertKey];
        bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        
        //https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx
        serviceUUIDs =  @[
            [CBUUID UUIDWithString:@"1811"],
            [CBUUID UUIDWithString:@"1819"],
            [CBUUID UUIDWithString:@"180F"],
            [CBUUID UUIDWithString:@"1810"],
            [CBUUID UUIDWithString:@"181B"],
            [CBUUID UUIDWithString:@"1805"],
            [CBUUID UUIDWithString:@"1818"],
            [CBUUID UUIDWithString:@"1812"],
            [CBUUID UUIDWithString:@"1810"],
            [CBUUID UUIDWithString:@"1823"],
            [CBUUID UUIDWithString:@"180D"],
            [CBUUID UUIDWithString:@"FEE0"]
        ];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



-(void)startScan{
    [bleManager scanForPeripheralsWithServices:serviceUUIDs options:nil];
}

-(void)stopScan{
    [bleManager stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self showBleAllert:@"Bluetooth off. \n Please turn on bluetooth!" forAlertType:AlertFailure];
            break;
        case CBCentralManagerStatePoweredOn:
            [self hideBleAllert];
            break;
        case CBCentralManagerStateResetting:
            [self showBleAllert:@"The connection with the system service was momentarily lost. An update is imminent." forAlertType:AlertFailure];
            break;
        default:
            [self showBleAllert:@"Sorry! You device not supported for use this app." forAlertType:AlertFailure];
            break;
    }
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive){
        CoreData* coreData = [[CoreData alloc] init];
        NSDate* prevDate = [coreData saveDevice:peripheral.name UUID:peripheral.identifier.UUIDString date:[NSDate date]];
        if (prevDate) {
            NSTimeInterval interval = [prevDate timeIntervalSinceDate:[NSDate date]];
            if ((interval / 60) < 10){
                return;
            }
        }
        [self showNotifiaction:peripheral.name];
    }else{
        NSNumber *serviceCount = [NSNumber numberWithUnsignedLong:[[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"] count]];
        [[self deviceListDelegate] addNewDevice:peripheral RSSI:RSSI serviceCount:serviceCount];
    }
    
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [alertView dismissAlertView];
    [[self deviceListDelegate] deviceDiconnected];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disconnect" message:[NSString stringWithFormat:@"%@ did disconnect", peripheral.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [alertView dismissAlertView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail to connect" message:[NSString stringWithFormat:@"Fail connect to %@", peripheral.name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}




-(void)showBleAllert: (NSString *) message forAlertType:(AlertType) alertType {
    alertView = [[AMSmoothAlertView alloc] initFadeAlertWithTitle:@"Alert!" andText:message andCancelButton:NO forAlertType:alertType];
    [alertView show];
    
}

-(void)hideBleAllert{
    [alertView dismissAlertView];
}


-(void)connectPeripheral:(CBPeripheral*)device{
    [device setDelegate:self];
    [bleManager connectPeripheral:device options:nil];
    [self showBleAllert:@"Connecting to device. Please wait." forAlertType:AlertInfo];
}

-(void)disconnectPeripheral:(CBPeripheral *)device{
    [bleManager cancelPeripheralConnection:device];
}



-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [alertView dismissAlertView];
    [self.deviceDelegate addServices:peripheral.services];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    [[self deviceCharacteristicDelegate] addCharacteristics:service.characteristics];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%@", characteristic);
    NSLog(@"%@", error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [[self characteristicDelegate] updateValue:[characteristic value]];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"%@", characteristic);
    NSLog(@"%@", error);
}

-(void)findCharacteristics:(CBService *)service device:(CBPeripheral *)device {
    [device discoverCharacteristics:nil forService:service];
}

-(void)readCharacteristic:(CBCharacteristic *)characteristic device:(CBPeripheral *)device{
    [device readValueForCharacteristic:characteristic];
}




-(void)showNotifiaction:(NSString*)name{
    UIApplication*    application = [UIApplication sharedApplication];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    [notification setAlertBody:[NSString stringWithFormat:@"New Device Finded - %@",name]];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
}


@end
