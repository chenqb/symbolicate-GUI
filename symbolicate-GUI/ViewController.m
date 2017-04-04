//
//  ViewController.m
//  symbolicate-GUI
//
//  Created by chenquanbin on 2017/4/4.
//  Copyright © 2017年 chenquanbin. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.output setFont:[NSFont fontWithName:@"Helvetica" size:14]];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)openCrashLog:(id)sender {
    
    NSLog(@"open Crashlog");
    
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"crash"];
    //[panel setPrompt:@"打开"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
//            NSMutableArray* filePaths = [[NSMutableArray alloc] init];
//            
//            for (NSURL* elemnet in [panel URLs]) {
//                [filePaths addObject:[elemnet path]];
//            }
            NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
            self.crashFilePath.stringValue = [[fileUrl absoluteString] substringFromIndex:7];
            
        }
        else {
            NSLog(@"not ok");
        }
    }];
}
- (IBAction)openDSYM:(id)sender {
    
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"dSYM"];
    //[panel setPrompt:@"打开"];
    [openPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
            self.dSYMFilePath.stringValue = [[fileUrl absoluteString] substringFromIndex:7];
            
        }
        else {
            NSLog(@"not ok");
        }
    }];

    }
- (IBAction)symbolicateAction:(id)sender {
    if([self.crashFilePath.stringValue  isEqual: @""]) {
        self.crashFilePath.highlighted = YES;
        return;
    };
    
    if([self.dSYMFilePath.stringValue  isEqual: @""]) {
        self.dSYMFilePath.highlighted = YES;
        return;
    };
    
    NSString *symbolicateCmdPath = @"/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash";
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:symbolicateCmdPath];
    if(task.environment == nil) {
        task.environment = [NSDictionary dictionaryWithObject: @"/Applications/XCode.app/Contents/Developer" forKey:@"DEVELOPER_DIR"];
    }
   
    
    [task setArguments:@[self.crashFilePath.stringValue, self.dSYMFilePath.stringValue]];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    NSData *data = [file readDataToEndOfFile];
//    NSLog(@"%@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
    
    [self.output insertText: [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]];
    
}

@end
