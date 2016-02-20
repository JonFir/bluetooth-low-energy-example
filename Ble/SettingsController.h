//
//  SettingsController.h
//  Ble
//
//  Created by Елчев Евгений on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UITableViewController{
    NSArray* devices;
}

@property (weak, nonatomic) IBOutlet UISwitch *ScanCheckBox;

-(void)saveSettings;
-(void)loadSettings;


@end
