//
//  TorchModule.h
//  Adaptabois
//
//  Created by rareone0602 on 6/27/22.
//

#ifndef TorchModule_h
#define TorchModule_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath
    NS_SWIFT_NAME(init(fileAtPath:))NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (UIImage*)generateImage NS_SWIFT_NAME(generate());

@end

NS_ASSUME_NONNULL_END


#endif /* TorchModule_h */
