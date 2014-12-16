//
//  ENGGalileoSessionManager.h
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GalileoControl/GalileoControl.h>
@import MultipeerConnectivity;

@protocol ENGGalileoSessionManagerDelegate;

@interface ENGGalileoSessionManager : NSObject<MCNearbyServiceBrowserDelegate, MCAdvertiserAssistantDelegate, MCSessionDelegate,MCNearbyServiceAdvertiserDelegate>
@property (nonatomic, strong) MCPeerID *devicePeerId;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *nearbyAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;
@property (nonatomic, weak) id<ENGGalileoSessionManagerDelegate> delegate;

- (id) initWithPeerName:(NSString *)peerName andServiceTypeName:(NSString *)serviceTypeName;
- (void)start;
- (void)stop;
- (void)sendGalileoStopCommand;
- (void)sendGalileoVelocityControlCommand:(GCControlAxis)axis velocity:(float)velocity;
@end

@protocol ENGGalileoSessionManagerDelegate <NSObject>
@optional
- (void) didReceiveGalileoStopCommand;
- (void) galileoSessionManager:(ENGGalileoSessionManager *)galileoSessionManager didReceiveGalileoVelocityControlCommand:(GCControlAxis)axis velocity:(float)velocity;
@end