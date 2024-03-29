//
//  APKAITCGI.m
//  万能AIT
//
//  Created by Mac on 17/6/16.
//  Copyright © 2017年 APK. All rights reserved.
//

#import "APKAITCGI.h"

@implementation APKAITCGI

+ (NSString *)deleteCGIWithFileName:(NSString *)fileName{
    
    return [NSString stringWithFormat:@"http://192.72.1.1/cgi-bin/Config.cgi?action=del&property=%@",fileName];
}

+ (NSString *)getDVRFileListCGIWithFileFormat:(NSString *)format property:(NSString *)property offset:(NSInteger)offset count:(NSInteger)count{
    
    NSString *CGI = [NSString stringWithFormat:@"http://192.72.1.1/cgi-bin/Config.cgi?action=dir&count=%d&format=%@&from=%d&property=%@",(int)count,format,(int)offset,property];
    return CGI;
}

+ (NSString *)getSettingInfoCGI{
    
    return @"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Menu.";
}

+ (NSString *)getSettingEV{
    
    return @"http://192.72.1.1/cgi-bin/Config.cgi?action=get&property=Camera.Menu.LCDPower";
}

+ (NSString *)setCGIWithProperty:(NSString *)property value:(NSString *)value{
    
    NSString *CGI = [NSString stringWithFormat:@"http://192.72.1.1/cgi-bin/Config.cgi?action=set&property=%@&value=%@",property,value];
    return CGI;
}

@end
