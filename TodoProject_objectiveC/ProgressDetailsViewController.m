//
//  ProgressDetailsViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "ProgressDetailsViewController.h"

@interface ProgressDetailsViewController ()
{
    NSArray * priority;
    NSString * timeAndDate;
    NSUserDefaults * Udefault;
    NSMutableArray * DoneArry;
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

@implementation ProgressDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    priority = [[NSArray alloc] initWithObjects:@"High",@"Medium",@"Low", nil];
}
- (void)viewWillAppear:(BOOL)animated{
    Udefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * d = [NSMutableDictionary new];
    d = self.progressArray[_index];
   [_nameField setText:[d objectForKey:@"name"]];
   [_descField setText:[d objectForKey:@"description"]];
   [_PBtn setTitle:[d objectForKey:@"priority" ]forState:UIControlStateNormal];
    [_timeTxt setText:[d objectForKey:@"time"]];
    [_currentDate setText:[d objectForKey:@"current"]];
    DoneArry = [[NSMutableArray alloc]initWithArray:[Udefault objectForKey:@"DoneList"]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [priority count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"progressDCell" forIndexPath:indexPath];
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
    NSMutableArray * progressArrayCopy = [self.progressArray mutableCopy];
    NSMutableDictionary * newData = [[NSMutableDictionary alloc]init];
    newData = _dictionary;
    [newData setObject:[_nameField text] forKey:@"name"];
    [newData setObject:[_descField text] forKey:@"description"];
    [newData setObject:[_timeTxt text] forKey:@"time"];
    [newData setObject:[_currentDate text] forKey:@"current"];
    [newData setObject:_PBtn.titleLabel.text forKey:@"priority"];
    if(_SW.selectedSegmentIndex == 0) {
        [progressArrayCopy replaceObjectAtIndex:_index withObject:newData];
       
       }else if(_SW.selectedSegmentIndex == 1) {
           [progressArrayCopy removeObjectAtIndex:_index];
           [DoneArry addObject:newData];
           
       }
    self.progressArray = progressArrayCopy;
    if(_sortFlag){
        NSMutableArray * result;
        if([_DonePriority  isEqual: @"H"]){
             result = [[NSMutableArray alloc] initWithArray:_progressArray];
            for(NSMutableDictionary * obj in _MArray){
                [result addObject:obj];
            }
            for(NSMutableDictionary * obj in _LArray){
                [result addObject:obj];
            }
           
        }else if ([_DonePriority  isEqual: @"M"]){
             result = [[NSMutableArray alloc] initWithArray:_progressArray];
            for(NSMutableDictionary * obj in _HArray){
                [result addObject:obj];
            }
            for(NSMutableDictionary * obj in _LArray){
                [result addObject:obj];
            }
        
        }else if ([_DonePriority  isEqual: @"L"]){
             result = [[NSMutableArray alloc] initWithArray:_progressArray];
            for(NSMutableDictionary * obj in _MArray){
                [result addObject:obj];
            }
            for(NSMutableDictionary * obj in _HArray){
                [result addObject:obj];
            }
    
        }
            [Udefault setObject:result forKey:@"progressList"];
       
    }else{
      [Udefault setObject:_progressArray forKey:@"progressList"];
    }
    
   
    [Udefault setObject:DoneArry forKey:@"DoneList"];
   
    [self.navigationController popViewControllerAnimated:YES];
}


@end
