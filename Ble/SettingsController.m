//
//  SettingsController.m
//  Ble
//
//  Created by Елчев Евгений on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "SettingsController.h"
#import "CoreData.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSettings];
    [self setTitle:@"Background settings"];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadDevices)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDevices];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    
    NSManagedObject *device = [devices objectAtIndex:indexPath.row];
    
    UILabel* name = [cell viewWithTag:1];
    UILabel* uuid = [cell viewWithTag:2];
    UILabel* time = [cell viewWithTag:3];
    
    [name setText:[device valueForKey:@"name"]];
    
    NSString* uuidText = [NSString stringWithFormat:@"UUID: %@", [device valueForKey:@"uuid"]];
    [uuid setText:uuidText];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString* timeString = [dateFormatter stringFromDate:[device valueForKey:@"time"]];
    [time setText:timeString];
    return cell;
}

- (IBAction)ScanCheckBoxChanged:(id)sender {
    [self saveSettings];
}

-(void)saveSettings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:[_ScanCheckBox isOn] forKey:@"backgroundScanEnabled"];
    [userDefaults synchronize];
}

-(void)loadSettings{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [_ScanCheckBox setOn:[userDefaults boolForKey:@"backgroundScanEnabled"]];
}

-(void)loadDevices{
    CoreData* coreData = [[CoreData alloc] init];
    devices = [coreData loadDevices];
    [[self tableView] reloadData];
}



@end
