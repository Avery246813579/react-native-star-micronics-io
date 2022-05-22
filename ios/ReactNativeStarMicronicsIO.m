// ReactNativeBrotherPrinters.m

#import "ReactNativeStarMicronicsIO.h"
#import <React/RCTConvert.h>
#import <StarMgsIO/StarMgsIO.h>

@implementation ReactNativeStarMicronicsIO

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

-(void)startObserving {
    hasListeners = YES;
}

-(void)stopObserving {
    hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onScanLog",
        @"onScaleData",
        @"onScaleConnect",
        @"onScaleDisconnect",
        @"onDiscoverScale",
    ];
}

RCT_REMAP_METHOD(setupScales, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSLog(@"Settings up the scales");

    STARDeviceManager.sharedManager.delegate = self;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    _centralmanager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];

    scaleDict = [[NSMutableDictionary alloc] init];

    [self initDictionaries];
}

RCT_REMAP_METHOD(connectScale, scale:(NSDictionary *) scaleInfo connectScaleResolver:(RCTPromiseResolveBlock)resolve connectScaleRejecter:(RCTPromiseRejectBlock)reject)
{
    STARScale * scale = scaleDict[scaleInfo[@"id"]];

    if (scale == Nil) {
        return reject(@"SCALE_ERROR", @"Scale not found", Nil);
    }

    [STARDeviceManager.sharedManager connectScale:scale];
}


- (void)initDictionaries {
    unitDict = @{@(STARUnitInvalid): @"Invalid",
                  @(STARUnitMG): @"mg",
                  @(STARUnitG): @"g",
                  @(STARUnitKG): @"kg",
                  @(STARUnitCT): @"ct",
                  @(STARUnitMOM): @"mom",
                  @(STARUnitOZ): @"oz",
                  @(STARUnitLB): @"lb",
                  @(STARUnitOZT): @"ozt",
                  @(STARUnitDWT): @"dwt",
                  @(STARUnitGN): @"gr",
                  @(STARUnitTLH): @"tl",
                  @(STARUnitTLS): @"tl",
                  @(STARUnitTLT): @"tl",
                  @(STARUnitTO): @"tola",
                  @(STARUnitMSG): @"msg",
                  @(STARUnitBAT): @"bht",
                  @(STARUnitPCS): @"PCS",
                  @(STARUnitPercent): @"%",
                  @(STARUnitCoefficient): @"MUL"};

    statusDict = @{@(STARStatusStable): @"Stable",
                    @(STARStatusError): @"Error",
                    @(STARStatusInvalid): @"Invalid",
                    @(STARStatusUnstable): @"Unstable"};

    comparatorResultDict = @{@(STARComparatorResultInvalid): @"Invalid",
                              @(STARComparatorResultShortage): @"Shortage",
                              @(STARComparatorResultProper): @"OK",
                              @(STARComparatorResultOver): @"Over"};

    dataTypeDict = @{@(STARDataTypeInvalid): @"Invalid",
                      @(STARDataTypeNetNotTared): @"NetNotTared",
                      @(STARDataTypeNet): @"Net",
                      @(STARDataTypeTare): @"Tare",
                      @(STARDataTypePresetTare): @"PresetTare",
                      @(STARDataTypeTotal): @"Total",
                      @(STARDataTypeUnit): @"Unit",
                      @(STARDataTypeGross): @"Gross"};

    scaleTypeDict =@{
     @(STARScaleTypeInvalid): @"Invalid",
     @(STARScaleTypeMGS): @"MG-S322,MG-S1501,MG-S8200",
     @(STARScaleTypeMGTS): @"MG-T12,MG-T30,MG-T60",
    };
}


RCT_REMAP_METHOD(discoverScales, discoverResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [STARDeviceManager.sharedManager scanForScales];

    NSLog(@"Starting the search for scales");

}

- (void)manager:(STARDeviceManager *)manager didDiscoverScale:(STARScale *)scale error:(NSError *)error {
    NSLog(@"Discovered a scale [%@]", scale);

    [self sendEventWithName:@"onDiscoverScale" body:[self serializeScale:scale]];
    [self sendEventWithName:@"onScanLog" body:@{
        @"event": @"onDiscoverScanner",
        @"location": [self serializeScale:scale]
    }];

    scaleDict[scale.identifier] = scale;
}

- (void)manager:(STARDeviceManager *)manager didConnectScale:(STARScale *)scale error:(NSError *)error {
    NSLog(@"Did discover connect");

    scale.delegate = self;

    [self sendEventWithName:@"onScaleConnect" body:[self serializeScale:scale]];

    [STARDeviceManager.sharedManager stopScan];
}

- (void)manager:(STARDeviceManager *)manager didDisconnectScale:(STARScale *)scale error:(NSError *)error {
    if (error) {
         NSLog(@"%@", error.localizedDescription);
    }

    [self sendEventWithName:@"onScaleDisconnect" body:[self serializeScale:scale]];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    NSLog(@"We are doing somethibng %ld", (long)central.state);

//    switch (central.state) {
//        case CBCentralManagerStatePoweredOn:
//            [STARDeviceManager.sharedManager scanForScales];
//            break;
//        default:
//            [STARDeviceManager.sharedManager stopScan];
//            [_contents removeAllObjects];

//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//
//            break;
//    }
}

- (void)scale:(STARScale *)scale didReadScaleData:(STARScaleData *)scaleData error:(NSError *)error {
    if (error) {
        return NSLog(@"Error");
    }

    [self sendEventWithName:@"onScaleData" body:[self serializeScaleData:scaleData]];
}

- (void)scale:(STARScale *)scale didUpdateSetting:(STARScaleSetting)setting error:(NSError *)error {
    NSLog(@"%s: Success", __PRETTY_FUNCTION__);
}

- (NSDictionary *) serializeScale:(STARScale *)scale {
    return @{
        @"id": scale.identifier,
        @"name": scale.name,
        @"description": scale.description,
        @"type": scaleTypeDict[@(scale.scaleType)],
    };
}

- (NSDictionary *) serializeScaleData:(STARScaleData *)scaleData {
    return @{
        @"weight": @(scaleData.weight),
        @"type": dataTypeDict[@(scaleData.dataType)],
        @"unit": unitDict[@(scaleData.unit)],
    };
}

@end
