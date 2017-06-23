//
//  CXGameViewController.m
//  AstroKit
//
//  Created by Owatch on 5/27/15.
//  Copyright (c) 2015 Unisung Softworks. All rights reserved.
//

#import "CXGameViewController.h"

static NSString *kViewTransformChanged = @"view transform changed";

@interface CXGameViewController ()
@property (nonatomic)CGSize contentSize;
@end

@implementation CXGameViewController

#pragma mark CXGameViewController Default Methods
-(void)loadView
{
    [super loadView];
    
    SKView *gameView = [[SKView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self setView:gameView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *gameView = (SKView *)self.view;
    
    // Official Content Size:
    CGSize contentSize = CGSizeMake([gameView bounds].size.height * 3, [gameView bounds].size.height * 3);
    [self setContentSize:contentSize];
    
    
    CXScene *gameScene = [[CXScene alloc]initWithSize:[gameView bounds].size];
    [gameScene setScaleMode:SKSceneScaleModeAspectFit];
    [gameScene setMyDelegate:self];
    [gameScene setContentSize:contentSize];
    [self setGameScene:gameScene];
    
    CXGameScrollView *scrollView = [[CXGameScrollView alloc]initWithFrame:gameView.frame];
    [scrollView setContentSize:contentSize];
    [scrollView setGameScene:gameScene];
    [scrollView setDelegate:self];
    [scrollView setBounces:NO];
    [scrollView setMinimumZoomScale:0.5f];
    [scrollView setMaximumZoomScale:4.0f];
    [self setScrollView:scrollView];
    
    UIView *clearFrame = [[UIView alloc]initWithFrame:(CGRect){.origin = CGPointZero, .size = contentSize}];
    [clearFrame setBackgroundColor:[UIColor clearColor]];
    [clearFrame setUserInteractionEnabled:NO];
    [scrollView addSubview:clearFrame];
    [clearFrame addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:&kViewTransformChanged];
    [self setClearFrame:clearFrame];
    
    UISlider *slider= [self createGameSlider];
    [slider addTarget:self action:@selector(sliderWasMoved:) forControlEvents:UIControlEventValueChanged];
    [self setSlider:slider];
    
    [gameView addSubview:scrollView];
    [gameView addSubview:slider];
    
    // Set Stellar Objects
    NSArray *stellarObjects = [self createPlanetArray];
    [self setStellarObjects:stellarObjects];
    
    // Set Stellar Systems
    NSArray *stellarSystems = [self createSystemsArray];
    [self setStellarSystems:stellarSystems];
    
    [gameView presentScene:gameScene];
    
    // Set Content Offset
    [scrollView setContentOffset:CGPointMake(contentSize.width/2, contentSize.height/2)];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Sync Userdefaults
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *switchState = [defaults valueForKey:@"ShouldDestroyObjectsOnImpact"];
    if ([switchState isEqualToString:@"y"])
    {
        [self.gameScene setShouldDestroyObjects:YES];
    } else {
        [self.gameScene setShouldDestroyObjects:NO];
    }
    
    NSString *showStarField = [defaults valueForKey:@"ShouldShowStarField"];
    if ([showStarField isEqualToString:@"y"])
    {
        [self.gameScene showStarField];
    } else {
        [self.gameScene removeStarField];
    }
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SceneBackgroundColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    [self.gameScene.backgroundNode setColor:color];
         
    // Handle Object Limit

    NSInteger limit = [defaults integerForKey:@"SceneObjectLimit"];
    NSNumber *sceneLimit = self.gameScene.objectLimit;
    NSInteger sceneIntegerLimit = [sceneLimit integerValue];
    
    if (limit != sceneIntegerLimit)
    {
        // Update Limit.
        if (limit > sceneIntegerLimit)
        {
            [self.gameScene setObjectLimit:[NSNumber numberWithInt:(int)limit]];
            [self.gameScene refreshObjectCount];
        } else {
            
            NSInteger objectCount = [self.gameScene.sceneObjects count];
            NSInteger objectsToRemove = (objectCount - limit);
            
            NSInteger objectsRemoved = 0;
            
            if (objectsToRemove > 0)
            {
                while (objectsToRemove != 0)
                {
                    CXStellarSprite *object = [self.gameScene.sceneObjects objectAtIndex:objectsRemoved];
                    [object setShouldRemove:YES];
                    objectsRemoved++;
                    objectsToRemove--;
                }
            }
            [self.gameScene setObjectLimit:[NSNumber numberWithInt:(int)limit]];
            [self.gameScene refreshObjectCount];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CXGameViewController UIView Creation Methods

-(UISlider *)createGameSlider
{
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake([self.view bounds].size.width/2, [self.view bounds].size.height/2, 250, 50)];
    [slider setCenter:self.view.center];
    [slider setBackgroundColor:[UIColor clearColor]];
    [slider setThumbTintColor:[UIColor grayColor]];
    [slider setMinimumValue:1.0f];
    [slider setMaximumValue:20000.0f];
    [slider setContinuous:YES];
    [slider setHidden:YES];
    [slider setEnabled:NO];
    return slider;
}

#pragma mark CXGameViewController Stellar Data Loading/Setting

-(NSArray *)createPlanetArray
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"GameObjects" ofType:@"plist"];
    NSMutableArray *objectArray = [[NSMutableArray alloc]init];
    // Load Contents
    NSArray *contents = [NSArray arrayWithContentsOfFile:dataPath];
    for (NSDictionary *i in contents)
    {
        CXStellarObjectDescriptor *object = [[CXStellarObjectDescriptor alloc]initWithDictionary:i];
        [objectArray addObject:object];
    }
    return objectArray;
}

-(NSArray *)createSystemsArray
{
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"GameSystems" ofType:@"plist"];
    NSMutableArray *systemsArray = [[NSMutableArray alloc]init];
    // Load Contents
    NSArray *contents = [NSArray arrayWithContentsOfFile:dataPath];
    for (NSDictionary *i in contents)
    {
        CXStellarSystemDescriptor *system = [[CXStellarSystemDescriptor alloc]initWithDictionary:i];
        [systemsArray addObject:system];
    }
    return systemsArray;
}


#pragma mark CXGameViewController UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
    [self.scrollView setIsScrolling:NO];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self adjustContent:scrollView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.clearFrame;
}


#pragma mark CXGameViewController UIScrollView Custom Methods

-(void)adjustContent:(UIScrollView *)scrollView
{
    if ([self.gameScene.eventState integerValue] != 2)
    {
        CGFloat zoomScale = [scrollView zoomScale];
        [self.gameScene setContentScale:zoomScale];
        CGPoint contentOffset = [scrollView contentOffset];
        [self.gameScene setContentOffset:contentOffset];
    }
}

-(void)scrollViewDidTransform:(UIScrollView *)scrollView
{
    [self adjustContent:scrollView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kViewTransformChanged)
    {
        [self scrollViewDidTransform:(id)[(UIView *)object superview]];
        
    }
    
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark CXGameViewController UISlider Delegate Methods

-(void)sliderWasMoved:(id)sender
{
    [self.gameScene updateSliderValue:self.slider.value];
}

#pragma mark CXGameViewController Deallocation Methods

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    @try {
        [self.clearFrame removeObserver:self forKeyPath:@"transform"];
    }
    @catch (NSException *exception) {}
    @finally {}
}

#pragma mark CXGameViewController CXGameSceneToControllerProtocol Methods

-(void)moveScrollViewWithOffset:(CGVector)offset
{
    CGPoint currentOffset = self.scrollView.contentOffset;
    currentOffset.x += offset.dx;
    currentOffset.y -= offset.dy;
    [self.scrollView setContentOffset:currentOffset animated:YES];
}

-(void)showSliderWithValue:(int)value
{
    [self.slider setHidden:NO];
    [self.slider setEnabled:YES];
    [self.slider setValue:value];
}

-(void)switchToCatalogue
{
    if (!self.gameCatalogueViewController)
    {
        [self setGameCatalogueViewController:[[CXGameCatalogueViewController alloc]init]];
        [self.gameCatalogueViewController setStellarContent:@[_stellarObjects,_stellarSystems]];
        [self.gameCatalogueViewController setMyDelegate:self.gameScene];
    }
    [self.navigationController pushViewController:self.gameCatalogueViewController animated:YES];
}

-(void)switchToManager
{
    if (!self.gameManagerViewController)
    {
        [self setGameManagerViewController:[[CXGameManagerViewController alloc]init]];
        [self.gameManagerViewController setMyDelegate:self.gameScene];
    }
    NSMutableArray *gameObjects = [NSMutableArray arrayWithArray:[self.gameScene sceneObjects]];
    [self.gameManagerViewController setInGameObjects:gameObjects];
    [self.navigationController pushViewController:self.gameManagerViewController animated:YES];
}


-(void)hideSlider
{
    [self.slider setEnabled:NO];
    [self.slider setHidden:YES];
}

#pragma mark CXGameViewController  Hide Status Bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}




@end
