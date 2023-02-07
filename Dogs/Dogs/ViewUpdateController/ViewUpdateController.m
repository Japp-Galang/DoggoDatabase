//
//  ViewUpdateController.m
//  Dogs
//
//  Created by Japp Galang on 1/28/23.
//

#import <Foundation/Foundation.h>
#import "ViewUpdateController.h"
#import "DatabaseController.h"
#import "DogViewCell.h"


@interface ViewUpdateController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DatabaseController *dbController;


@property (nonatomic, strong) UITableView *dogsTableView;
@property (nonatomic, strong) NSArray *dogsDataArray;
@property (nonatomic) UIView *dogColumns;

@property (nonatomic, strong) UITableView *ownersTableView;
@property (nonatomic, strong) NSArray *ownersDataArray;
@property (nonatomic) UIView *ownersColumns;

@property (nonatomic, strong) UIButton *titleButton;


@end

@implementation ViewUpdateController


- (instancetype)init
{
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    // Screen constants
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat centerX = screenWidth / 2;
    CGFloat alignmentConstant = screenWidth / 20;
    CGFloat labelWidth = screenWidth / 4;
    CGRect tableViewFrame = CGRectMake(0, screenHeight / 30 * 6, screenWidth, screenHeight);
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    // Table data initialization
    // initialize tableView for dogs
    self.dogsDataArray = [dbController getAllDogs];
    [self.dogsTableView reloadData];
    self.dogsTableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.dogsTableView.dataSource = self;
    [self.dogsTableView registerClass:[DogViewCell class] forCellReuseIdentifier:@"DogCell"];
    [self.view addSubview:self.dogsTableView];
    
    
    
    // Background
    self.view.backgroundColor = [UIColor systemBrownColor];
    
    
//Navigation Menu items
    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.borderWidth = 1.0;
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.cornerRadius = 15.0;
    backButton.frame = CGRectMake(screenWidth / 15, screenHeight / 24 * 2, screenWidth / 6, screenHeight/20);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:screenHeight/50];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Refresh Button
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refreshIcon"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(screenWidth / 15 * 12,screenHeight / 24 * 2.2, screenWidth / 12, screenHeight/30);
    [refreshButton addTarget:self action:@selector(updateValues) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
    // Title (toggles on tap between Dogs or Owners)
    self.titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.titleButton.frame = CGRectMake(100, screenHeight / 30 * 1.75, screenWidth / 2,  screenHeight/10);
    self.titleButton.center = CGPointMake(centerX, self.titleButton.center.y);
    self.titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:screenHeight/20];
    [self.titleButton setTitle:@"Dogs" forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.titleButton];
    
    
// initialize column names for dogs and owners
    CGRect frame = CGRectMake(0, 0 , screenWidth,  screenHeight);
    self.dogColumns = [[UIView alloc] initWithFrame:frame];
    self.dogColumns.userInteractionEnabled = NO;
    // Dog Columns
    // Name
    UILabel *nameGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + alignmentConstant, screenHeight / 30 * 4 , screenWidth / 4,  screenHeight/10)];
    nameGenreLabel.text = @"Name";
    nameGenreLabel.textColor = [UIColor whiteColor];
    nameGenreLabel.font = [UIFont boldSystemFontOfSize:screenHeight/50];
    nameGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.dogColumns addSubview:nameGenreLabel];
    
    // Age
    UILabel *ageGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, screenHeight / 30 * 4 , screenWidth / 4,  screenHeight/10)];
    ageGenreLabel.text = @"Age";
    ageGenreLabel.textColor = [UIColor whiteColor];
    ageGenreLabel.font = [UIFont boldSystemFontOfSize:screenHeight/50];
    ageGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.dogColumns addSubview:ageGenreLabel];
    
    // Breed
    UILabel *breedGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 2 - alignmentConstant * 3, screenHeight / 30 * 4 , screenWidth / 4,  screenHeight/10)];
    breedGenreLabel.text = @"Breed";
    breedGenreLabel.textColor = [UIColor whiteColor];
    breedGenreLabel.font = [UIFont boldSystemFontOfSize:screenHeight/50];
    breedGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.dogColumns addSubview:breedGenreLabel];
    
    // Weight
    UILabel *weightGenreLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * 3 - alignmentConstant, screenHeight / 30 * 4 , screenWidth / 4, screenHeight / 10)];
    weightGenreLabel.text = @"Weight (lbs)";
    weightGenreLabel.textColor = [UIColor whiteColor];
    weightGenreLabel.font = [UIFont boldSystemFontOfSize:screenHeight/50];
    weightGenreLabel.textAlignment = NSTextAlignmentLeft;
    [self.dogColumns addSubview:weightGenreLabel];
    
    [self.view addSubview:self.dogColumns];
    
    // Owner Columns
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dogsDataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.titleButton.titleLabel.text isEqualToString: @"Dogs"]){
        static NSString *CellIdentifier = @"DogCell";
        DogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[DogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *dogDict = self.dogsDataArray[indexPath.row];
        
        cell.ident = [NSString stringWithFormat:@"%@", dogDict[@"ID"]];
        cell.nameLabel.text = dogDict[@"name"];
        cell.ageLabel.text = [NSString stringWithFormat:@"%@", dogDict[@"age"]];
        cell.weightLabel.text = [NSString stringWithFormat:@"%@", dogDict[@"weight"]];
        cell.breedLabel.text = dogDict[@"breed"];
        cell.dateAdded = dogDict[@"dateAdded"];
        
        cell.parentViewController = self;
        return cell;
    } else {
        static NSString *CellIdentifier = @"DogCell";
        DogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[DogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSLog(@"Not Dogs");
        return cell;
    }
    
}


#pragma mark - for switching entity views (Dogs or Owners)
- (void)buttonTapped
{
    if([self.titleButton.titleLabel.text isEqualToString: @"Dogs"]){
        // switching from Owners to Dogs
        
        // Adding compononents for Owner
        self.view.backgroundColor = [UIColor systemBlueColor];
        [self.titleButton setTitle:@"Owners" forState:UIControlStateNormal];
        // - Need to implement ownerTableView
        // - Need to implement ownerColumns
        
        // Removing components of Dog
        [self.dogsTableView removeFromSuperview];
        [self.dogColumns removeFromSuperview];
        
        
    } else {
        // switching from Dogs to Owners
        
        
        // Adding Components for Dog
        self.view.backgroundColor = [UIColor systemBrownColor];
        [self.titleButton setTitle:@"Dogs" forState:UIControlStateNormal];
        [self.view addSubview:self.dogsTableView];
        [self.view addSubview:self.dogColumns];
        
        
        // Removing components of Owner
        // - Remove ownerTableView from superView
        // - Remove ownerColumns from superView
    }
    
}





#pragma mark - actions for top buttons

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)updateValues
{
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    self.dogsDataArray = [dbController getAllDogs];
    [self.dogsTableView reloadData];
    CGRect tableViewFrame = CGRectMake(0, self.view.frame.size.height / 30 * 6, self.view.frame.size.width, self.view.frame.size.height);
    self.dogsTableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.dogsTableView.dataSource = self;
    [self.dogsTableView registerClass:[DogViewCell class] forCellReuseIdentifier:@"DogCell"];
    [self.view addSubview:self.dogsTableView];
    NSLog(@"Passed Through viewDidAppear");
}


@end
