//
//  TrackEatingViewController.m
//  quinoa
//
//  Created by Chirag Davé on 7/12/14.
//  Copyright (c) 2014 3eesho. All rights reserved.
//

#import "TrackEatingViewController.h"
#import "Activity.h"

@interface TrackEatingViewController ()

@property (strong, nonatomic) UIImagePickerController *camera;
- (IBAction)onTap:(id)sender;

@end

@implementation TrackEatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
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

- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithData:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [Activity trackEating:imageFile description:@"STUB DESCRIPTION"];
        } else {
            NSLog(@"Couldn't save file");
        }
    }];
}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Grab the image that was selected
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    // Dismiss the image picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}
@end
