//
//  AddDoggoController.m
//  Dogs
//
//  Created by Japp Galang on 1/29/23.
//

#import <Foundation/Foundation.h>
#import "AddDoggoController.h"
#import "DatabaseController.h"

@interface AddDoggoController ()

@property (nonatomic, strong) DatabaseController *dbController;

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger age;
@property (strong, nonatomic) NSString *breed;
@property (nonatomic) NSInteger weight;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *breedField;
@property (strong, nonatomic)IBOutlet UITextField *weightField;

@property (strong, nonatomic) UILabel* addedLabel;

@end

@implementation AddDoggoController
- (instancetype)init
{
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat centerX = self.view.frame.size.width / 2;
    CGFloat leftAlignment = self.view.frame.size.width / 10;
    
    // Check mark to display something has been added to database, not initally visible
    self.addedLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height / 30 * 20, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    self.addedLabel.text = @"Added!";
    self.addedLabel.textColor = [UIColor greenColor];
    self.addedLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    self.addedLabel.center = CGPointMake(centerX, self.addedLabel.center.y);
    self.addedLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect backShape = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/7);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:backShape ];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor systemBrownColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    
    
    // Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.layer.borderWidth = 1.0;
    backButton.layer.borderColor = [UIColor whiteColor].CGColor;
    backButton.layer.cornerRadius = 15.0;
    backButton.frame = CGRectMake(self.view.frame.size.width / 15, self.view.frame.size.height / 24 * 2, self.view.frame.size.width / 6, self.view.frame.size.height/20);
    backButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Save Button
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.layer.borderWidth = 1.0;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.layer.cornerRadius = 15.0;
    saveButton.frame = CGRectMake(self.view.frame.size.width / 15 * 11.65, self.view.frame.size.height / 24 * 2, self.view.frame.size.width / 6, self.view.frame.size.height/20);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveDog:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height / 30 * 1.75, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    titleLabel.text = @"Add Dog";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    // Label for Name
    UILabel *enterDogNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 2.5, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    enterDogNameLabel.text = @"Enter Dog Name";
    enterDogNameLabel.textColor = [UIColor blackColor];
    enterDogNameLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    enterDogNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:enterDogNameLabel];
    
    // Name for Dog
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 4, self.view.frame.size.width / 10 * 8, self.view.frame.size.height / 25)];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.placeholder = @"Enter Name";
    [self.view addSubview:self.nameField];
    
    
    // Label for Age
    UILabel *enterDogAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 4.5, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    enterDogAgeLabel.text = @"Enter Dog Age";
    enterDogAgeLabel.textColor = [UIColor blackColor];
    enterDogAgeLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    enterDogAgeLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:enterDogAgeLabel];
    
    // Age for Dog
    self.ageField = [[UITextField alloc] init];
    self.ageField.frame = CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 6, self.view.frame.size.width / 10 * 8, self.view.frame.size.height / 25);
    self.ageField.keyboardType = UIKeyboardTypeNumberPad;
    self.ageField.borderStyle = UITextBorderStyleRoundedRect;
    self.ageField.placeholder = @"Enter Age";
    [self.view addSubview:self.ageField];
    
    
    // Label for Breed
    UILabel *enterDogBreedLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 6.5, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    enterDogBreedLabel.text = @"Enter Dog Breed";
    enterDogBreedLabel.textColor = [UIColor blackColor];
    enterDogBreedLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    enterDogBreedLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:enterDogBreedLabel];
    
    // Breed for Dog
    self.breedField = [[UITextField alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 8, self.view.frame.size.width / 10 * 8, self.view.frame.size.height / 25)];
    self.breedField.borderStyle = UITextBorderStyleRoundedRect;
    self.breedField.placeholder = @"Enter Breed";
    [self.view addSubview:self.breedField];
    
    
    // Label for Weight
    UILabel *enterDogWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 8.5, self.view.frame.size.width / 2,  self.view.frame.size.height/10)];
    enterDogWeightLabel.text = @"Enter Dog Weight";
    enterDogWeightLabel.textColor = [UIColor blackColor];
    enterDogWeightLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    enterDogWeightLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:enterDogWeightLabel];
    
    // Weight for Dog
    self.weightField = [[UITextField alloc] init];
    self.weightField.frame = CGRectMake(leftAlignment, self.view.frame.size.height / 20 * 10, self.view.frame.size.width / 10 * 8, self.view.frame.size.height / 25);
    self.weightField.keyboardType = UIKeyboardTypeNumberPad;
    self.weightField.borderStyle = UITextBorderStyleRoundedRect;
    self.weightField.placeholder = @"Enter Weight";
    [self.view addSubview:self.weightField];
}


- (IBAction)saveDog:(id)sender
{
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    self.name = self.nameField.text;
    self.age = [self.ageField.text integerValue];
    self.breed = self.breedField.text;
    self.weight = [self.weightField.text integerValue];
    NSLog(@"the name of the dog you are adding is: %@", self.nameField.text);
    [dbController addDog:_name age:_age breed:_breed weight:_weight dateAdded:[NSDate date]];
    
    self.nameField.text = @"";
    self.ageField.text = @"";
    self.breedField.text = @"";
    self.weightField.text = @"";
    
    [self.view addSubview:self.addedLabel];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(hideObject)
                                       userInfo:nil
                                        repeats:NO];
    
}


- (void)hideObject {
    // Hide the object
    [self.addedLabel removeFromSuperview];
}



-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
