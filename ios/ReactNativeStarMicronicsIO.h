// ReactNativeBrotherPrinters.h

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <StarMgsIO/StarMgsIO.h>

@interface ReactNativeStarMicronicsIO : RCTEventEmitter <RCTBridgeModule, STARDeviceManagerDelegate, STARScaleDelegate, CBCentralManagerDelegate> {
    CBCentralManager *_centralmanager;
    STARScale *connectedScale;
    bool hasListeners;
    
    NSDictionary<NSNumber *, NSString *> *unitDict;
    NSDictionary<NSNumber *, NSString *> *statusDict;
    NSDictionary<NSNumber *, NSString *> *dataTypeDict;
    NSDictionary<NSNumber *, NSString *> *scaleTypeDict;
    NSDictionary<NSNumber *, NSString *> *comparatorResultDict;
    NSMutableDictionary<NSString *, STARScale *> *scaleDict;

}

@end
