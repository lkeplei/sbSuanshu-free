//
//  Sound.m
//  sbSuanshu
//
//  Created by hou guanhua on 13-5-23.
//  Copyright (c) 2013年 hou guanhua. All rights reserved.
//

#import "Sound.h"

#import <AudioToolbox/AudioToolbox.h>

#import <AVFoundation/AVFoundation.h>

@implementation Sound

+ (void)playBtnSnd
{
//    static SystemSoundID incommingSoundID;
//    if (! incommingSoundID) {
//        NSURL *filePath   = [[NSBundle mainBundle] URLForResource:@"btn" withExtension: @"mp3"];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &incommingSoundID);
//    }
//    AudioServicesPlaySystemSound(incommingSoundID);

    // Play it
    static AVAudioPlayer* audio_player = nil;
    if (nil == audio_player) {
        NSURL *filePath   = [[NSBundle mainBundle] URLForResource:@"btn" withExtension: @"mp3"];
        audio_player = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
    }
//    audio_player.volume = 1;
    [audio_player play];
}

@end
