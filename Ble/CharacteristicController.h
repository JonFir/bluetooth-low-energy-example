//
//  CharacteristicController.h
//  Ble
//
//  Created by Евгений Елчев on 20.02.16.
//  Copyright © 2016 JonFir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ble.h"

@interface CharacteristicController : UIViewController<CharacteristicDelegate, UITextViewDelegate>

@property (strong, nonatomic) CBCharacteristic* characteristic;
@property (strong, nonatomic) CBPeripheral* device;

@property (weak, nonatomic) IBOutlet UIImageView *readableIcon;
@property (weak, nonatomic) IBOutlet UIImageView *writableIcon;
@property (weak, nonatomic) IBOutlet UIImageView *notifableIcon;
@property (weak, nonatomic) IBOutlet UIButton *subscribButton;
@property (weak, nonatomic) IBOutlet UITextView *valueInput;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (void) readCharacteristic;
- (NSData*) nsDataFormNSString:(NSString*)string;
@end
