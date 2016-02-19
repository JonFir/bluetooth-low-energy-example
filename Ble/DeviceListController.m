//
//  DeviceListController.m
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "DeviceListController.h"


@implementation DeviceListController

@synthesize ScanIndicator, ScanButton;

- (void) viewDidLoad{
    [super viewDidLoad];
    [[self tableView] setDelegate:self];
    [[self tableView] setDataSource:self];
    devices = [[NSMutableArray alloc] init];
    [[Ble sharedManager] setDeviceListDelegate:self];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell" forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)scanButtonPressed:(id)sender {
    if (!ScanButton.selected){
        [self startScan];
    }else{
        [self stopScan];
    }
}

-(void)startScan{
    [devices removeAllObjects];
    [[self tableView] reloadData];
    [[Ble sharedManager] startScan];
    [ScanIndicator startAnimating];
    [ScanButton setSelected:YES];
}

-(void)stopScan{
    [[Ble sharedManager] startScan];
    [ScanIndicator stopAnimating];
    [ScanButton setSelected:NO];
}

- (void)addNewDevice:(CBPeripheral*) device{
    [devices addObject:device];
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:[devices count] - 1 inSection:0];
    NSArray* ipArray = [NSArray arrayWithObject:indexPath];
    [[self tableView] insertRowsAtIndexPaths:ipArray withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
