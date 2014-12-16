//
//  ENGStreamerMainViewController.m
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import "ENGStreamerMainViewController.h"
#import "ENGGalileoConstants.h"

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface ENGStreamerMainViewController (PrivateImplementation)
- (void)setupInitialState;
@end

@implementation ENGStreamerMainViewController (PrivateImplementation)
- (void)setupInitialState{
    self.sessionManager = [[ENGGalileoSessionManager alloc] initWithPeerName:@"streamer" andServiceTypeName:SERVICE_NAME];
    self.sessionManager.delegate = self;
    [self.sessionManager start];
    [GCGalileo sharedGalileo].delegate = self;
    [[GCGalileo sharedGalileo] waitForConnection];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation ENGStreamerMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialState];
}

- (IBAction)connectButtonTapped:(id)sender {
    [[GCGalileo sharedGalileo] waitForConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)galileoDidConnect{
    [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Galileo Connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)galileoDidDisconnect{
    [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Galileo Disconnected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)didReceiveGalileoStopCommand{
    if(![GCGalileo sharedGalileo].isConnected){
        return;
    }
    GCVelocityControl* velocityControl = [[GCGalileo sharedGalileo] velocityControlForAxis:GCControlAxisTilt];
    [velocityControl setTargetVelocity:0];
    velocityControl = [[GCGalileo sharedGalileo] velocityControlForAxis:GCControlAxisPan];
    [velocityControl setTargetVelocity:0];
}

- (void)galileoSessionManager:(ENGGalileoSessionManager *)galileoSessionManager didReceiveGalileoVelocityControlCommand:(GCControlAxis)axis velocity:(float)velocity{
    if(![GCGalileo sharedGalileo].isConnected){
        return;
    }
    GCVelocityControl* tiltVelocityControl = [[GCGalileo sharedGalileo] velocityControlForAxis:axis];
    [tiltVelocityControl setTargetVelocity:velocity];
}
@end
