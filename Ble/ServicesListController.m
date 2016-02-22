//
//  ServicesListController.m
//  Ble
//
//  Created by Елчев Евгений on 19.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "ServicesListController.h"
#import "CharacteristicsListController.h"

@implementation ServicesListController
@synthesize device;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:[device name]];
    self.navigationItem.prompt = [NSString stringWithFormat:@"UUID %@", device.identifier.UUIDString];
    services = [[NSArray alloc] init];
    [self conectDevice];
    
}

- (void)dealloc
{
    [self disconectDevice];
}

- (void) conectDevice{
    [[Ble sharedManager] setDeviceDelegate:self];
    [[Ble sharedManager] connectPeripheral:device];
}

- (void) disconectDevice{
    [[Ble sharedManager] disconnectPeripheral:device];
}

-(void)addServices:(NSArray *)newServices{
    services = newServices;
    [[self tableView] reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell" forIndexPath:indexPath];
    CBService* service = [services objectAtIndex:indexPath.row];
    
    UILabel * name = [cell viewWithTag:1];
    [name setText:[NSString stringWithFormat:@"%@", service.UUID]];
    
    
    UILabel * uuid = [cell viewWithTag:2];
    [uuid setText:self.navigationItem.prompt];
  
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"fServiceListTCharacteristicsList"]){
        CharacteristicsListController* controller = [segue destinationViewController];
        NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
        [controller setService:[services objectAtIndex:indexPath.row]];
        [controller setDevice:device];
    }
}


@end
