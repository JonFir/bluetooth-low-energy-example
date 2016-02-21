//
//  CharacteristicController.m
//  Ble
//
//  Created by Евгений Елчев on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import "CharacteristicController.h"

@implementation CharacteristicController

@synthesize characteristic, device;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Ble sharedManager] setCharacteristicDelegate:self];
    [self setTitle:[NSString stringWithFormat:@"%@", [[self characteristic] UUID]]];
    [[self navigationItem] setPrompt:[NSString stringWithFormat:@"UUID %@", [[self characteristic] UUID]]];
    
    [[self valueInput] setDelegate:self];
    
    [self readCharacteristic];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateValue:(NSData *)newValue{
    [[self valueInput] setText:[NSString stringWithFormat:@"%@", newValue]];
}

- (IBAction)SubscribButtonPressed:(id)sender {
    BOOL value = ![[self subscribButton] isSelected];
    NSLog(@"%@", value ? @"YES1" : @"NO1");
    [device setNotifyValue:YES forCharacteristic:[self characteristic]];
    [[self subscribButton] setSelected:![[self subscribButton] isSelected]];
}

- (IBAction)saveButtonPressed:(id)sender {
    CBCharacteristicWriteType type = [[self characteristic] properties] & CBCharacteristicPropertyWrite ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse;
    NSData* dataToWrite = [self nsDataFormNSString:[[self valueInput] text]];
    [device writeValue:dataToWrite forCharacteristic:[self characteristic] type:type];
}

-(void)readCharacteristic{
    UIImage* check = [UIImage imageNamed:@"check"];
    
    if([[self characteristic] properties] & CBCharacteristicPropertyRead){
        [[self readableIcon] setImage: check];
        [[Ble sharedManager] readCharacteristic:[self characteristic] device:[self device]];
    }
    
    if(([[self characteristic] properties] & CBCharacteristicPropertyWrite) || ([[self characteristic] properties] & CBCharacteristicPropertyWriteWithoutResponse)){
        [[self writableIcon] setImage: check];
        [[self valueInput] setEditable:YES];
        [[self saveButton] setEnabled:YES];
    }
    
    if([[self characteristic] properties] & CBCharacteristicPropertyNotify){
        [[self notifableIcon] setImage: check];
        [[self subscribButton] setEnabled:YES];
    }
    
    [[self subscribButton] setSelected:[[self characteristic] isNotifying]];
    NSLog(@"%@", characteristic);
}


-(NSData *)nsDataFormNSString:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([string length] / 2); i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
