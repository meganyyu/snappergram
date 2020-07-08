//
//  PostCollectionCell.h
//  snappergram
//
//  Created by meganyu on 7/7/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostCollectionCellDelegate;

@interface PostCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<PostCollectionCellDelegate> delegate;
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@protocol PostCollectionCellDelegate

- (void)postCollectionCell:(PostCollectionCell *)postCollectionCell didTap:(Post *)post;

@end

NS_ASSUME_NONNULL_END
