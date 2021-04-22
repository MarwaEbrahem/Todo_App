//
//  ProgressDetailsViewController.h
//  TodoProject_objectiveC
//
//  Created by marwa on 4/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressDetailsViewController : UIViewController<UITableViewDelegate , UITableViewDataSource>
@property NSInteger index;
@property NSMutableArray * progressArray;
@property NSMutableDictionary * dictionary;
@property BOOL sortFlag;
@property NSMutableArray * HArray;
@property NSMutableArray * LArray;
@property NSMutableArray * MArray;
@property NSString * DonePriority;
@end

NS_ASSUME_NONNULL_END
