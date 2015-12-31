//
//  RWTreeNode.m
//  
//
//  Created by deput on 10/17/15.
//  Copyright © 2015 rw. All rights reserved.
//

#import "RWTreeNode.h"

@implementation NSIndexPath(RWTreeNode)
- (NSUInteger) lastIndex
{
    if (self.length == 0) {
        return 0;
    }
    return [self indexAtPosition:self.length - 1];
}
@end

@implementation RWTreeNodeObject
{
    NSMutableArray*         _children;
    __weak id<RWTreeNode>   _parent;
}

@synthesize children;
@synthesize parent = _parent;
@synthesize value = _value;

+ (id<RWTreeNode>) treeNode
{
    return [[[self class] alloc] init];
}

- (id) initWithValue:(id) value
{
    self = [super init];
    _value = value;
    return self;
}

- (NSMutableArray< id<RWTreeNode> >*) children
{
    if (_children == nil) {
        _children = @[].mutableCopy;
    }
    return _children;
}

- (id<RWTreeNode>) root
{
    id<RWTreeNode> current = self;
    while(current.parent) current = current.parent;
    return current;
}

- (BOOL) isLeaf
{
    return (self.children == nil || self.children.count == 0);
}

- (BOOL) isRoot
{
    return self.parent == nil;
}

#pragma mark - Tree node operation and access methods

- (void) addChild:(id<RWTreeNode>)child
{
    [[self children] addObject:child];
    child.parent = self;
}

- (void) removeChild:(id<RWTreeNode>)child
{
    [self.children removeObject:child];
    child.parent = nil;
}

- (id<RWTreeNode>) childAtIndex:(NSUInteger) index
{
    if (index < self.children.count)
        return self.children[index];
    return nil;
}

- (void) insertChild:(id<RWTreeNode>)child atIndex:(NSUInteger) index
{
    if (index < self.children.count)
        [self.children insertObject:child atIndex:index];
    else
        [self addChild:child];
}

-(void) removeChildAtIndex:(NSUInteger) index
{
    [self.children removeObjectAtIndex:index];
}

-(id<RWTreeNode>) childAtIndexPath:(NSIndexPath*) indexPath
{
    id<RWTreeNode> current = self;
    for(NSUInteger i = 0; i < indexPath.length; i++){
        NSAssert(![current isLeaf], @"Not leaf");
        current = current.children[[indexPath indexAtPosition:i]];
    }
    return current;
}

-(void) insertChild:(id<RWTreeNode>)child atIndexPath:(NSIndexPath*) indexPath
{
    id<RWTreeNode> current = self;
    for(NSUInteger i = 0; i < indexPath.length - 1; i++){
        NSAssert(![current isLeaf], @"Not leaf");
        current = current.children[[indexPath indexAtPosition:i]];
    }
    [current insertChild:child atIndex:[indexPath lastIndex]];
}

-(void) removeChildAtIndexPath:(NSIndexPath*) indexPath
{
    id<RWTreeNode> current = self;
    for(NSUInteger i = 0; i < indexPath.length - 1; i++){
        NSAssert(![current isLeaf], @"Not leaf");
        current = current.children[[indexPath indexAtPosition:i]];
    }
    [current removeChildAtIndex:[indexPath lastIndex]];
}

#pragma mark - Index

- (NSUInteger) index
{
    return [self.parent.children indexOfObject:self];
}

- (NSIndexPath*) indexPath
{
    return [self _indexPathBasedOn:self.root];
}

- (NSIndexPath*) indexPathBasedOn:(id<RWTreeNode>)node
{
    __block id<RWTreeNode> foundNode = nil;
    [self.children enumerateObjectsUsingBlock:^(id<RWTreeNode>  _Nonnull theNode, NSUInteger idx, BOOL * _Nonnull stop) {
        if (node == theNode){
            foundNode = theNode;
            *stop = YES;
        }
    }];
    if (foundNode){
        return [self _indexPathBasedOn:foundNode];
    }else{
        return nil;
    }
    return nil;
}

- (NSIndexPath*) _indexPathBasedOn:(id<RWTreeNode>)node
{
    NSMutableArray<id<RWTreeNode>>* treeNodes = [@[] mutableCopy];
    NSIndexPath* indexPath = [NSIndexPath new];
    [self backTraceToRootWithBlock:^(id<RWTreeNode> currentNode, BOOL *stop) {
        if (node == currentNode){
            *stop = YES;
        }else{
            [treeNodes insertObject:currentNode atIndex:0];
        }
    }];

    for(NSInteger i = 0 ;i < treeNodes.count; i++){
        indexPath = [indexPath indexPathByAddingIndex:[treeNodes[i] index]];
    }
    return indexPath;
}

#pragma mark - Traverse utils

- (void) dfsWithBlock:(RWTreeNodeTraverseBlock) block
{
    [self _dfsWithBlock:block indexPath:[NSIndexPath new]];
}

- (void) bfsWithBlock:(RWTreeNodeTraverseBlock) block
{
    [[self flatten] enumerateObjectsUsingBlock:^(id<RWTreeNode>  node, NSUInteger idx, BOOL *  stop) {
        if (block) {
            block(node,[node indexPath],stop);
        }
    }];
}

- (void) backTraceToRootWithBlock:(RWTreeNodeBackTraceBlock) block
{
    BOOL stop = NO;
    id<RWTreeNode> current = self;
    //NSIndexPath* indexPath = [current indexPath];
    while(current && !stop) {
        if (block)
            block(current,&stop);
        //indexPath = [indexPath indexPathByRemovingLastIndex];
        current = current.parent;
    }
}

- (NSArray<id<RWTreeNode>>*) flatten
{
    NSMutableArray* array = @[].mutableCopy;
    NSMutableArray* queue = @[].mutableCopy;
    [queue addObject:self];
    [array addObject:self];
    while (queue.count) {
        id<RWTreeNode> node = queue.firstObject;
        [queue removeObjectAtIndex:0];
        [array addObjectsFromArray:[node children]];
        [queue addObjectsFromArray:[node children]];
    }
    return array.copy;
}

- (NSArray<id<RWTreeNode>>*) brothers
{
    NSMutableArray* brothers = [[[self parent] children] mutableCopy];
    [brothers removeObjectIdenticalTo:self];
    return brothers;
}



#pragma mark - Internal methods
- (BOOL) _dfsWithBlock:(RWTreeNodeTraverseBlock) block indexPath:(NSIndexPath*)indexPath
{
    __block BOOL retStop = NO;
    block(self, indexPath, &retStop);
    if (retStop) return YES;
    
    [self.children enumerateObjectsUsingBlock:^(id<RWTreeNode>  _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        *stop = [(RWTreeNodeObject*)node _dfsWithBlock:block indexPath:[indexPath indexPathByAddingIndex:idx]];
        if(*stop) retStop = YES;
    }];
    return retStop;
}

#pragma mark - Debug helpers

- (NSString* ) description
{
    return [NSString stringWithFormat:@"<%@:%p - value:%@>\n",NSStringFromClass(self.class),self,[_value description]];
}

- (NSString* ) dump
{
    NSMutableString* returnString = [NSMutableString string];
    [self dfsWithBlock:^(id<RWTreeNode> currentNode, NSIndexPath *indexPath, BOOL *stop) {
        for (int i = 0; i < indexPath.length; i++) {
            [returnString appendString:@"    "];
        }
        [returnString appendString:[currentNode description]];
    }];
    return returnString;
}
@end
