//
//  MyTableViewCell.h
//  Dogs
//
//  Created by Japp Galang on 1/31/23.
//

#import <UIKit/UIKit.h>
#import "CustomRowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *breedLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *dateAdded;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) CustomRowController *customRowController;

@property (nonatomic, weak) UIViewController *parentViewController;


-(IBAction)selectRow:(id)sender;

@end

NS_ASSUME_NONNULL_END
