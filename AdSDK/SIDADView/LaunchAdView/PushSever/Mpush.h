//
//  Mpush.h
//  Created by 杨远威 on 2017/12/30.
//  Copyright © 2017年 ISNC. All rights reserved.
//

#ifndef Mpush_h
#define Mpush_h

#define DEVICE_TYPE @"ios"
#define appVersion @"9.2.1";

#define MPUserDefaults  [NSUserDefaults standardUserDefaults]
#define MPIvData @"BCJIvData"
#define MPClientKeyData @"BCJClientKeyData"
#define MPHeartbeatData @"BCJHeartbeatData"
#define PUSH_HOST_ADDRESS @"http://103.246.161.44:9999/push"

#define  MPSessionKeyData @"BCJSessionKeyData"
#define  MPSessionId @"BCJSessionId"
#define  MPExpireTime @"BCJExpireTime"
#define MPDeviceId @"identifierForVendor"
#define MPMinHeartbeat 180
#define MPMaxHeartbeat 180
#define MPMaxConnectTimes 6


#endif /* Mpush_h */
