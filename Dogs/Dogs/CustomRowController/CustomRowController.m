//
//  CustomRowController.m
//  Dogs
//
//  Created by Japp Galang on 1/31/23.
//

#import <Foundation/Foundation.h>
#import "CustomRowController.h"
#import "ViewController.h"
#import "DatabaseController.h"
#import "ViewUpdateController.h"
#import "ViewImagesController.h"


/*
 Need to be able to update ViewUpdateController after making change as well as this view when making a change
 */

@interface CustomRowController () 

@property (strong, nonatomic) IBOutlet UITextField *changeValueField;
@property (strong, nonatomic) NSString *updatedValue;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *updateButton;
@property (strong, nonatomic) NSString *currentlyUpdatingColumn;
@property (nonatomic) bool updatingColumnIsString;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *identLabel;
@property (strong, nonatomic) UILabel *ageLabel;
@property (strong, nonatomic) UILabel *breedLabel;
@property (strong, nonatomic) UILabel *weightLabel;


@property (nonatomic, strong) ViewUpdateController *previousView;

@end

@implementation CustomRowController



- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    CGFloat alignmentConstant = self.view.frame.size.width / 20;
    
    // Change value field that appears when editing, initially not visible
    self.changeValueField = [[UITextField alloc] init];
    self.changeValueField.frame = CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 14, self.view.frame.size.width - alignmentConstant * 8,  self.view.frame.size.height/10 /2);
    self.changeValueField.borderStyle = UITextBorderStyleRoundedRect;
    // Cancel Button that appears when editing, initially not visible
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
    self.cancelButton.layer.borderWidth = 2.0;
    self.cancelButton.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelButton.layer.cornerRadius = 15.0;
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width - alignmentConstant * 6, self.view.frame.size.height / 20 * 14, alignmentConstant * 1.5,  self.view.frame.size.height/10 /2 );
    [self.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(hideUpdaterObjects) forControlEvents:UIControlEventTouchUpInside];
    // Update Button that appears when editing an attribute, initially not visible
    self.updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.updateButton setTitle:@"✓" forState:UIControlStateNormal];
    self.updateButton.layer.borderWidth = 2.0;
    self.updateButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.updateButton.layer.cornerRadius = 15.0;
    self.updateButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    self.updateButton.frame = CGRectMake(self.view.frame.size.width - alignmentConstant * 4.4, self.view.frame.size.height / 20 * 14, alignmentConstant * 1.5,  self.view.frame.size.height/10 /2 );
    [self.updateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(updateField:) forControlEvents:UIControlEventTouchUpInside];
    

    // Background
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Arrow to slide down
    UIImage *arrowSlideDown = [UIImage imageNamed:@"ArrowToSlide"];
    UIImageView *arrowSlideDownView = [[UIImageView alloc] initWithImage:arrowSlideDown];
    arrowSlideDownView.transform = CGAffineTransformMakeRotation(M_PI_2);
    arrowSlideDownView.frame = CGRectMake(0, self.view.frame.size.height / 40, self.view.frame.size.width / 3, self.view.frame.size.height / 35);
    arrowSlideDownView.center = CGPointMake(self.view.frame.size.width / 2, arrowSlideDownView.center.y);
    [self.view addSubview:arrowSlideDownView];
    
    
    // Name
    // Title
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 20, self.view.frame.size.width,  self.view.frame.size.height/10)];
    self.nameLabel.text = self.name;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/20];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.center = CGPointMake(self.view.frame.size.width / 2, self.nameLabel.center.y);
    [self.view addSubview:self.nameLabel];
    
    
    // Identification Label
    self.identLabel = [[UILabel alloc] initWithFrame:CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 3, self.view.frame.size.width - alignmentConstant,  self.view.frame.size.height/10)];
    self.identLabel.text = [NSString stringWithFormat:@"ID: %@", self.ident];
    self.identLabel.textColor = [UIColor blackColor];
    self.identLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    self.identLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.identLabel];
    
    // Age Label
    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 4, self.view.frame.size.width - alignmentConstant,  self.view.frame.size.height/10)];
    self.ageLabel.text = [NSString stringWithFormat:@"Age: %@ Years Old", self.age];
    self.ageLabel.textColor = [UIColor blackColor];
    self.ageLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    self.ageLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.ageLabel];
    
    // Breed Label
    self.breedLabel = [[UILabel alloc] initWithFrame:CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 5, self.view.frame.size.width - alignmentConstant,  self.view.frame.size.height/10)];
    self.breedLabel.text = [NSString stringWithFormat:@"Breed: %@", self.breed];
    self.breedLabel.textColor = [UIColor blackColor];
    self.breedLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    self.breedLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.breedLabel];
    
    // Weight Label
    self.weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 6, self.view.frame.size.width - alignmentConstant,  self.view.frame.size.height/10)];
    self.weightLabel.text = [NSString stringWithFormat:@"Weight: %@ pounds", self.weight];
    self.weightLabel.textColor = [UIColor blackColor];
    self.weightLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    self.weightLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.weightLabel];
    
    
    // Date Added Label
    UILabel *dateAddedLabel = [[UILabel alloc] initWithFrame:CGRectMake(alignmentConstant * 2, self.view.frame.size.height / 20 * 7, self.view.frame.size.width - alignmentConstant,  self.view.frame.size.height/10)];
    dateAddedLabel.text = [NSString stringWithFormat:@"Date Added: %@", self.dateAdded];
    dateAddedLabel.textColor = [UIColor blackColor];
    dateAddedLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    dateAddedLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:dateAddedLabel];
    
    
    // Edit Name Button
    UIButton *editNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editNameButton setTitle:@"✎" forState:UIControlStateNormal];
    editNameButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/40];
    editNameButton.frame = CGRectMake(alignmentConstant, self.view.frame.size.height / 20, self.view.frame.size.width/30, self.view.frame.size.height/10);
    [editNameButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:editNameButton];
    [editNameButton addTarget:self action:@selector(openUpdateNameField:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Edit Age Button
    UIButton *editAgeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editAgeButton setTitle:@"✎" forState:UIControlStateNormal];
    editAgeButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    editAgeButton.frame = CGRectMake(alignmentConstant * .75, self.view.frame.size.height / 20 * 4.5, self.view.frame.size.width/30, self.view.frame.size.height/20);
    [editAgeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:editAgeButton];
    [editAgeButton addTarget:self action:@selector(openUpdateAgeField:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Edit Breed Button
    UIButton *editBreedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editBreedButton setTitle:@"✎" forState:UIControlStateNormal];
    editBreedButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    editBreedButton.frame = CGRectMake(alignmentConstant * .75, self.view.frame.size.height / 20 * 5.5, self.view.frame.size.width/30, self.view.frame.size.height/20);
    [editBreedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:editBreedButton];
    [editBreedButton addTarget:self action:@selector(openUpdateBreedField:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Edit Weight Button
    UIButton *editWeightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editWeightButton setTitle:@"✎" forState:UIControlStateNormal];
    editWeightButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    editWeightButton.frame = CGRectMake(alignmentConstant * .75, self.view.frame.size.height / 20 * 6.5, self.view.frame.size.width/30, self.view.frame.size.height/20);
    [editWeightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:editWeightButton];
    [editWeightButton addTarget:self action:@selector(openUpdateWeightField:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Delete Button
    UIButton *deleteRowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteRowButton setTitle:@"DELETE" forState:UIControlStateNormal];
    deleteRowButton.layer.borderWidth = 2.0;
    deleteRowButton.layer.borderColor = [UIColor redColor].CGColor;
    deleteRowButton.layer.cornerRadius = 15.0;
    deleteRowButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/60];
    deleteRowButton.frame = CGRectMake(alignmentConstant * .5, self.view.frame.size.height / 20 * 10, self.view.frame.size.width/5, self.view.frame.size.height/20);
    [deleteRowButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteRowButton addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteRowButton];
    
    // View Images Button
    UIButton *viewImagesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [viewImagesButton setTitle:@"View Images" forState:UIControlStateNormal];
    viewImagesButton.layer.borderWidth = 2.0;
    viewImagesButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    viewImagesButton.layer.cornerRadius = 15.0;
    viewImagesButton.titleLabel.font = [UIFont systemFontOfSize:self.view.frame.size.height/50];
    viewImagesButton.frame = CGRectMake(alignmentConstant * .5, self.view.frame.size.height / 20 * 12, self.view.frame.size.width/3, self.view.frame.size.height/20);
    [viewImagesButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [viewImagesButton addTarget:self action:@selector(goToViewImagesView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewImagesButton];
}


- (IBAction)deleteRow:(id)sender
{
    
    DatabaseController *dbController = [DatabaseController sharedInstance];
    [dbController deleteRowFromDog:self.ident];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



- (IBAction)openUpdateNameField:(id)sender
{
    self.changeValueField.placeholder = @"Update Name";
    self.currentlyUpdatingColumn = @"name";
    self.updatingColumnIsString = YES;
    [self.view addSubview:self.changeValueField];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.updateButton];
}



- (IBAction)openUpdateAgeField:(id)sender
{
    self.changeValueField.placeholder = @"Update Age";
    self.currentlyUpdatingColumn = @"age";
    self.updatingColumnIsString = NO;
    [self.view addSubview:self.changeValueField];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.updateButton];
}



- (IBAction)openUpdateBreedField:(id)sender
{
    self.changeValueField.placeholder = @"Update Breed";
    self.currentlyUpdatingColumn = @"breed";
    self.updatingColumnIsString = YES;
    [self.view addSubview:self.changeValueField];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.updateButton];
}




- (IBAction)openUpdateWeightField:(id)sender
{
    self.changeValueField.placeholder = @"Update Weight";
    self.currentlyUpdatingColumn = @"weight";
    self.updatingColumnIsString = NO;
    [self.view addSubview:self.changeValueField];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.updateButton];
}



- (void)hideUpdaterObjects
{
    [self.cancelButton removeFromSuperview];
    [self.changeValueField removeFromSuperview];
    [self.updateButton removeFromSuperview];
}



- (IBAction)updateField:(id)sender
{
    DatabaseController *dbController = [DatabaseController sharedInstance];
    
    self.updatedValue = self.changeValueField.text;
    NSLog(@"Updated value: %@", self.updatedValue);
    if(self.updatingColumnIsString){
        [dbController updateTable:@"Dog" column:self.currentlyUpdatingColumn newValue: [NSString stringWithFormat:@"\"%@\"", self.updatedValue] ident:[NSString stringWithFormat:@"%@", self.ident]];
    } else {
        [dbController updateTable:@"Dog" column:self.currentlyUpdatingColumn newValue:[NSString stringWithFormat:@"%@", self.updatedValue] ident:[NSString stringWithFormat:@"%@", self.ident]];
    }
    self.changeValueField.text = @"";
    [self hideUpdaterObjects];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



- (IBAction)goToViewImagesView:(id)sender
{
    self.viewImagesController = [[ViewImagesController alloc] init];
    self.viewImagesController.dogName = self.name;
    self.viewImagesController.ident = self.ident;
    [self presentViewController:self.viewImagesController animated: YES completion:nil];
    
}



@end
