//
//  ViewController.h
//  Dogs
//
//  Created by Japp Galang on 1/28/23.
//

#import <UIKit/UIKit.h>
#import "ViewUpdateController.h"
#import "AddDoggoController.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) AddDoggoController *addDoggoController;
@property (nonatomic, strong) ViewUpdateController *updateController;

- (void)viewDidLoad;

- (IBAction)goToUpdateView:(id)sender;
- (IBAction)goToAddDoggoView:(id)sender;
- (IBAction)showItems:(id)sender;

@end

