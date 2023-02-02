//
//  ViewUpdateController.m
//  Dogs
//
//  Created by Japp Galang on 1/28/23.
//

#import <Foundation/Foundation.h>
#import "ViewUpdateController.h"
#import "DatabaseController.h"
#import "MyTableViewCell.h"


@interface ViewUpdateController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DatabaseController *dbController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewUpdateController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect tableViewFrame = CGRectMake(0, self.view.frame.size.height / 30 * 6, self.view.frame.size.width, self.view.frame.size.height);
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    self.dataArray = [dbController getAllDogs];
    [self.tableView reloadData];
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyCell"];
    [self.view addSubview:self.tableView];
    
    
    CGFloat centerX = self.view.frame.size.width / 2;
    
    CGFloat alignmentConstant = self.view.frame.size.width / 20;
    CGFloat labelWidth = self.view.frame.size.width / 4;
    
    // Background
    self.view.backgroundColor = [UIColor systemBrownColor];
    
    
    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
   
    backButton.layer.borderWidth = 2.0;
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.cornerRadius = 15.0;
    backButton.frame = CGRectMake(self.view.frame.size.width / 15, self.view.frame.size.height / 24 * 2, self.view.frame.size.width / 6, self.view.frame.size.height/20);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:self.view.frame.size.height/50];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height / 30 * 1.75, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    titleLabel.text = @"Dogs";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    // Genres
    // Name
    UILabel *nameGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + alignmentConstant, self.view.frame.size.height / 30 * 4 , self.view.frame.size.width / 4,  self.view.frame.size.height/10)];
    nameGenreLabel.text = @"Name";
    nameGenreLabel.textColor = [UIColor whiteColor];
    nameGenreLabel.font = [UIFont boldSystemFontOfSize:self.view.frame.size.height/50];
    nameGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameGenreLabel];
    
    // Age
    UILabel *ageGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, self.view.frame.size.height / 30 * 4 , self.view.frame.size.width / 4,  self.view.frame.size.height/10)];
    ageGenreLabel.text = @"Age";
    ageGenreLabel.textColor = [UIColor whiteColor];
    ageGenreLabel.font = [UIFont boldSystemFontOfSize:self.view.frame.size.height/50];
    ageGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:ageGenreLabel];
    
    
    // Breed
    UILabel *breedGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 2 - alignmentConstant * 3, self.view.frame.size.height / 30 * 4 , self.view.frame.size.width / 4,  self.view.frame.size.height/10)];
    breedGenreLabel.text = @"Breed";
    breedGenreLabel.textColor = [UIColor whiteColor];
    breedGenreLabel.font = [UIFont boldSystemFontOfSize:self.view.frame.size.height/50];
    breedGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:breedGenreLabel];
    
    
    // Weight
    UILabel *weightGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 3 - alignmentConstant, self.view.frame.size.height / 30 * 4 , self.view.frame.size.width / 4,  self.view.frame.size.height/10)];
    weightGenreLabel.text = @"Weight (lbs)";
    weightGenreLabel.textColor = [UIColor whiteColor];
    weightGenreLabel.font = [UIFont boldSystemFontOfSize:self.view.frame.size.height/50];
    weightGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:weightGenreLabel];
}


- (void)updateValues
{
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    self.dataArray = [dbController getAllDogs];
    [self.tableView reloadData];
    CGRect tableViewFrame = CGRectMake(0, self.view.frame.size.height / 30 * 6, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyCell"];
    [self.view addSubview:self.tableView];
    NSLog(@"Passed Through viewDidAppear");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dogDict = self.dataArray[indexPath.row];
    
    cell.ident = [NSString stringWithFormat:@"%@", dogDict[@"ID"]];
    cell.nameLabel.text = dogDict[@"name"];
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", dogDict[@"age"]];
    cell.weightLabel.text = [NSString stringWithFormat:@"%@", dogDict[@"weight"]];
    cell.breedLabel.text = dogDict[@"breed"];
    cell.dateAdded = dogDict[@"dateAdded"];
    
    cell.parentViewController = self;
    
    
    return cell;
}



-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
