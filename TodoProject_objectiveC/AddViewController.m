//
//  AddViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "AddViewController.h"
#import "TodoObject.h"
@interface AddViewController ()
{
    UIDatePicker * timePacker;
    NSString * timeAndDate;
    NSString * currentDate;
    NSArray * priority;
    TodoObject * T;
    NSMutableDictionary * dic;
    NSMutableArray * arry;
    bool isGrantedNotification ;
    NSDate *selectedDate;
    NSDate *cDate;
}

@property (weak, nonatomic) IBOutlet UIButton *PBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *timePickerTxt;

@property (weak, nonatomic) IBOutlet UITextField *descTxt;

@property UILabel  * label1;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arry = [[NSMutableArray  alloc]init];
    
     priority = [[NSArray alloc] initWithObjects:@"High",@"Medium",@"Low", nil];
     defaults = [NSUserDefaults standardUserDefaults];
     arry = [defaults objectForKey:@"TodoList"];
     TodoList = [[NSMutableArray alloc]initWithArray:arry];
     
}
- (void)viewWillAppear:(BOOL)animated{
  //  T = [[TodoObject alloc] init];
    isGrantedNotification = NO;
    self.tableView.hidden = YES;
    cDate = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    selectedDate = [NSDate date];
    timeAndDate = [dateFormatter stringFromDate:[NSDate date]];
    currentDate = [dateFormatter stringFromDate:[NSDate date]];
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted , NSError * error){
        self->isGrantedNotification = YES;
    }];

}
- (IBAction)dateSelected:(id)sender {
    selectedDate = [sender date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm a"];
    timeAndDate = [formatter stringFromDate:selectedDate];
    NSLog(@"Todays date is %@",timeAndDate);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [priority count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"priorityCell" forIndexPath:indexPath];
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
- (IBAction)AddTodoBtn:(id)sender {

    dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[_nameTxt text] forKey:@"name"];
    [dic setObject:[_descTxt text] forKey:@"description"];
    [dic setObject:_PBtn.titleLabel.text forKey:@"priority"];
    [dic setObject:timeAndDate forKey:@"time"];
    [dic setObject:currentDate forKey:@"current"];
    [TodoList addObject:dic];
    [defaults setObject:TodoList forKey:@"TodoList"];
    [defaults synchronize];
    printf("\n%lu", (unsigned long)[TodoList count]);
    if(isGrantedNotification){
           UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [_nameTxt text];
        content.subtitle = _PBtn.titleLabel.text ;
        content.body = [_descTxt text];
        content.sound = [UNNotificationSound defaultSound];
        NSTimeInterval seconds;
        seconds = [selectedDate timeIntervalSinceDate:cDate] ;
        if(seconds <= 5){
            seconds = 27;
            printf("-----------------time --------------------");
        }
       
        UNTimeIntervalNotificationTrigger * trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:(seconds - 25) repeats:NO];
        UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"UNLocalNotification" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
//    [_nameTxt setText:@""];
//    [_descTxt setText:@""];
//    _PBtn.titleLabel.text = @"high";
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
