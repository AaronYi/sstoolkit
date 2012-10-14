//
//  SSPickerViewController.h
//  SSToolkit
//
//  Created by Sam Soffes on 10/9/08.
//  Copyright 2008-2011 Sam Soffes. All rights reserved.
//

/**
 This is an abstract class for displaying a `UITableView` with a list of items for the user to choose similar to
 Settings.app.
 
 A subclass should override the `- (void)loadObjects` and `- (NSString *)cellTextForObject:(id)anObject` methods to
 customize this class.
 
 A subclass can optionally override `- (void)cellImageForKey:(id)key` to show an image in the cell.
 */

enum {
	SSPickerTypeSingular = 0,
	SSPickerTypeMultiple = 1,
};
typedef NSUInteger SSPickerType;

@interface SSPickerViewController : UITableViewController

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *selectedKeys;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic) SSPickerType type;
@property (nonatomic) BOOL shouldAutoReload;

- (void)reloadData;

- (void)loadKeys;
- (void)dismissVia:(id)sender;
- (NSString *)cellTextForKey:(id)key;
- (UIImage *)cellImageForKey:(id)key;

@end
