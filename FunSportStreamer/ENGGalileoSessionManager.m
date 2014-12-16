//
//  ENGGalileoSessionManager.m
//  FunSportStreamer
//
//  Created by ISHITOYA Kentaro on 2014/12/15.
//  Copyright (c) 2014 engraphia. All rights reserved.
//

#import "ENGGalileoSessionManager.h"
typedef NS_ENUM (NSUInteger, ENGGalileoSessionCommand) {
    ENGGalileoSessionCommandStop,
    ENGGalileoSessionCommandVelocityControl,
};

static NSString *const kSessionCommand = @"Command";
static NSString *const kSessionCommandValueDirection = @"direction";
static NSString *const kSessionCommandValueVelocity = @"velocity";


//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface ENGGalileoSessionManager(PrivateImplementation)
- (void) setupInitialStateWithPeerName:(NSString *)peerName andServiceTypeName:(NSString *)serviceTypeName;
- (void) sendDictionary:(NSDictionary *)dictionary;
@end

@implementation ENGGalileoSessionManager(PrivateImplementation)
- (void)setupInitialStateWithPeerName:(NSString *)peerName andServiceTypeName:(NSString *)serviceTypeName{
    self.devicePeerId = [[MCPeerID alloc] initWithDisplayName:peerName];
    
    self.session = [[MCSession alloc] initWithPeer:self.devicePeerId
                                  securityIdentity:nil encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    self.nearbyAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.devicePeerId discoveryInfo:nil serviceType:serviceTypeName];
    self.nearbyAdvertiser.delegate = self;
    
    
    
    self.serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.devicePeerId serviceType:serviceTypeName];
    self.serviceBrowser.delegate = self;
    [self.serviceBrowser startBrowsingForPeers];
}

- (void)sendDictionary:(NSDictionary *)dictionary{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [self.session sendData:data toPeers:self.session.connectedPeers withMode:MCSessionSendDataUnreliable error:nil];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
//-----------------------------------------------------------------------------
@implementation ENGGalileoSessionManager
#pragma mark - Initializer
- (id) initWithPeerName:(NSString *)peerName andServiceTypeName:(NSString *)serviceTypeName{
    self = [super init];
    if(self){
        [self setupInitialStateWithPeerName:peerName andServiceTypeName:serviceTypeName];
    }
    return self;
}

#pragma mark - public implementations
- (void)start{
    [self.nearbyAdvertiser startAdvertisingPeer];
}

- (void)stop{
    [self.nearbyAdvertiser stopAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    if (invitationHandler) {
        invitationHandler(YES, self.session);
    }
}

#pragma mark - MCSessionDelegate Methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"PEER CONNECTED: %@", peerID.displayName);
            break;
        case MCSessionStateConnecting:
            NSLog(@"PEER CONNECTING: %@", peerID.displayName);
            break;
        case MCSessionStateNotConnected:
            NSLog(@"PEER NOT CONNECTED: %@", peerID.displayName);
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary* dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([dict objectForKey:kSessionCommand] == nil){
        return;
    }
    ENGGalileoSessionCommand command = (ENGGalileoSessionCommand)[dict[kSessionCommand] integerValue];
    switch (command) {
        case ENGGalileoSessionCommandVelocityControl:
            if([self.delegate respondsToSelector:@selector(galileoSessionManager:didReceiveGalileoVelocityControlCommand:velocity:)]){
                [self.delegate galileoSessionManager:self didReceiveGalileoVelocityControlCommand:(GCControlAxis)[dict[kSessionCommandValueDirection] intValue] velocity:(float)[dict[kSessionCommandValueVelocity] floatValue]];
            }
            break;
        case ENGGalileoSessionCommandStop:
            if([self.delegate respondsToSelector:@selector(didReceiveGalileoStopCommand)]){
                [self.delegate didReceiveGalileoStopCommand];
            }
        default:
            break;
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}


#pragma mark - MCNearbyServiceBrowserDelegate

- (void) browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
}

- (void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    [browser invitePeer:peerID toSession:_session withContext:nil timeout:0];
}

- (void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

- (void)sendGalileoStopCommand{
    NSDictionary* dict = @{kSessionCommand: @(ENGGalileoSessionCommandStop)};
    [self sendDictionary:dict];
    
}

- (void) sendGalileoVelocityControlCommand:(GCControlAxis)axis velocity:(float)velocity{
    NSDictionary* dict = @{
                           kSessionCommand: @(ENGGalileoSessionCommandVelocityControl),
                           kSessionCommandValueDirection: @(axis),
                           kSessionCommandValueVelocity: @(velocity)
                           };
    [self sendDictionary:dict];
}

@end
