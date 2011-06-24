//
//  deviceInformation.h
//  iClous
//
//  Created by Rodewig Klaus on 24.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface deviceInformation : NSObject {

}
@property(retain) NSString *ipAddress;
@property(retain) NSString *udid;
@property(retain) NSString *name;
@property(retain) NSString *systemName;
@property(retain) NSString *systemVersion;
@end
