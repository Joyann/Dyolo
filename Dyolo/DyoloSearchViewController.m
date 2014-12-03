//
//  DyoloSearchViewController.m
//  Dyolo
//
//  Created by joyann on 14/11/30.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "DyoloSearchViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

static NSString *const DouBanSearchURLString = @"https://api.douban.com/v2/movie/search?";
static NSString *const MovieCellIdentifier = @"MovieCell";
static NSString *const MovieLoadingCellIdentifier = @"MovieLoadingCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface DyoloSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableArray *movies;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation DyoloSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // Add tap gesture to hide keyboard.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    // Register movie cell.
    UINib *nib = [UINib nibWithNibName:MovieCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:MovieCellIdentifier];
    
    // Register movie loading cell.
    nib = [UINib nibWithNibName:MovieLoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:MovieLoadingCellIdentifier];
    
    // Register nothing found cell.
    nib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
}


#pragma mark - HideKeyboard

- (void)hideKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading) {
        return 1;
    } else if (!self.movies) {
        return 0;
    } else if ([self.movies count] == 0) {
        return 1;
    }
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading) {
        UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:MovieLoadingCellIdentifier forIndexPath:indexPath];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[loadingCell viewWithTag:1001];
        [indicator startAnimating];
        
        return loadingCell;
    } else if ([self.movies count] == 0) {
        UITableViewCell *nothingFoundCell = [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
        return nothingFoundCell;
    } else {
        MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:MovieCellIdentifier
                                                               forIndexPath:indexPath];
        Movie *movie = self.movies[indexPath.row];
        
        [movieCell configurateCellWithMovie:movie];
        
        return movieCell;
    }

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *movieDetailVC = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    Movie *movie = self.movies[indexPath.row];
    movieDetailVC.movie = movie;
    [movieDetailVC presentInParentViewController:self];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoading || [self.movies count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        [self performSearch];
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - PerformSearch

- (void)performSearch
{
    [self.searchBar resignFirstResponder];
    
    [self.operationQueue cancelAllOperations];
    
    self.isLoading = YES;
    
    if (self.isLoading) {
        [self.tableView reloadData];
    }
    
    self.movies = [[NSMutableArray alloc] init];

    NSURL *url = [self URLFromSearchText];
    
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseDictionary:responseObject];
        [self.movies sortUsingSelector:@selector(sortedByAverageRating:)];
        self.isLoading = NO;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AFHTTPRequestOperation"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    [self.operationQueue addOperation:operation];
}

#pragma mark - GetURLFromSearchText

- (NSURL *)URLFromSearchText
{
    NSString *text = [self.searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@tag=%@", DouBanSearchURLString, text]];
    return url;
}

#pragma mark - ParseDictionaryToDataModel(Movie)

- (void)parseDictionary:(id)responseObject
{
    NSDictionary *dic = (NSDictionary *)responseObject;
    NSArray *results = dic[@"subjects"];
    for (NSDictionary *movieDic in results) {
        Movie *movie = [Movie MovieWithMovieDic:movieDic];
        if (movie != nil) {
            [self.movies addObject:movie];
        }
    }
}

@end

































