//
//  RWTreeNode.h
//  
//
//  Created by deput on 10/17/15.
//  Copyright © 2015 rw. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RWTreeNode;

typedef void (^RWTreeNodeTraverseBlock)(id<RWTreeNode> currentNode, NSIndexPath* indexPath, BOOL* stop);

typedef void (^RWTreeNodeBackTraceBlock)(id<RWTreeNode> currentNode, BOOL* stop);

@protocol RWTreeNode<NSObject>

@required
@property (weak,nonatomic) id<RWTreeNode> parent;
@property (nonatomic) NSMutableArray< id<RWTreeNode> >* children;

- (id<RWTreeNode>) root;

- (BOOL) isLeaf;
- (BOOL) isRoot;

+ (id<RWTreeNode>) treeNode;

#pragma mark - Tree node operation and access methods

- (void) addChild:(id<RWTreeNode>)child;
- (void) removeChild:(id<RWTreeNode>)child;

- (id<RWTreeNode>) childAtIndex:(NSUInteger) index;
- (void) removeChildAtIndex:(NSUInteger) index;
- (void) insertChild:(id<RWTreeNode>)child atIndex:(NSUInteger) index;

- (id<RWTreeNode>) childAtIndexPath:(NSIndexPath*) indexPath;
- (void) removeChildAtIndexPath:(NSIndexPath*) indexPath;
- (void) insertChild:(id<RWTreeNode>)child atIndexPath:(NSIndexPath*) indexPath;

- (NSArray<id<RWTreeNode>>*) flatten;
- (NSArray<id<RWTreeNode>>*) brothers;

#pragma mark - Index

- (NSUInteger) index;
- (NSIndexPath*) indexPath;
- (NSIndexPath*) indexPathBasedOn:(id<RWTreeNode>)node;

#pragma mark - Traverse utils

- (void) dfsWithBlock:(RWTreeNodeTraverseBlock) block;
- (void) bfsWithBlock:(RWTreeNodeTraverseBlock) block;
- (void) backTraceToRootWithBlock:(RWTreeNodeBackTraceBlock) block;

@end

#pragma mark - RWTreeNodeObject

@interface RWTreeNodeObject<RWTreeNodeValueType> : NSObject<RWTreeNode>
{
    RWTreeNodeValueType _value;
}

@property (nonatomic) RWTreeNodeValueType value;
- (id) initWithValue:(RWTreeNodeValueType) value;
- (NSString* ) dump;
@end
