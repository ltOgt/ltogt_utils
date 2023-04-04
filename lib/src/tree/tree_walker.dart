// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:ltogt_utils/src/list/list_extension.dart';
import 'package:ltogt_utils/src/stack.dart';

/// A node for the tree walked by [walkDFS].
class TreeNodeDFS<S> {
  /// The node from the original tree
  final S sourceNode;

  /// The children of the original [sourceNode]
  Iterable<S> get sourceNodeChildren => children.map((e) => e.sourceNode);

  /// Reference to the [TreeNodeDFS] parent of `this` node.
  final TreeNodeDFS<S>? parent;

  /// References to the [TreeNodeDFS] version of [sourceNode]s children.
  final List<TreeNodeDFS<S>> _children;
  Iterable<TreeNodeDFS<S>> get children => UnmodifiableListView(_children);

  /// The depth of the tree in respect to the root node
  final int depth;

  /// The index of `this` node inside [parent]
  final int indexInParent;

  /// The number of children the parent has
  int get parentChildCount => parent?.children.length ?? 1;

  /// for the tree that was build, upwards merge of subtree sizes
  /// see [_complete]
  ///
  /// can be used e.g. to skip elements in a DFS list
  int? subtreeSize;

  /// see [walkDFS]
  TreeNodeDFS({
    required this.sourceNode,
    required this.parent,
    required this.indexInParent,
  })  : _children = [], // filled later via addChild
        depth = (parent == null) //
            ? 0
            : parent.depth + 1;

  /// Call to add a new child.
  void _addChild(TreeNodeDFS<S> child) {
    // children may be incomplete themselves at this point
    // they must all be completed at [_complete] though.
    _children.add(child);
  }

  /// Calculates [subtreeSize] from children once [child.isLast]
  void _complete() {
    if (_children.isEmpty) {
      subtreeSize = 0;
      return;
    }

    assert(_children.last.isLast);
    assert(
      !_children.any((e) => e.subtreeSize == null),
      "all children must be complete",
    );

    this.subtreeSize = _children.collect(
      0,
      (acc, ele) => acc! + ele.subtreeSize! + 1,
    );
  }

  bool get isFirst => indexInParent == 0;
  bool get isLast => parent == null || parent!.children.length - 1 == indexInParent;

  bool get isLeaf => children.isEmpty;
  bool get isOnlyChild => parentChildCount == 1;
}

class _StackLayer<S> {
  /// The [TreeNodeDFS] parent of [parentSource]
  ///
  /// We will fill [TreeNodeDFS.children] of [parentNode] in this layer.
  /// They will be complete once this layer is popped of the stack.
  final TreeNodeDFS<S> parentNode;

  /// The node that spawned this layer for its [parentSourceChildren].
  S get parentSource => parentNode.sourceNode;

  /// The source that is used to fill the [parentsChildrenTarget] via DFS.
  ///
  /// See [currentIndexInParent] for the current active child.
  final List<S> parentSourceChildren;

  /// The current [parentSourceChildren] that needs to be filled
  int currentIndexInParent;

  bool get isLast => currentIndexInParent == parentSourceChildren.length - 1;

  S get currentSource => parentSourceChildren[currentIndexInParent];

  _StackLayer({
    required this.parentNode,
    required this.parentSourceChildren,
  }) : this.currentIndexInParent = 0;
}

/// Starting from [rootNodeSource],
/// [getChildrenSource] is applied for each node along the tree.
/// Via depth first descend.
///
/// You can enforce things like `maxDepth` by returning an empty list
/// from [getChildrenSource].
///
/// Returns the trace of the walk (starting from the root).
/// Where all [TreeNodeDFS]s are complete with references to each other.
List<TreeNodeDFS<S>> walkDFS<S>({
  required S rootNodeSource,
  required List<S> Function(S nodeSource) getChildrenSource,
}) {
  // we always have at least the root node
  final rootNode = TreeNodeDFS<S>(
    sourceNode: rootNodeSource,
    parent: null,
    indexInParent: 0,
  );

  // collect all nodes as we visit them to unfold DFS
  final List<TreeNodeDFS<S>> trace = [rootNode];

  final rootChildrenSource = getChildrenSource(rootNodeSource);
  if (rootChildrenSource.isEmpty) {
    return trace;
  }

  final stack = StackList<_StackLayer<S>>();
  stack.put(
    _StackLayer(
      parentNode: rootNode,
      parentSourceChildren: rootChildrenSource,
    ),
  );

  _StackLayer<S> getCurrentLayer() => stack.last;

  while (true) {
    // for the currentLayer
    final currentLayer = getCurrentLayer();

    // get the current source via the current index in parent
    final currentSource = currentLayer.currentSource;

    // get children for current
    final currentSourceChildren = getChildrenSource(currentSource);

    // get the parent node
    final parent = currentLayer.parentNode;

    // create node for current
    final currentNode = TreeNodeDFS<S>(
      sourceNode: currentSource,
      parent: parent,
      indexInParent: currentLayer.currentIndexInParent,
    );
    trace.add(currentNode);
    parent._addChild(currentNode);

    if (currentSourceChildren.isEmpty) {
      currentNode._complete();
      // move to next node on layer or go up
      while (true) {
        final _currentLayer = getCurrentLayer();
        if (_currentLayer.isLast) {
          stack.pop();
          _currentLayer.parentNode._complete();
          if (stack.isEmpty) return trace;
        } else {
          _currentLayer.currentIndexInParent += 1;
          break;
        }
      }
    } else {
      // go down into first child
      stack.put(
        _StackLayer(
          parentNode: currentNode,
          parentSourceChildren: currentSourceChildren,
        ),
      );
    }
  }
}
