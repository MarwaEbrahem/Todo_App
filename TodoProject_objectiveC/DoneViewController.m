//
//  DoneViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "DoneViewController.h"
#import "DoneDetailsViewController.h"
@interface DoneViewController()
{
    DoneDetailsViewController * DoneDetails;
    NSMutableArray * DoneFromDefault;
    NSUserDefaults * defaults ;
    NSMutableDictionary * obj;
    NSMutableArray * H;
    NSMutableArray * L;
    NSMutableArray * M;
    bool flag;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation DoneViewController
- (void)viewDidLoad{
    DoneDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"DoneDetailsViewController"];
    UIBarButtonItem * sortBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortBtnPressed)];
    [self.navigationItem setRightBarButtonItem:sortBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    flag = YES;
    H = [NSMutableArray new];
    L = [NSMutableArray new];
    M = [NSMutableArray new];
    DoneDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"DoneDetailsViewController"];
    obj = [NSMutableDictionary new];
    defaults = [NSUserDefaults standardUserDefaults];
    DoneFromDefault = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"DoneList"]];
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
        y = [DoneFromDefault count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneCell" forIndexPath:indexPath];
    UILabel * nameLabel = [cell viewWithTag:1];
    UILabel * PriorityLabel = [cell viewWithTag:2];
    UIImageView * image = [cell viewWithTag:3];
    image.layer.cornerRadius = 15;
    NSString * p = @"";
    if(flag){
    obj = DoneFromDefault[indexPath.row];
     p = [obj objectForKey:@"priority"];
    [nameLabel setText:[obj objectForKey:@"name"]];
    [PriorityLabel setText:[obj objectForKey:@"priority"]];
      
    }else{
        switch (indexPath.section) {
            case 0:
                obj = H[indexPath.row];
                p = [obj objectForKey:@"priority"];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
                break;
            case 1:
                obj = M[indexPath.row];
                p = [obj objectForKey:@"priority"];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
                break;
            case 2:
                obj = L[indexPath.row];
                p = [obj objectForKey:@"priority"];
                [nameLabel setText:[obj objectForKey:@"name"]];
                [PriorityLabel setText:[obj objectForKey:@"priority"]];
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
    if(flag){
    DoneDetails.DoneArray = [[NSMutableArray alloc]initWithArray: DoneFromDefault];
    DoneDetails.index = indexPath.row;
    DoneDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: DoneFromDefault[indexPath.row]];
        DoneDetails.sortFlag = NO;
    }
    else{
        DoneDetails.sortFlag = YES;
        DoneDetails.HArray = [[NSMutableArray alloc]initWithArray: H];
        DoneDetails.MArray = [[NSMutableArray alloc]initWithArray: M];
        DoneDetails.LArray = [[NSMutableArray alloc]initWithArray: L];
        switch (indexPath.section) {
            case 0:
                DoneDetails.DoneArray = [[NSMutableArray alloc]initWithArray: H];
                DoneDetails.index = indexPath.row;
                DoneDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: H[indexPath.row]];
                DoneDetails.DonePriority = @"H";
                break;
            case 1:
                DoneDetails.DoneArray = [[NSMutableArray alloc]initWithArray: M];
                DoneDetails.index = indexPath.row;
                DoneDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: M[indexPath.row]];
                DoneDetails.DonePriority = @"M";
                break;
            case 2:
                DoneDetails.DoneArray = [[NSMutableArray alloc]initWithArray: L];
                DoneDetails.index = indexPath.row;
                DoneDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: L[indexPath.row]];
                DoneDetails.DonePriority = @"L";
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:DoneDetails animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(flag){
        [DoneFromDefault removeObjectAtIndex:indexPath.row];
        [defaults setObject:DoneFromDefault forKey:@"DoneList"];
       
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
            [defaults setObject:result forKey:@"DoneList"];
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
    for(NSMutableDictionary *obj in DoneFromDefault)
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
