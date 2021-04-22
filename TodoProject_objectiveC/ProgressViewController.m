//
//  ProgressViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "ProgressViewController.h"
#import "ProgressDetailsViewController.h"
@interface ProgressViewController()
{
    ProgressDetailsViewController * ProgressDetails;
    NSMutableArray * progressFromDefault;
    NSUserDefaults * defaults ;
    NSMutableDictionary * obj;
    NSMutableArray * H;
    NSMutableArray * L;
    NSMutableArray * M;
    bool flag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation ProgressViewController
- (void)viewDidLoad{
   
    UIBarButtonItem * sortBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortBtnPressed)];
    [self.navigationItem setRightBarButtonItem:sortBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    flag = YES;
    H = [NSMutableArray new];
    L = [NSMutableArray new];
    M = [NSMutableArray new];
    obj = [NSMutableDictionary new];
    defaults = [NSUserDefaults standardUserDefaults];
    progressFromDefault = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"progressList"]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger * x = 0;
    if(flag){
        x = 1;
    }else{
        x = 3;
    }
    return x;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger * y = 0;
    if(flag){
        y = [progressFromDefault count];
    }
    else{
        switch (section) {
            case 0:
                y = [H count];
                break;
            case 1:
                y = [M count];
                break;
            case 2:
                y = [L count];
                break;
            default:
                break;
        }
    }
    return y;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressCell" forIndexPath:indexPath];
    UILabel * nameLabel = [cell viewWithTag:1];
    UILabel * PriorityLabel = [cell viewWithTag:2];
    UIImageView * image = [cell viewWithTag:3];
    image.layer.cornerRadius = 15;
    NSString * p = @"";
    if(flag){
    obj = progressFromDefault[indexPath.row];
    [nameLabel setText:[obj objectForKey:@"name"]];
    [PriorityLabel setText:[obj objectForKey:@"priority"]];
        p = [obj objectForKey:@"priority"];
    }else{
        switch (indexPath.section) {
            case 0:
                obj = H[indexPath.row];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
                p = [obj objectForKey:@"priority"];
                break;
            case 1:
                obj = M[indexPath.row];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
                p = [obj objectForKey:@"priority"];
                break;
            case 2:
                obj = L[indexPath.row];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
                p = [obj objectForKey:@"priority"];
                break;
                
            default:
                break;
        }
    }
    if([@"High"  isEqual:p])
    {
        [image setBackgroundColor:[UIColor redColor]];
       
    }else if([@"Medium"  isEqual:p])
    {
        [image setBackgroundColor:[UIColor yellowColor]];
    }
    else if([@"Low"  isEqual:p])
    {
        [image setBackgroundColor:[UIColor greenColor]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgressDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressDetailsViewController"];
    
    if(flag){
        ProgressDetails.progressArray = [[NSMutableArray alloc]initWithArray: progressFromDefault];
        ProgressDetails.index = indexPath.row;
        ProgressDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: progressFromDefault[indexPath.row]];
        ProgressDetails.sortFlag = NO;
    }
    else{
        ProgressDetails.sortFlag = YES;
        ProgressDetails.HArray = [[NSMutableArray alloc]initWithArray: H];
        ProgressDetails.MArray = [[NSMutableArray alloc]initWithArray: M];
        ProgressDetails.LArray = [[NSMutableArray alloc]initWithArray: L];
        switch (indexPath.section) {
            case 0:
                ProgressDetails.progressArray = [[NSMutableArray alloc]initWithArray: H];
                ProgressDetails.index = indexPath.row;
                ProgressDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: H[indexPath.row]];
                ProgressDetails.DonePriority = @"H";
                break;
            case 1:
                ProgressDetails.progressArray = [[NSMutableArray alloc]initWithArray: M];
                ProgressDetails.index = indexPath.row;
                ProgressDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: M[indexPath.row]];
                ProgressDetails.DonePriority = @"M";
                break;
            case 2:
                ProgressDetails.progressArray = [[NSMutableArray alloc]initWithArray: L];
                ProgressDetails.index = indexPath.row;
                ProgressDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: L[indexPath.row]];
                ProgressDetails.DonePriority = @"L";
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:ProgressDetails animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(flag){
        [progressFromDefault removeObjectAtIndex:indexPath.row];
        [defaults setObject:progressFromDefault forKey:@"progressList"];
       
        }else{
            switch (indexPath.section) {
                case 0:
                    [H removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    [M removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    [L removeObjectAtIndex:indexPath.row];
                    break;
                    
                default:
                    break;
            }
            NSMutableArray * result = [[NSMutableArray alloc] initWithArray:H];
            for(obj in M){
                [result addObject:obj];
            }
            for(obj in L){
                [result addObject:obj];
            }
            [defaults setObject:result forKey:@"progressList"];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * titleName = @"";
    if(flag){
      
    }else{
    switch (section) {
        case 0:
            titleName = @"High";
            break;
        case 1:
            titleName = @"Medium";
            break;
        case 2:
            titleName = @"Low";
            break;
        default:
            break;
    }
    }
    return titleName;
}
-(void)sortBtnPressed{
  
    for(NSMutableDictionary *obj in progressFromDefault)
    {
        if([@"High"  isEqual: [obj objectForKey:@"priority"]])
        {
            [H addObject:obj];
            printf("High");
        }else if([@"Medium"  isEqual: [obj objectForKey:@"priority"]])
        {
            [M addObject:obj];
            printf("Medium");
        }
        else if([@"Low"  isEqual: [obj objectForKey:@"priority"]])
        {
            [L addObject:obj];
            printf("Low");
        }
    }
    flag = NO;
    [self.tableView reloadData];
}

@end
