//
//  DeviceListController.m
//  Ble
//
//  Created by Евгений Елчев on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "DeviceListController.h"
#import "ServicesListController.h"


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
    NSDictionary* device = [devices objectAtIndex:indexPath.row];
    
    UILabel* rssi = (UILabel*)[cell viewWithTag:3];
    UILabel* name = (UILabel*)[cell viewWithTag:2];
    UILabel* services = (UILabel*)[cell viewWithTag:4];
    
    NSString* rssiValue = [NSString stringWithFormat:@"%@ db", [device objectForKey:@"rssi"]];
    [rssi setText: rssiValue];
    
    [name setText:[[device objectForKey:@"peripheral"] name]];
    
    NSString* servisesValue = [NSString stringWithFormat:@"%@ servises", [device objectForKey:@"serviceCount"]];
    [services setText:servisesValue];
    return cell;
}

- (IBAction)scanButtonPressed:(id)sender {
    if (!ScanButton.selected){
        [self startScan];
    }else{
        [self stopScan];
    }
    [ScanButton setSelected:!ScanButton.selected];
}

-(void)startScan{
    [ScanIndicator startAnimating];
    [devices removeAllObjects];
    [[self tableView] reloadData];
    [[Ble sharedManager] startScan];
    
}

-(void)stopScan{
    [[Ble sharedManager] stopScan];
    [ScanIndicator stopAnimating];
}

- (void)addNewDevice:(CBPeripheral*) device RSSI:(NSNumber *)RSSI serviceCount:(NSNumber*)serviceCount{
    
    
    
    NSDictionary * element = @{@"peripheral": device, @"rssi": RSSI, @"serviceCount": serviceCount};
    
    [devices addObject:element];
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:[devices count] - 1 inSection:0];
    NSArray* ipArray = [NSArray arrayWithObject:indexPath];
    [[self tableView] insertRowsAtIndexPaths:ipArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)deviceDiconnected{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"fDeviceListTServiceList"]){
        ServicesListController* controller = [segue destinationViewController];
        NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
        NSDictionary * device = [devices objectAtIndex:indexPath.row];
        [controller setDevice:[device objectForKey:@"peripheral"]];
    }
}



@end
