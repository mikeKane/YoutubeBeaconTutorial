//
//  ViewController.m
//  iBeaconsYoutube
//
//  Created by Michael Kane on 10/2/14.
//  Copyright (c) 2014 Michael Kane. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <ESTBeaconManager.h>


@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon *beacon;
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *beaconRegion;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beaconLabel.text = @"";
    //Create your UUID
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407f30-f5f8-466e-aff9-25556b57fe6d"];
    
    //set up the beacon manager
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    //set up the beacon region
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                                                                 major:37470
                                                                 minor:56023
                                                            identifier:@"RegionIdenifier"];
    
    //let us know when we exit and enter a region
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    //start  monitorinf
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    //start the ranging
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    
    //MUST have for IOS8
    [self.beaconManager requestAlwaysAuthorization];

    
}

//check for region failure
-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Region Did Fail: Manager:%@ Region:%@ Error:%@",manager, region, error);
}

//checks permission status
-(void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Status:%d", status);
}

//Beacon manager did enter region
- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    //Adding a custom local notification to be presented
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"Youve done it!";
    notification.soundName = @"Default.mp3";
    NSLog(@"Youve entered");
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

//Beacon Manager did exit the region
- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    //adding a custon local notification
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"Youve exited!!!";
    NSLog(@"Youve exited");
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    if (beacons.count > 0) {
        ESTBeacon *firstBeacon = [beacons firstObject];
        self.beaconLabel.text = [self textForProximity:firstBeacon.proximity];
    }
}

-(NSString *)textForProximity:(CLProximity)proximity
{
    
    switch (proximity) {
        case CLProximityFar:
            NSLog(@"far");
            return @"Far";
            break;
        case CLProximityNear:
            NSLog(@"near");
            self.beaconLabel.textColor = [UIColor purpleColor];
            return @"Near";
            break;
        case CLProximityImmediate:
            NSLog(@"immediate");
            self.beaconLabel.textColor = [UIColor redColor];
            return @"Immediate";
            break;
        case CLProximityUnknown:
            NSLog(@"unknown " );
            return @"Unknown";
            break;
        default:
            break;
    }
}


@end
