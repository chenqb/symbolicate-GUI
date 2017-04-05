//
//  ViewController.h
//  symbolicate-GUI
//
//  Created by chenquanbin on 2017/4/4.
//  Copyright © 2017年 chenquanbin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *crashFilePath;
@property (weak) IBOutlet NSTextField *dSYMFilePath;

@property (weak) IBOutlet NSButton *symbolicateBtn;

@property (unsafe_unretained) IBOutlet NSTextView *output;

@end

