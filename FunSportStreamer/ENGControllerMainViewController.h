//
//  ENGControllerViewController.h
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENGGalileoSessionManager.h"

@interface ENGControllerMainViewController : UIViewController<ENGGalileoSessionManagerDelegate>
@property (nonatomic, strong) ENGGalileoSessionManager *sessionManager;
@end
