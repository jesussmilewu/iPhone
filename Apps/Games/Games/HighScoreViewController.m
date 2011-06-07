#import "HighScoreViewController.h"
#import "Score.h"
#import "GamesAppDelegate.h"

@interface HighScoreViewController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSData *cellData;

@end

@implementation HighScoreViewController

@synthesize tableView;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize cellData;

- (void)dealloc {
    self.tableView = nil;
    self.managedObjectContext = nil;
    self.fetchedResultsController = nil;
    self.cellData = nil;
    [super dealloc];
}

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *theFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *theEntity = [NSEntityDescription entityForName:@"Score" 
                                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *theDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES];
    
    theFetch.entity = theEntity;
    theFetch.sortDescriptors = [NSArray arrayWithObject:theDescriptor];
    // theFetch.predicate = [NSPredicate predicateWithFormat:@"ANY media.type = 'image'"];
    return theFetch;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(managedObjectContext == nil) {
        NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
        GamesAppDelegate *theDelegate = (id)[[UIApplication sharedApplication] delegate];
        
        theContext.persistentStoreCoordinator = theDelegate.storeCoordinator;
        self.managedObjectContext = theContext;
        [theContext release];
    }
    return managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    NSFetchedResultsController *theController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    NSError *theError = nil;
    
    theController.delegate = self;
    self.fetchedResultsController = theController;
    [theController release];
    if(![self.fetchedResultsController performFetch:&theError]) {
        NSLog(@"viewDidLoad: %@", theError);
    }
    [theCenter addObserver:self 
                  selector:@selector(managedObjectContextDidSave:)
                      name:NSManagedObjectContextDidSaveNotification 
                    object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    self.tableView = nil;
    self.cellData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    return inOrientation == UIInterfaceOrientationPortrait;
}

- (void)managedObjectContextDidSave:(NSNotification *)inNotification {
    if(inNotification.object != self.managedObjectContext) {
        [self.managedObjectContext mergeChangesFromContextDidSaveNotification:inNotification];
    }
}

- (void)applyScore:(Score *)inScore toCell:(UITableViewCell *)inCell {
    UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", inScore.game]];
    
    inCell.imageView.image = theImage;
    inCell.textLabel.text = [NSString stringWithFormat:@"%@", inScore.score];
    inCell.detailTextLabel.text = inScore.creationTime.description;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)inSection {
    id<NSFetchedResultsSectionInfo> theInfo = [[self.fetchedResultsController sections] objectAtIndex:inSection];
    
    return [theInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath {
    NSString *theIdentifier = @"Cell";
    UITableViewCell *theCell = [inTableView dequeueReusableCellWithIdentifier:theIdentifier];
    Score *theScore = [self.fetchedResultsController.fetchedObjects objectAtIndex:inIndexPath.row];
    
    if(theCell == nil) {
        theCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:theIdentifier];
        [theCell autorelease];
    }
    [self applyScore:theScore toCell:theCell];
    return theCell;
}

@end
