//
//  NSData+Base64.m
//  HX_GJS
//
//  Created by litao on 16/1/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NSData+Base64.h"
#import <UIKit/UIKit.h>
static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSData (Base64)

- (NSString *)dataToBase64StrWithLength:(NSUInteger)length
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [self length];
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity:lentext];
    raw = [self bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            @autoreleasepool {
                NSString *as = [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]];
                [result appendString:as];
                as = nil;
            }
        }
        
        for (i = ctcopy; i < 4; i++) {
            [result appendString:@"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            charsonline = 0;
        }
    }
    
    return result;
}

- (NSString *)dataToHexStr
{
    NSData *data = [NSData dataWithData:self];
    Byte *bytes = (Byte *)[data bytes];
    
    NSInteger strLen = [data length];
    
    //  Byte 转换为 16进制
    NSMutableString *retHexStr = [[NSMutableString alloc] initWithCapacity:strLen];
    
    for(int index = 0; index < strLen; index++) {
        //  16进制数
        NSString *hexStr = [NSString stringWithFormat:@"%x", bytes[index] & 0xff];
        
        if([hexStr length] == 1) {
            [retHexStr appendFormat:@"0%@", hexStr];
        } else {
            [retHexStr appendString:hexStr];
        }
    }
    
    return retHexStr;
}


- (NSString *)base64String;
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        const uint8_t* input = (const uint8_t*)[self bytes];
        NSInteger length = [self length];
        
        static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        
        NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
        uint8_t* output = (uint8_t*)data.mutableBytes;
        
        NSInteger i;
        for (i=0; i < length; i += 3) {
            NSInteger value = 0;
            NSInteger j;
            for (j = i; j < (i + 3); j++) {
                value <<= 8;
                
                if (j < length) {
                    value |= (0xFF & input[j]);
                }
            }
            
            NSInteger theIndex = (i / 3) * 4;
            output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
            output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
            output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
            output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
        }
        
        return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
    } else {
        return [self base64EncodedStringWithOptions:0];
    }
}
@end
