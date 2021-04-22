//
//  TodoViewController.m
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import "TodoViewController.h"
#import "TodoDetailsViewController.h"
#import "AddViewController.h"
#import "TodoObject.h"
@interface TodoViewController()
{
    TodoDetailsViewController * TodoDetails;
    AddViewController * AddView;
    NSMutableArray * TodoFromDefault;
    NSMutableDictionary * obj;
    NSMutableDictionary * f;
    NSMutableArray * filter;
    bool isFiltered;
    NSUserDefaults * d ;
  
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
@implementation TodoViewController
- (void)viewDidLoad{
   
    self.searchBar.delegate = self;
    TodoFromDefault = [NSMutableArray new];
    obj = [NSMutableDictionary new];
    f = [NSMutableDictionary new];
   
}
- (void)viewWillAppear:(BOOL)animated{
    isFiltered = NO;
    TodoDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"TodoDetailsViewController"];
    AddView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
     d = [NSUserDefaults standardUserDefaults];
    TodoFromDefault =  [[d objectForKey:@"TodoList"] mutableCopy];
    [self.tableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = NO;
    }else{
        isFiltered = YES;
        filter = [[NSMutableArray alloc] init];
        for (f in TodoFromDefault) {
            NSString * todo = [f objectForKey:@"name"];
            NSRange nameRange = [todo rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [filter addObject:f];
            }
        }
    }
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered){
        return [filter count];
    }
    return [TodoFromDefault count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(isFiltered){
        obj = filter[indexPath.row];
    }
    else{
        obj = TodoFromDefault[indexPath.row];
    }
    UILabel * nameLabel = [cell viewWithTag:1];
    UILabel * PriorityLabel = [cell viewWithTag:2];
    UIImageView * image = [cell viewWithTag:3];
    image.layer.cornerRadius = 15;
    NSString * p = @"";
    [nameLabel setText:[obj objectForKey:@"name"]];
    [PriorityLabel setText:[obj objectForKey:@"priority"]];
    p = [obj objectForKey:@"priority"];
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
   // NSMutableDictionary * moveTodoArray = [NSMutableDictionary new];
   // [moveTodoArray setObject:TodoFromDefault forKey:@"TodoArray"];
    TodoDetails.TodoArray = [[NSMutableArray alloc]initWithArray: TodoFromDefault];
    TodoDetails.index = indexPath.row;
    TodoDetails.dictionary = [[NSMutableDictionary alloc]initWithDictionary: TodoFromDefault[indexPath.row]];
    [self.navigationController pushViewController:TodoDetails animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [TodoFromDefault removeObjectAtIndex:indexPath.row];
        [d setObject:TodoFromDefault forKey:@"TodoList"];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (IBAction)addBtn:(id)sender {
    printf("ADD");
    [self.navigationController pushViewController:AddView animated:YES];
}

@end

