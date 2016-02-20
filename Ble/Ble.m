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
        
        bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}




#pragma mark CBCentralManagerDelegate Methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            [self showBleAllert:@"Bluetooth off. \n Please turn on bluetooth!"];
            break;
        case CBCentralManagerStatePoweredOn:
            [self hideBleAllert];
            break;
        case CBCentralManagerStateResetting:
            [self showBleAllert:@"The connection with the system service was momentarily lost. An update is imminent."];
            break;
        default:
            [self showBleAllert:@"Sorry! You device not supported for use this app."];
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
        [[self deviceListDelegate] addNewDevice:peripheral RSSI:RSSI];
    }
    
    
}

-(void)showBleAllert: (NSString *) message{
    alertView = [[AMSmoothAlertView alloc] initFadeAlertWithTitle:@"Error!" andText:message andCancelButton:NO forAlertType:AlertFailure];
    [alertView show];
}

-(void)hideBleAllert{
    [alertView dismissAlertView];
}

#pragma mark CBCentralManager Methods

-(void)connectPeripheral:(CBPeripheral*)device{
    [bleManager connectPeripheral:device options:nil];
}

-(void)disconnectPeripheral:(CBPeripheral *)device{
    [bleManager cancelPeripheralConnection:device];
}

-(void)startScan{
    
    NSLog(@"start");

//
    NSArray* serviceUUIDs = @[
                              [CBUUID UUIDWithString:@"1811"],
                              [CBUUID UUIDWithString:@"180F"],
                              [CBUUID UUIDWithString:@"1810"],
                              [CBUUID UUIDWithString:@"181B"],
                              [CBUUID UUIDWithString:@"1805"],
                              [CBUUID UUIDWithString:@"1818"],
                              [CBUUID UUIDWithString:@"1812"],
                              [CBUUID UUIDWithString:@"1810"],
                              [CBUUID UUIDWithString:@"1823"],
                              [CBUUID UUIDWithString:@"180D"]
                              ];
    [bleManager scanForPeripheralsWithServices:serviceUUIDs options:nil];
}

-(void)stopScan{
    [bleManager stopScan];
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
