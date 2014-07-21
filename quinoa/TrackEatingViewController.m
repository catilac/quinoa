//
//  TrackEatingViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "TrackEatingViewController.h"
#import "Activity.h"
#import "UILabel+QuinoaLabel.h"
#import "TrackButton.h"

@interface TrackEatingViewController ()

@property (strong, nonatomic) UIImagePickerController *camera;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (strong, nonatomic) NSData *imageData;
@property (assign) Boolean imageSet;
@property (strong, nonatomic) UITextField *descriptionField;

- (IBAction)onTap:(id)sender;

@end

@implementation TrackEatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self
                                                                                action:@selector(onCancel)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(uploadPhoto)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    [super willMoveToParentViewController:parent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    if (!self.imageSet) {
        // Capture a photo
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera] == YES){
            // Create image picker controller
            self.camera = [[UIImagePickerController alloc] init];
            
            // Set source to the camera
            self.camera.sourceType =  UIImagePickerControllerSourceTypeCamera;
            
            // Delegate is self
            self.camera.delegate = self;
            
            // Show image picker
            [self presentViewController:self.camera animated:YES completion:nil];
        }
    } else if ([self.descriptionField isDescendantOfView:self.view]) {
        [self.descriptionField endEditing:YES];
        if ([self.descriptionField.text length] == 0) {
            [self.descriptionField removeFromSuperview];
        }
    } else {
        // Create a caption
        self.descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
        [self.descriptionField setTextColor:[UIColor whiteColor]];
        [self.descriptionField setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:self.descriptionField];
        [self.descriptionField becomeFirstResponder];
    }
}

- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSString *description = nil;
            if (self.descriptionField != nil) {
                description = self.descriptionField.text;
            }
            [Activity trackEating:imageFile
                      description:description
                         callback:^(BOOL succeeded, NSError *error) {
                             [self dismissModalAndCloseFanOutMenu];
                         }];
        } else {
            NSLog(@"Couldn't save file");
        }
    }];
}

- (void)onCancel {
    NSLog(@"Hit Cancel");
    [self dismissModalAndCloseFanOutMenu];
}

- (void)uploadPhoto {
    if (self.imageSet) {
        [self uploadImage:self.imageData];
    }
}

- (void) dismissModalAndCloseFanOutMenu {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseMenu object:nil];
}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Grab the image that was selected
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    // Dismiss the image picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageData = UIImageJPEGRepresentation(image, 0.05f);
    self.imagePreview.image = [UIImage imageWithData:self.imageData];
    self.imageSet = YES;
}
@end
