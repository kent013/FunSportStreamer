//
//  ENGStreamerMainViewController.h
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GalileoControl/GalileoControl.h>
#import "ENGGalileoSessionManager.h"

@interface ENGStreamerMainViewController : UIViewController<ENGGalileoSessionManagerDelegate, GCGalileoDelegate>
@property (nonatomic, strong) ENGGalileoSessionManager *sessionManager;
@end

