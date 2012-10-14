//
//  SSPickerViewController.m
//  SSToolkit
//
//  Created by Sam Soffes on 10/9/08.
//  Copyright 2008-2011 Sam Soffes. All rights reserved.
//

#import "SSPickerViewController.h"

@implementation SSPickerViewController

#pragma mark - Accessors

@synthesize selectedKeys = _selectedKeys;
@synthesize keys = _keys;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize type = _type;
@synthesize shouldAutoReload = _shouldAutoReload;

#pragma mark - NSObject

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.shouldAutoReload = YES;
		self.type = SSPickerTypeSingular;
	}
	return self;
}


#pragma mark - UIViewController Methods

- (void)viewDidLoad {
	[super viewDidLoad];
	if (self.type == SSPickerTypeMultiple) {
		self.navigationItem.rightBarButtonItem =
		[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done")
                                     style:UIBarButtonItemStyleDone
                                    target:self action:@selector(dismissVia:)];
	}
	[self loadKeys];
	if (self.shouldAutoReload) {
		[self reloadData];
	}
}


#pragma mark - SSPickerViewController

// This method should be overridden by a subclass
- (void)loadKeys {
	self.keys = nil;
	self.selectedKeys = nil;
}

// This method should be overridden by a subclass
- (void)dismissVia:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

// This method should be overridden by a subclass
- (NSString *)cellTextForKey:(id)key {
	return key;
}

// This method should be overridden by a subclass
- (UIImage *)cellImageForKey:(id)key {
	return nil;
}

- (void)reloadData {
	if (self.selectedKeys != nil) {
		[self.tableView reloadData];
        if (self.selectedKeys.count > 0) {
            // Select key if possible.
            self.currentIndexPath = [NSIndexPath indexPathForRow:
                                     [self.keys indexOfObject:[self.selectedKeys objectAtIndex:0]]
                                                       inSection:0];
            [self.tableView scrollToRowAtIndexPath:self.currentIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
	}
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	id key = [self.keys objectAtIndex:indexPath.row];
	if (cell.accessoryType == UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.currentIndexPath = indexPath;
		if (self.type == SSPickerTypeSingular) {
			//-- Impute that we no longer need this view.
			[self dismissVia:cell];
		}
		[self.selectedKeys addObject:key];
	} else if (self.type == SSPickerTypeMultiple) {
		//-- Allow toggling as needed.
		cell.accessoryType = UITableViewCellAccessoryNone;
		[self.selectedKeys removeObject:key];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (NSInteger)[self.keys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	id key = [self.keys objectAtIndex:indexPath.row];
	cell.textLabel.text = [self cellTextForKey:key];
	cell.imageView.image = [self cellImageForKey:key];
	if ([self.selectedKeys indexOfObject:key] != NSNotFound) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

@end
