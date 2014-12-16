//
//  ENGControllerViewController.m
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import "ENGControllerMainViewController.h"
#import "ENGGalileoConstants.h"

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface ENGControllerMainViewController (PrivateImplementation)
- (void)setupInitialState;
@end

@implementation ENGControllerMainViewController (PrivateImplementation)
- (void)setupInitialState{
    self.sessionManager = [[ENGGalileoSessionManager alloc] initWithPeerName:@"controller" andServiceTypeName:SERVICE_NAME];
    self.sessionManager.delegate = self;
    [self.sessionManager start];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------

@implementation ENGControllerMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onStopButtonTapped:(id)sender {
    [self.sessionManager sendGalileoStopCommand];
}
- (IBAction)onUpButtonTapped:(id)sender {
    [self.sessionManager sendGalileoVelocityControlCommand:GCControlAxisTilt velocity: -100.0];
}
- (IBAction)onDownButtonTapped:(id)sender {
    [self.sessionManager sendGalileoVelocityControlCommand:GCControlAxisTilt velocity: 100.0];
}
- (IBAction)onLeftButtonTapped:(id)sender {
    [self.sessionManager sendGalileoVelocityControlCommand:GCControlAxisPan velocity: -100.0];
}
- (IBAction)onRightButtonTapped:(id)sender {
    [self.sessionManager sendGalileoVelocityControlCommand:GCControlAxisPan velocity: 100.0];
}
@end
