//
//  TodoDetailsViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "TodoDetailsViewController.h"

@interface TodoDetailsViewController (){
    NSArray * priority;
    NSString * timeAndDate;
    NSUserDefaults * Udefault;
    NSMutableArray * progressArry;
}
@property (weak, nonatomic) IBOutlet UIButton *PBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SW;
@property (weak, nonatomic) IBOutlet UITextField *timeTxt;
@property (weak, nonatomic) IBOutlet UITextField *currentDate;

@property (weak, nonatomic) IBOutlet UIDatePicker *selectedBtn;

@end

@implementation TodoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    priority = [[NSArray alloc] initWithObjects:@"High",@"Medium",@"Low", nil];
}
- (void)viewWillAppear:(BOOL)animated{
    Udefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * d = [NSMutableDictionary new];
    d = self.TodoArray[_index];
   [_nameField setText:[d objectForKey:@"name"]];
   [_descField setText:[d objectForKey:@"description"]];
   [_PBtn setTitle:[d objectForKey:@"priority" ]forState:UIControlStateNormal];
    [_timeTxt setText:[d objectForKey:@"time"]];
    [_currentDate setText:[d objectForKey:@"current"]];
    progressArry = [[NSMutableArray alloc]initWithArray:[Udefault objectForKey:@"progressList"]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [priority count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoDCell" forIndexPath:indexPath];
    [cell.textLabel setText:priority[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.PBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.tableView.hidden = YES;
}
- (IBAction)PBtnPressed:(id)sender {
    if(self.tableView.hidden == YES){
        self.tableView.hidden = NO;
    }else{
        self.tableView.hidden = YES;
    }
}
- (IBAction)dataSelected:(id)sender {
    NSDate *selectedDate = [sender date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm a"];
    timeAndDate = [formatter stringFromDate:selectedDate];
    [_timeTxt setText:timeAndDate];
    NSLog(@"Todays date is %@",timeAndDate);
}
- (IBAction)EditeBtn:(id)sender {
    self.nameField.enabled = YES;
    self.descField.enabled = YES;
    self.SW.enabled = YES;
    self.PBtn.enabled = YES;
    self.selectedBtn.enabled = YES;
    self.timeTxt.hidden = YES;
    self.selectedBtn.hidden = NO;
}
- (IBAction)doneBtn:(id)sender {
    NSMutableArray * TodoArrayCopy = [self.TodoArray mutableCopy];
    NSMutableDictionary * newData = [[NSMutableDictionary alloc]init];
    newData = _dictionary;
    [newData setObject:[_nameField text] forKey:@"name"];
    [newData setObject:[_descField text] forKey:@"description"];
    [newData setObject:[_timeTxt text] forKey:@"time"];
    [newData setObject:[_currentDate text] forKey:@"current"];
    [newData setObject:_PBtn.titleLabel.text forKey:@"priority"];
   
    if(_SW.selectedSegmentIndex == 0) {
        NSLog(@"todo");
        [TodoArrayCopy replaceObjectAtIndex:_index withObject:newData];
       
       }else if(_SW.selectedSegmentIndex == 1) {
           [TodoArrayCopy removeObjectAtIndex:_index];
           [progressArry addObject:newData];
           NSLog(@"progress");
       }
    self.TodoArray = TodoArrayCopy;
    [Udefault setObject:progressArry forKey:@"progressList"];
    [Udefault setObject:_TodoArray forKey:@"TodoList"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
