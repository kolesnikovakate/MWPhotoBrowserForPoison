//
//  MWPhoto.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MWPhotoProtocol.h"

// This class models a photo/image and it's caption
// If you want to handle photos, caching, decompression
// yourself then you can simply ensure your custom data model
// conforms to MWPhotoProtocol
@interface MWPhoto : NSObject <MWPhoto>

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *userImageURL;
@property (nonatomic, strong) NSString *reviewText;
@property (nonatomic, strong) NSDate *reviewDate;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic) BOOL emptyImage;
@property (nonatomic) BOOL isVideo;

+ (MWPhoto *)photoWithImage:(UIImage *)image;
+ (MWPhoto *)photoWithURL:(NSURL *)url;
+ (MWPhoto *)photoWithURL:(NSURL *)url
                 username:(NSString *)username
             userImageURL:(NSURL *)userImageURL
               reviewText:(NSString *)reviewText
               reviewDate:(NSDate *)reviewDate;
+ (MWPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;
+ (MWPhoto *)videoWithURL:(NSURL *)url; // Initialise video with no poster image

- (id)init;
- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url
         username:(NSString *)username
     userImageURL:(NSURL *)userImageURL
       reviewText:(NSString *)reviewText
       reviewDate:(NSDate *)reviewDate;
- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;
- (id)initWithVideoURL:(NSURL *)url;

@end

