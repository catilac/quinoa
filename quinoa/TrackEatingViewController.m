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
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainer;

@property (assign) Boolean imageSet;

- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;

- (IBAction)onEndEditing:(UITapGestureRecognizer *)sender;


//- (IBAction)tappedSendButton:(id)sender;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Track Diet";
    
    // Do any additional setup after loading the view from its nib.
    // I can only make the navigation bar opaque by setting it on each page
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    [self.imagePreview removeFromSuperview];
    self.imagePreview = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.imageData]];
    [self.imagePreview setContentMode:UIViewContentModeScaleAspectFill];
    [self.imagePreview setClipsToBounds:TRUE];
    
    // TODO find a way to calculate this programmatically
    self.imagePreview.frame = CGRectMake(0, 0, 280, 280);
    
    [self.imagePreviewContainer addSubview:self.imagePreview];
    [self.imagePreviewContainer sendSubviewToBack:self.imagePreview];
    self.imageSet = YES;
    
    // Set font to description text
    [self.descriptionTextField setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size: 18.0f]];

    

}

- (void)viewDidAppear:(BOOL)animated{
    
    //[self takePictureMode];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    [super willMoveToParentViewController:parent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) takePictureMode{
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

}

- (IBAction)onEndEditing:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
}

// I don't think we need this now. Let's consolidate all submit actions to the nav bar.

//- (IBAction)tappedSendButton:(id)sender {
//    if (![self.descriptionTextField.text isEqual:@""] ) {
//        [self uploadPhoto];
//    }
//}

- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSString *description = nil;
            if (self.descriptionTextField != nil) {
                description = self.descriptionTextField.text;
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
    [self.imagePreview removeFromSuperview];
    self.imagePreview = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.imageData]];
    self.imagePreview.frame = self.imagePreviewContainer.frame;

    [self.imagePreviewContainer addSubview:self.imagePreview];
    [self.imagePreviewContainer sendSubviewToBack:self.imagePreview];
    self.imageSet = YES;
}

- (void)willShowKeyboard:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.descriptionContainer.frame = CGRectMake(0, 236, self.descriptionContainer.frame.size.width, self.descriptionContainer.frame.size.height);
                     }
                     completion:nil];
    
}

- (void)willHideKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.descriptionContainer.frame = CGRectMake(0, 320, self.descriptionContainer.frame.size.width, self.descriptionContainer.frame.size.height);
                     }
                     completion:nil];
    
}






- (IBAction)textFieldDismiss:(id)sender {
    
    [self.descriptionTextField resignFirstResponder];
}
@end
