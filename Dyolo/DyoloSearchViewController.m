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
#import <AFNetworking/AFHTTPRequestOperation.h>

static NSString *const DouBanSearchURLString = @"https://api.douban.com/v2/movie/search?";
static NSString *const MovieCellIdentifier = @"MovieCell";

@interface DyoloSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableArray *movies;

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
    if (!self.movies) {
        return 0;
    }
    
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *movieCell = [tableView dequeueReusableCellWithIdentifier:MovieCellIdentifier
                                                           forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];
    
    [movieCell configurateCellWithMovie:movie];
    
    return movieCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
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
    
    self.movies = [[NSMutableArray alloc] init];

    NSURL *url = [self URLFromSearchText];
    
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:URLRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseDictionary:responseObject];
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
//        NSLog(@"%@ %@ %@ %@",movie.title, movie.averageRating, movie.directorsName, movie.actorName);
    }
}

@end

































