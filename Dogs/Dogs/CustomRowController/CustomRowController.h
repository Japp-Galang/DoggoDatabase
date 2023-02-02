//
//  CustomRowController.h
//  Dogs
//
//  Created by Japp Galang on 1/31/23.
//

#import <UIKit/UIKit.h>


@interface CustomRowController : UIViewController

- (void)viewDidLoad;



// Dog Attributes for display
@property (nonatomic, strong) NSString* ident;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* age;
@property (nonatomic, strong) NSString* breed;
@property (nonatomic, strong) NSString* weight;
@property (nonatomic, strong) NSString* dateAdded;


-(IBAction)deleteRow:(id)sender;


@end
