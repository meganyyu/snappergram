//
//  ProfileViewController.m
//  snappergram
//
//  Created by meganyu on 7/8/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "ProfileViewController.h"

#import "InfiniteScrollActivityView.h"
#import "Post.h"
#import "PostCollectionCell.h"
#import "PostDetailsViewController.h"

#pragma mark - Constants

static NSString *const kAuthorKey = @"author";
static NSString *const kPostCollectionCellID = @"PostCollectionCell";
static NSString *const kPostDetailsSegueID = @"postDetailsSegue";

#pragma mark - Interface

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, PostCollectionCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property int postQueryLimit;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *userPostArray;
@property bool isMoreDataLoading;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;

@end

#pragma mark - Implementation

@implementation ProfileViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _flowLayout = (UICollectionViewFlowLayout *) _collectionView.collectionViewLayout;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    
    _postQueryLimit = 9;
    _isMoreDataLoading = false;
    [self refreshProfile];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(loadPosts)
              forControlEvents:UIControlEventValueChanged];
    [_collectionView insertSubview:_refreshControl
                           atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, _collectionView.contentSize.height, _collectionView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    _loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    _loadingMoreView.hidden = true;
    [_collectionView addSubview:_loadingMoreView];
    
    UIEdgeInsets insets = _collectionView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    _collectionView.contentInset = insets;
}

- (void)refreshProfile {
    _usernameLabel.text = _user.username;
    
    _profileImageView.layer.shadowColor = UIColor.darkGrayColor.CGColor;
    _profileImageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    _profileImageView.layer.shadowRadius = 25.0;
    _profileImageView.layer.shadowOpacity = 0.9;
    _profileImageView.layer.cornerRadius = 25.0;
    _profileImageView.clipsToBounds = YES;
    
    [self loadPosts];
}

- (void)loadPosts {
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:kAuthorKey equalTo:_user];
    postQuery.limit = _postQueryLimit;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.isMoreDataLoading = false;
            [self.loadingMoreView stopAnimating];
            self.postQueryLimit = (int) posts.count + 9;
            
            self.userPostArray = posts;
            
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"ERROR FETCHING POSTS: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _userPostArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPostCollectionCellID forIndexPath:indexPath];
    cell.post = _userPostArray[indexPath.item];
    cell.delegate = self;
    [cell refreshPost];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = _collectionView.frame.size.width / 3;
    CGFloat itemHeight = itemWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - PostCollectionCellDelegate methods

- (void)postCollectionCell:(PostCollectionCell *)postCollectionCell
                    didTap:(Post *)post {
    NSLog(@"Reached postCollectionCell:didTap: method");
    [self performSegueWithIdentifier:kPostDetailsSegueID
                              sender:post];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!_isMoreDataLoading){
        int scrollViewContentHeight = _collectionView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - _collectionView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && _collectionView.isDragging) {
            _isMoreDataLoading = true;
            
            CGRect frame = CGRectMake(0, _collectionView.contentSize.height, _collectionView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            _loadingMoreView.frame = frame;
            [_loadingMoreView startAnimating];
            
            // ... Code to load more results ...
            NSLog(@"Letting you know that we're pulling up more data! Post query limit: %d", _postQueryLimit);
            [self loadPosts];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([[segue identifier] isEqualToString:kPostDetailsSegueID]) {
        Post *tappedPost = sender;
        
        UINavigationController *navigationController = [segue destinationViewController];
        PostDetailsViewController *postDetailsViewController = (PostDetailsViewController *)navigationController.topViewController;
        postDetailsViewController.post = tappedPost;
        
        NSLog(@"ProfileViewController preparing for segue!");
    }
}

@end
