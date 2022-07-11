//
//  TorchModule.m
//  Adaptabois
//
//  Created by rareone0602 on 6/27/22.
//

#import "TorchModule.h"
#import <Libtorch-Lite/Libtorch-Lite.h>

@implementation TorchModule {
 @protected
  torch::jit::mobile::Module _impl;
}

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
  self = [super init];
  if (self) {
    try {
      _impl = torch::jit::_load_for_mobile(filePath.UTF8String);
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
  }
  return self;
}

- (UIImage*) generateImage {
  try {
    const int width = 512, height = 512, latent = 512;
    at::Tensor tensor = torch::randn({1, latent});
    c10::InferenceMode guard;
    auto outputTensor = _impl.forward({tensor}).toTensor();
    
    unsigned char* buffer = outputTensor.data_ptr<unsigned char>();
    if (!buffer) {
      return nil;
    }
    
    unsigned char* rgba = (unsigned char*)malloc(width * height * 4);
    // (3, 512, 512) => (512, 512, 4) row major as C
    for (int i = 0; i < width * height; ++i) {
        rgba[4 * i + 0] = buffer[i + 0 * width * height];
        rgba[4 * i + 1] = buffer[i + 1 * width * height];
        rgba[4 * i + 2] = buffer[i + 2 * width * height];
        rgba[4 * i + 3] = 255;
    }

    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgba, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if (colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }

    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;

    CGImageRef iref = CGImageCreate(width,
        height,
        bitsPerComponent,
        bitsPerPixel,
        bytesPerRow,
        colorSpaceRef,
        bitmapInfo,
        provider,
        NULL,
        YES,
        renderingIntent);

    uint32_t* pixels = (uint32_t*)malloc(bufferLength);

    if (pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }

    CGContextRef context = CGBitmapContextCreate(pixels,
        width,
        height,
        bitsPerComponent,
        bytesPerRow,
        colorSpaceRef,
        bitmapInfo);
    if (context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }

    UIImage* image = nil;
    if (context) {
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }

        CGImageRelease(imageRef);
        CGContextRelease(context);
    }

    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);

    if (pixels) {
        free(pixels);
    }
    
    if ( drand48() < 0.5 ) { // 50% for horizontal flip
      image = [UIImage imageWithCGImage:image.CGImage
          scale:image.scale orientation:UIImageOrientationUpMirrored];
    }
    
    
    return image;
  } catch (const std::exception& exception) {
    NSLog(@"%s", exception.what());
  }
  return nil;
}

@end

