//
//  MWPhotoPreviewCell.m
//  Pods
//
//  Created by Ekaterina Kolesnikova on 14.04.16.
//
//

#import "UIImageView+WebCache.h"

#import "MWPhotoPreviewCell.h"

@interface MWPhotoPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MWPhotoPreviewCell

- (void)awakeFromNib {
}

- (void)setImageUrl:(NSURL *)imageUrl {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView sd_setImageWithURL:imageUrl];
}

@end
