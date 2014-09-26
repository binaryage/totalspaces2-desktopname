//
//  TSLibGlue.m
//  DesktopName
//
//  Created by Stephen Sykes on 25/09/14.
//  Copyright (c) 2014 Switchstep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSLib.h"

static void (^swiftCallback)(unsigned int, unsigned int, uint32_t);

void realCallback(unsigned int from, unsigned int to, uint32_t displayID) {
    swiftCallback(from, to, displayID);
}

void setSpaceChangeCallback(void (^fn)(unsigned int, unsigned int, uint32_t)) {
    swiftCallback = fn;
    tsapi_setSpaceWillChangeCallback(realCallback);
}

