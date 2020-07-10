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
    
    UITapGestureRecognizer *const postTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                                    action:@selector(didTapPostDetails:)];
    [_photoImageView addGestureRecognizer:postTapGestureRecognizer];
    [_photoImageView setUserInteractionEnabled:YES];
}

- (void)setPost:(Post *)post {
    _post = post;
    
    _photoImageView.file = post.image;
    [_photoImageView loadInBackground];
    
    [_captionLabel setText:post.caption];
}

- (void) didTapPostDetails:(UITapGestureRecognizer *)sender{
    [_delegate postCollectionCell:self
                               didTap:_post];
    NSLog(@"PostCollectionCell processed a tap! Tapped on post with caption: %@", _post.caption);
}

@end
