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

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MWPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    CGFloat scale = selected ? 1.2 : 1;
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

- (void)setImageUrl:(NSURL *)imageUrl {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView sd_setImageWithURL:imageUrl];
}

@end
