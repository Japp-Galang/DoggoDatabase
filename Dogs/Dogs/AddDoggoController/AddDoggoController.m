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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;


@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger age;
@property (strong, nonatomic) NSString *breed;
@property (nonatomic) NSInteger weight;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *breedField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;

@property (strong, nonatomic) IBOutlet UITextField *ownerFirstNameField;
@property (strong, nonatomic) IBOutlet UITextField *ownerLastNameField;
@property (strong, nonatomic) IBOutlet UITextField *ownerPhoneNumberField;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmailField;

@property (strong, nonatomic) UILabel* addedLabel;
@property (strong, nonatomic) CAShapeLayer *addedShapeLayer;

@property (strong, nonatomic) UILabel* invalidLabel;
@property (strong, nonatomic) CAShapeLayer *invalidShapeLayer;


@end

@implementation AddDoggoController
- (instancetype)init
{
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat centerX = screenWidth / 2;
    CGFloat leftAlignment = screenWidth / 10;
    
    // Initialize scroll view and content view
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 1.5);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 2.0)];
    
    
    // Check mark to display something has been added to database, not initally visible
    self.addedLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenHeight / 30 * 20, screenWidth / 2,  screenHeight/10)];
    self.addedLabel.text = @"Added!";
    self.addedLabel.textColor = [UIColor grayColor];
    self.addedLabel.font = [UIFont systemFontOfSize:screenHeight/20];
    self.addedLabel.center = CGPointMake(centerX, self.addedLabel.center.y);
    self.addedLabel.textAlignment = NSTextAlignmentCenter;
    CGRect addedBackground = CGRectMake(screenWidth / 4, screenHeight / 30 * 20,  screenWidth / 2, screenHeight / 10);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:addedBackground cornerRadius:15];
    self.addedShapeLayer = [CAShapeLayer layer];
    self.addedShapeLayer.path = path2.CGPath;
    self.addedShapeLayer.fillColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:0.5].CGColor;
    
    // Invalid input mark to display if there is invalid input, not initially visible
    self.invalidLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenHeight / 30 * 20, screenWidth / 2,  screenHeight/10)];
    self.invalidLabel.text = @"Invalid Input";
    self.invalidLabel.textColor = [UIColor blackColor];
    self.invalidLabel.font = [UIFont systemFontOfSize:screenHeight/40];
    self.invalidLabel.center = CGPointMake(centerX, self.addedLabel.center.y);
    self.invalidLabel.textAlignment = NSTextAlignmentCenter;
    self.invalidShapeLayer = [CAShapeLayer layer];
    self.invalidShapeLayer.path = path2.CGPath;
    self.invalidShapeLayer.fillColor = [UIColor colorWithRed:1.00 green:0.0 blue:0.0 alpha:0.75].CGColor;
    
    
    // Label for Name
    UILabel *enterDogNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 2.5, screenWidth / 2,  screenHeight/10)];
    enterDogNameLabel.text = @"Enter Dog Name";
    enterDogNameLabel.textColor = [UIColor blackColor];
    enterDogNameLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterDogNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterDogNameLabel];
    
    // Name for Dog
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 4, screenWidth / 10 * 8, screenHeight / 25)];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.placeholder = @"Enter Name";
    [self.contentView addSubview:self.nameField];
    
    
    // Label for Age
    UILabel *enterDogAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 4.5, screenWidth / 2,  screenHeight/10)];
    enterDogAgeLabel.text = @"Enter Dog Age";
    enterDogAgeLabel.textColor = [UIColor blackColor];
    enterDogAgeLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterDogAgeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterDogAgeLabel];
    
    // Age for Dog
    self.ageField = [[UITextField alloc] init];
    self.ageField.frame = CGRectMake(leftAlignment, screenHeight / 20 * 6, screenWidth / 10 * 8, screenHeight / 25);
    self.ageField.keyboardType = UIKeyboardTypeNumberPad;
    self.ageField.borderStyle = UITextBorderStyleRoundedRect;
    self.ageField.placeholder = @"Enter Age";
    [self.contentView addSubview:self.ageField];
    
    
    // Label for Breed
    UILabel *enterDogBreedLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 6.5, screenWidth / 2,  screenHeight/10)];
    enterDogBreedLabel.text = @"Enter Dog Breed";
    enterDogBreedLabel.textColor = [UIColor blackColor];
    enterDogBreedLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterDogBreedLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterDogBreedLabel];
    
    // Breed for Dog
    self.breedField = [[UITextField alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 8, screenWidth / 10 * 8, screenHeight / 25)];
    self.breedField.borderStyle = UITextBorderStyleRoundedRect;
    self.breedField.placeholder = @"Enter Breed";
    [self.contentView addSubview:self.breedField];
    
    
    // Label for Weight
    UILabel *enterDogWeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 8.5, screenWidth / 2,  screenHeight/10)];
    enterDogWeightLabel.text = @"Enter Dog Weight";
    enterDogWeightLabel.textColor = [UIColor blackColor];
    enterDogWeightLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterDogWeightLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterDogWeightLabel];
    
    // Weight for Dog
    self.weightField = [[UITextField alloc] init];
    self.weightField.frame = CGRectMake(leftAlignment, screenHeight / 20 * 10, screenWidth / 10 * 8, screenHeight / 25);
    self.weightField.keyboardType = UIKeyboardTypeNumberPad;
    self.weightField.borderStyle = UITextBorderStyleRoundedRect;
    self.weightField.placeholder = @"Enter Weight";
    [self.contentView addSubview:self.weightField];
    
    
#pragma mark - Owner details
    // Label for owner name
    UILabel *ownerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 10.5, screenWidth / 2,  screenHeight/10)];
    ownerNameLabel.text = @"Owner First Name";
    ownerNameLabel.textColor = [UIColor blackColor];
    ownerNameLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    ownerNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:ownerNameLabel];
    // Owner First Name field
    self.ownerFirstNameField = [[UITextField alloc] init];
    self.ownerFirstNameField.frame = CGRectMake(leftAlignment, screenHeight / 20 * 12, screenWidth / 10 * 4, screenHeight / 25);
    self.ownerFirstNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerFirstNameField.placeholder = @"Enter First Name";
    [self.contentView addSubview:self.ownerFirstNameField];
    // Owner Last Name field
    self.ownerLastNameField = [[UITextField alloc] init];
    self.ownerLastNameField.frame = CGRectMake(leftAlignment + screenWidth / 10 * 4.1, screenHeight / 20 * 12, screenWidth / 10 * 4, screenHeight / 25);
    self.ownerLastNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerLastNameField.placeholder = @"Enter Last Name";
    [self.contentView addSubview:self.ownerLastNameField];
    
    
    // Label for phone number
    UILabel *enterPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 12.5, screenWidth / 2,  screenHeight/10)];
    enterPhoneLabel.text = @"Phone Number";
    enterPhoneLabel.textColor = [UIColor blackColor];
    enterPhoneLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterPhoneLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterPhoneLabel];
    
    // Owner Phone number field
    self.ownerPhoneNumberField = [[UITextField alloc] init];
    self.ownerPhoneNumberField.frame = CGRectMake(leftAlignment, screenHeight / 20 * 14, screenWidth / 10 * 8, screenHeight / 25);
    self.ownerPhoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    self.ownerPhoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerPhoneNumberField.placeholder = @"Enter Phone Number";
    [self.contentView addSubview:self.ownerPhoneNumberField];
    
    
    // Label for email number
    UILabel *enterEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftAlignment, screenHeight / 20 * 14.5, screenWidth / 2,  screenHeight/10)];
    enterEmailLabel.text = @"Email Address";
    enterEmailLabel.textColor = [UIColor blackColor];
    enterEmailLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    enterEmailLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:enterEmailLabel];
    
    // Owner Phone number field
    self.ownerEmailField = [[UITextField alloc] init];
    self.ownerEmailField.frame = CGRectMake(leftAlignment, screenHeight / 20 * 16, screenWidth / 10 * 8, screenHeight / 25);
    self.ownerEmailField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerEmailField.placeholder = @"Enter Email Address";
    [self.contentView addSubview:self.ownerEmailField];
    
    // Gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.contentView addGestureRecognizer:tap];
    
    self.scrollView.contentSize = self.contentView.bounds.size;
    [self.scrollView addSubview:self.contentView];
    [self.view addSubview:self.scrollView];
     
    
    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect backShape = CGRectMake(0, 0, screenWidth, screenHeight/7);
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
    backButton.frame = CGRectMake(screenWidth / 15, screenHeight / 24 * 2, screenWidth / 6, screenHeight/20);
    backButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Save Button
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.layer.borderWidth = 1.0;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.layer.cornerRadius = 15.0;
    saveButton.frame = CGRectMake(screenWidth / 15 * 11.65, screenHeight / 24 * 2, screenWidth / 6, screenHeight/20);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:screenHeight/50];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveDog:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    
    // Title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, screenHeight / 30 * 1.75, screenWidth / 2,  screenHeight/10)];
    titleLabel.text = @"Add Dog";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:screenHeight/20];
    titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}



- (IBAction)saveDog:(id)sender
{
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
#pragma mark - Sanity check for inputs in fields
    NSMutableArray *sanityCheck = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, nil];
    
    // Name sanity check... Name needs to be more than 0 characters long and less than 12 characters long
    if ([self.nameField.text length] > 12 || [self.nameField.text length] == 0){
        NSLog(@"Name is too long or empty");
    } else {
        [sanityCheck replaceObjectAtIndex:0 withObject:@1];
    }
    
    // Age sanity check... ageField needs to contain only numbers and not empty
    NSCharacterSet *notNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self.ageField.text rangeOfCharacterFromSet:notNumbers].location != NSNotFound || [self.ageField.text length] == 0) {
        NSLog(@"Age contains a character that isn't a number ir empty");
    } else {
        [sanityCheck replaceObjectAtIndex:1 withObject:@1];
    }
    
    // Breed sanity check... breedField needs contain only numbers and have more than 0 characters
    if ([self.breedField.text stringByTrimmingCharactersInSet:notNumbers].length > 0 || [self.breedField.text length] == 0) {
        NSLog(@"Breed contains an illegal character or empty");
    } else {
        [sanityCheck replaceObjectAtIndex:2 withObject:@1];
    }
    
    // Weight sanity check... weightField needs to contain only numbers and not empty
    if ([self.weightField.text rangeOfCharacterFromSet:notNumbers].location != NSNotFound || [self.weightField.text length] == 0) {
        NSLog(@"Weight contains a character that isn't a number");

    } else {
        [sanityCheck replaceObjectAtIndex:3 withObject:@1];
    }
    
    NSLog(@"%@", sanityCheck);
    // Highlights the fields with invalid inputs
    if ([[sanityCheck objectAtIndex:0] isEqualToNumber:@0]){
        self.nameField.layer.borderWidth = 2.0;
        self.nameField.layer.borderColor = [UIColor redColor].CGColor;
    }
    if ([[sanityCheck objectAtIndex:1] isEqualToNumber:@0]){
        self.ageField.layer.borderWidth = 2.0;
        self.ageField.layer.borderColor = [UIColor redColor].CGColor;
    }
    if ([[sanityCheck objectAtIndex:2] isEqualToNumber:@0]){
        self.breedField.layer.borderWidth = 2.0;
        self.breedField.layer.borderColor = [UIColor redColor].CGColor;
    }
    if ([[sanityCheck objectAtIndex:3] isEqualToNumber:@0]){
        self.weightField.layer.borderWidth = 2.0;
        self.weightField.layer.borderColor = [UIColor redColor].CGColor;
    }
    
    
    // check for validity of all of the inputs to show corresponding label to the user if it's valid or invalid
    if([sanityCheck containsObject:@0]) {
        [self showInvalidInput];
    } else {
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
        
        [self showValidInput];
    }
}


// Displays message that the inputs are invalid
- (void)showInvalidInput
{
    [self.view.layer addSublayer:self.invalidShapeLayer];
    [self.view addSubview:self.invalidLabel];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(hideObject)
                                       userInfo:nil
                                        repeats:NO];
}

// Displays message that the inputs are validand the request to add the dog to the user has started
- (void)showValidInput
{
    [self.view.layer addSublayer:self.addedShapeLayer];
    [self.view addSubview:self.addedLabel];
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(hideObject)
                                       userInfo:nil
                                        repeats:NO];
}



/*
Hides labels to show valid or invalid input
 */
- (void)hideObject
{

    [self.addedLabel removeFromSuperview];
    [self.addedShapeLayer removeFromSuperlayer];
    
    [self.invalidLabel removeFromSuperview];
    [self.invalidShapeLayer removeFromSuperlayer];
}



- (void)dismissKeyboard {
    [self.contentView endEditing:YES];
}



-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
