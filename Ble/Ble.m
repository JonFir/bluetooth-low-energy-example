//
//  Ble.m
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "Ble.h"
//#import "DeviceListController.h"
#import "AMSmoothAlertView.h"

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
        devices = [[NSMutableSet alloc ]init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void)startScan{
    [devices removeAllObjects];
    [bleManager scanForPeripheralsWithServices:nil options:nil];
}

-(void)stopScan{
    [bleManager stopScan];
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
    [[self deviceListDelegate] addNewDevice:peripheral];
}

-(void)showBleAllert: (NSString *) message{
    alertView = [[AMSmoothAlertView alloc] initFadeAlertWithTitle:@"Error!" andText:message andCancelButton:NO forAlertType:AlertFailure];
    [alertView show];
}

-(void)hideBleAllert{
    [alertView dismissAlertView];
}


@end
