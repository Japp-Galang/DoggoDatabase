//
//  MyTableViewCell.m
//  Dogs
//
//  Created by Japp Galang on 1/31/23.
//

#import "MyTableViewCell.h"
#import "CustomRowController.h"



@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.weightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.breedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.ageLabel];
        [self.contentView addSubview:self.breedLabel];
        [self.contentView addSubview:self.weightLabel];
        
        [self.contentView addSubview:self.editButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentBounds = self.contentView.bounds;
    CGFloat labelWidth = contentBounds.size.width / 4;
    CGFloat labelHeight = contentBounds.size.height;
    CGFloat tableLeftAlignment = contentBounds.size.width / 20;
    
    self.nameLabel.frame = CGRectMake(0 + tableLeftAlignment, 0, labelWidth, labelHeight);
    self.ageLabel.frame = CGRectMake(labelWidth, 0, labelWidth, labelHeight);
    self.breedLabel.frame = CGRectMake(labelWidth * 2 - tableLeftAlignment * 3, 0, labelWidth * 1.2, labelHeight);
    self.weightLabel.frame = CGRectMake(labelWidth * 3 - tableLeftAlignment, 0, labelWidth, labelHeight);
    
    // Edit Button
    [self.editButton setTitle:@"✎" forState:UIControlStateNormal];
    self.editButton.layer.cornerRadius = 15.0;
    self.editButton.frame = CGRectMake(contentBounds.size.width - tableLeftAlignment * 2, 0, labelWidth / 4, labelHeight);
    [self.editButton addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
}



-(IBAction)selectRow:(id)sender
{
    self.customRowController = [[CustomRowController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.customRowController];
    
    self.customRowController.ident = self.ident;
    self.customRowController.name = self.nameLabel.text;
    self.customRowController.age = self.ageLabel.text;
    self.customRowController.breed = self.breedLabel.text;
    self.customRowController.weight = self.weightLabel.text;
    self.customRowController.dateAdded = self.dateAdded;
    
    [self.parentViewController presentViewController:navigationController animated:YES completion:nil];
    
}



@end
