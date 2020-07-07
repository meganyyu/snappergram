//
//  PostCollectionCell.m
//  snappergram
//
//  Created by meganyu on 7/7/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.photoImageView.file = post.image;
    [self.photoImageView loadInBackground];
    
    [self.captionLabel setText:post.caption];
}

@end
