//
//  AddViewController.h
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray * TodoList;
    NSUserDefaults * defaults;
}
@end

NS_ASSUME_NONNULL_END
