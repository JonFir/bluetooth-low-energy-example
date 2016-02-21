//
//  CharacteristicsListController.m
//  Ble
//
//  Created by Евгений Елчев on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "CharacteristicsListController.h"
#import "CharacteristicController.h"

@implementation CharacteristicsListController

@synthesize service, device;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"%@", [[self service] UUID]]];
    self.navigationItem.prompt = [NSString stringWithFormat:@"UUID %@", device.identifier.UUIDString];
    characteristics = [[NSArray alloc] init];
    
    [[Ble sharedManager] setDeviceCharacteristicDelegate:self];
    [[Ble sharedManager] findCharacteristics:[self service] device:[self device]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [characteristics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharacteristicsListCell" forIndexPath:indexPath];
    CBCharacteristic* characteristic = [characteristics objectAtIndex:indexPath.row];
    
    UILabel * name = [cell viewWithTag:1];
    [name setText:[NSString stringWithFormat:@"%@", characteristic.UUID]];
    
    
    UILabel * uuid = [cell viewWithTag:2];
    [uuid setText:[NSString stringWithFormat:@"%@", characteristic.UUID]];
    
    return cell;
}

- (void)addCharacteristics:(NSArray*)newCharacteristic{
    characteristics = newCharacteristic;
    [[self tableView] reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"fCharacteristicsListTCharacteristic"]){
        CharacteristicController* controller = [segue destinationViewController];
        NSIndexPath* indexPath = [[self tableView] indexPathForSelectedRow];
        [controller setCharacteristic:[characteristics objectAtIndex:indexPath.row]];
        [controller setDevice:[self device]];
    }
}




@end
