//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIImageView+WebCache.h>

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"

static const CGFloat labelPadding = 10;
static const CGFloat reviewPadding = 16;
static const CGFloat userImageSize = 24;
static const CGFloat reviewDateLabelWidth = 100;

// Private
@interface MWCaptionView () {
    id <MWPhoto> _photo;
    UILabel *_label;
    BOOL _hasCaption;
}

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *reviewTextLabel;
@property (strong, nonatomic) UILabel *reviewDateLabel;

@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    BOOL hasCaption = NO;
    
    if ([photo respondsToSelector:@selector(caption)]) {
        hasCaption = [photo caption];
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    
    if (self) {
        _hasCaption = hasCaption;
        self.userInteractionEnabled = NO;
        _photo = photo;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = nil;
        self.barStyle = UIBarStyleBlackTranslucent;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        hasCaption ? [self setupCaption] : [self setupReview];
    }
    return self;
}

- (void)setNeedsDisplay {
    if (!_hasCaption) {
        [self setupReview];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (_hasCaption) {
        CGFloat maxHeight = 9999;
        if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
        CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:_label.font}
                                                    context:nil].size;
        return CGSizeMake(size.width, textSize.height + labelPadding * 2);
    }
    
    
    //Если есть отзыв
    CGFloat maxHeight = 9999;
    CGSize textSize = [self.reviewTextLabel.text boundingRectWithSize:CGSizeMake(size.width - reviewPadding*2, maxHeight)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:self.reviewTextLabel.font}
                                                context:nil].size;
    return CGSizeMake(size.width, 40 + textSize.height + reviewPadding * 2);
}

- (void)setupCaption {
    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                      self.bounds.size.width-labelPadding*2,
                                                                      self.bounds.size.height))];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:17];
    
    _label.text = [_photo caption] ? [_photo caption] : @" ";
    [self addSubview:_label];
}

- (void)setupReview {
    
    //Фото пользователя
    if (self.userImageView) {
        [self.userImageView removeFromSuperview];
    }
    self.userImageView = [[UIImageView alloc] initWithFrame:CGRectIntegral(CGRectMake(reviewPadding, reviewPadding, userImageSize, userImageSize))];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 12;
    if ([_photo respondsToSelector:@selector(userImageURL)]) {
        [self.userImageView sd_setImageWithURL:[_photo userImageURL]];
    }
    [self addSubview:self.userImageView];
    
    // Лейбл с именем
    if (self.userNameLabel) {
        [self.userNameLabel removeFromSuperview];
    }
    
    CGFloat x = reviewPadding*2 + userImageSize;
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(x, reviewPadding,
                                                                                    self.bounds.size.width-x-reviewPadding-reviewDateLabelWidth, userImageSize))];
    self.userNameLabel.opaque = NO;
    
    self.userNameLabel.numberOfLines = 1;
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont fontWithName:@"ProximaNova" size:12];
    
    if ([_photo respondsToSelector:@selector(username)]) {
        self.userNameLabel.text = [_photo username] ? : @" ";
    }
    
    [self addSubview:self.userNameLabel];
    
    // Лейбл с датой
    if (self.reviewDateLabel) {
        [self.reviewDateLabel removeFromSuperview];
    }
    
    x = self.bounds.size.width-reviewPadding-reviewDateLabelWidth;
    self.reviewDateLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(x, reviewPadding, reviewDateLabelWidth, userImageSize))];
    self.reviewDateLabel.opaque = NO;
    self.reviewDateLabel.textAlignment = NSTextAlignmentRight;
    self.reviewDateLabel.numberOfLines = 1;
    self.reviewDateLabel.textColor = [UIColor colorWithRed:145/255.0f green:145/255.0f blue:145/255.0f alpha:1];
    self.reviewDateLabel.font = [UIFont fontWithName:@"ProximaNova" size:12];
    
    if ([_photo respondsToSelector:@selector(reviewDate)]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM YYYY"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        self.reviewDateLabel.text = [_photo reviewDate] ? [dateFormatter stringFromDate: [_photo reviewDate]] : @" ";
    }
    
    [self addSubview:self.reviewDateLabel];
    
    // Лейбл с отзывом
    if (self.reviewTextLabel) {
        [self.reviewTextLabel removeFromSuperview];
    }
    
    CGFloat y = reviewPadding + userImageSize;
    self.reviewTextLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(reviewPadding, y,
                                                                                    self.bounds.size.width-reviewPadding*2,
                                                                                    self.bounds.size.height - y))];
    self.reviewTextLabel.opaque = NO;
    
    self.reviewTextLabel.numberOfLines = 0;
    self.reviewTextLabel.textColor = [UIColor whiteColor];
    self.reviewTextLabel.font = [UIFont fontWithName:@"ProximaNova" size:14];
    
    if ([_photo respondsToSelector:@selector(reviewText)]) {
        self.reviewTextLabel.text = [_photo reviewText] ? : @" ";
    }
    [self addSubview:self.reviewTextLabel];
}

@end
