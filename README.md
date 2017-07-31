# RWTreeNode

## Description
RWTreeNode is An easy-to-use tree node structure in Objective-C.

## Usage

### Basic usage
Following is code to create a tree with RWTreeNode
```objc
    RWTreeNodeObject<NSString*>* root = [[RWTreeNodeObject alloc] initWithValue:@"0"];
    RWTreeNodeObject<NSString*>* n1 = [[RWTreeNodeObject alloc] initWithValue:@"1"];
    RWTreeNodeObject<NSString*>* n2 = [[RWTreeNodeObject alloc] initWithValue:@"2"];
    RWTreeNodeObject<NSString*>* n3 = [[RWTreeNodeObject alloc] initWithValue:@"3"];
    RWTreeNodeObject<NSString*>* n4 = [[RWTreeNodeObject alloc] initWithValue:@"4"];
    RWTreeNodeObject<NSString*>* n5 = [[RWTreeNodeObject alloc] initWithValue:@"5"];
    RWTreeNodeObject<NSString*>* n6 = [[RWTreeNodeObject alloc] initWithValue:@"6"];
    RWTreeNodeObject<NSString*>* n7 = [[RWTreeNodeObject alloc] initWithValue:@"7"];
    RWTreeNodeObject<NSString*>* n8 = [[RWTreeNodeObject alloc] initWithValue:@"8"];
    RWTreeNodeObject<NSString*>* n9 = [[RWTreeNodeObject alloc] initWithValue:@"9"];
    [root addChild:n1];
    [root addChild:n2];
    [root addChild:n3];
    [n3 addChild:n4];
    [n4 addChild:n5];
    [n5 addChild:n6];
    [n5 addChild:n7];
    [n7 addChild:n8];
    [n7 addChild:n9];
```
You can view tree hierachy in lldb:
```
(lldb)po [root dump]
```
result will be revealed in console like:
```
  <RWTreeNodeObject:0x7fb8fa900d70 - value:0>
    <RWTreeNodeObject:0x7fb8fa900df0 - value:1>
    <RWTreeNodeObject:0x7fb8fa900e20 - value:2>
    <RWTreeNodeObject:0x7fb8fa900e50 - value:3>
        <RWTreeNodeObject:0x7fb8fa900e80 - value:4>
            <RWTreeNodeObject:0x7fb8fa900eb0 - value:5>
                <RWTreeNodeObject:0x7fb8fa900ee0 - value:6>
                <RWTreeNodeObject:0x7fb8fa9003a0 - value:7>
                    <RWTreeNodeObject:0x7fb8fa9003d0 - value:8>
                    <RWTreeNodeObject:0x7fb8fa900400 - value:9>
```
### Traveral

- DFS
```objc
  [root dfsWithBlock:^(id<RWTreeNode> currentNode, NSIndexPath *indexPath, BOOL *stop) {
    NSLog([currentNode description]);
  }];
```
- BFS
```objc
  [root bfsWithBlock:^(id<RWTreeNode> currentNode, NSIndexPath *indexPath, BOOL *stop) {
    NSLog([currentNode description]);
  }];
```
- Back Trace
```objc
  [n6 backTraceToRootWithBlock:^(id<RWTreeNode> currentNode, BOOL *stop) {
    NSLog([currentNode description]);
  }];
```

### Indexing
We can operate tree node via index path or get index path of a node in tree. For instance, indexPath of `n9` :

```
(lldb) po [n9 indexPath]
<NSIndexPath: 0x7fb8faa0d560> {length = 5, path = 2 - 0 - 0 - 1 - 1}
```

Some other interface for tree node operation based on index:
```
- (id<RWTreeNode>) childAtIndexPath:(NSIndexPath*) indexPath;
- (void) removeChildAtIndexPath:(NSIndexPath*) indexPath;
- (void) insertChild:(id<RWTreeNode>)child atIndexPath:(NSIndexPath*) indexPath;
```

## Issues
