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
    
    UITapGestureRecognizer *const postTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPostDetails:)];
    [self.photoImageView addGestureRecognizer:postTapGestureRecognizer];
    [self.photoImageView setUserInteractionEnabled:YES];
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.photoImageView.file = post.image;
    [self.photoImageView loadInBackground];
    
    [self.captionLabel setText:post.caption];
}

- (void) didTapPostDetails:(UITapGestureRecognizer *)sender{
    [self.delegate postCollectionCell:self didTap:self.post];
    NSLog(@"PostCollectionCell processed a tap! Tapped on post with caption: %@", self.post.caption);
}

@end
