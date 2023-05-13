import 'package:ltogt_utils/ltogt_utils.dart';
import 'package:ltogt_utils/src/tree/tree_walker.dart';
import 'package:test/test.dart';

void main() {
  group('walkDFS', () {
    test('walks simple tree as expected', () async {
      final trace = walkDFS(
        rootNodeSource: "R",
        getChildrenSource: (n) => n.length < 5 //
            ? ["$n.0", "$n.1", "$n.2"]
            : [],
      );

      int _i = 0;
      int i() => _i++;
      expect(trace[i()].sourceNode, "R");
      expect(trace[i()].sourceNode, "R.0");
      expect(trace[i()].sourceNode, "R.0.0");
      expect(trace[i()].sourceNode, "R.0.1");
      expect(trace[i()].sourceNode, "R.0.2");
      expect(trace[i()].sourceNode, "R.1");
      expect(trace[i()].sourceNode, "R.1.0");
      expect(trace[i()].sourceNode, "R.1.1");
      expect(trace[i()].sourceNode, "R.1.2");
      expect(trace[i()].sourceNode, "R.2");
      expect(trace[i()].sourceNode, "R.2.0");
      expect(trace[i()].sourceNode, "R.2.1");
      expect(trace[i()].sourceNode, "R.2.2");

      _i = 0;
      expect(trace[i()].parent?.sourceNode, isNull);
      expect(trace[i()].parent!.sourceNode, "R");
      expect(trace[i()].parent!.sourceNode, "R.0");
      expect(trace[i()].parent!.sourceNode, "R.0");
      expect(trace[i()].parent!.sourceNode, "R.0");
      expect(trace[i()].parent!.sourceNode, "R");
      expect(trace[i()].parent!.sourceNode, "R.1");
      expect(trace[i()].parent!.sourceNode, "R.1");
      expect(trace[i()].parent!.sourceNode, "R.1");
      expect(trace[i()].parent!.sourceNode, "R");
      expect(trace[i()].parent!.sourceNode, "R.2");
      expect(trace[i()].parent!.sourceNode, "R.2");
      expect(trace[i()].parent!.sourceNode, "R.2");

      _i = 0;
      expect(trace[i()].subtreeSize, 12);
      expect(trace[i()].subtreeSize, 3);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 3);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 3);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
      expect(trace[i()].subtreeSize, 0);
    });

    test('can walk deep and wide tree', () async {
      final depth = 14;
      print("depth of $depth, width of 3");
      final t0 = DateTime.now();

      int count = 0;
      expect(
        () => count = walkDFS(
          rootNodeSource: "R",
          getChildrenSource: (n) => n.length < 1 + 2 * (depth) //
              ? ["$n.0", "$n.1", "$n.2"]
              : [],
        ).length,
        returnsNormally,
      );
      print("nodeCount: $count");
      print("took: ${DateTime.now().difference(t0)}");
    });
  });

  group('walkParentDFS_try1', () {
    test('test simple map', () {
      final trace = walkDFS(
        rootNodeSource: "R",
        getChildrenSource: (n) => n.length < 5 //
            ? ["$n.0", "$n.1", "$n.2"]
            : [],
      );

      final lastLeaf = trace.last;
      expect(lastLeaf.sourceNode, "R.2.2");
      expect(lastLeaf.parent!.sourceNode, "R.2");

      final traceParent = walkParentDFS_try1(
        startNodeSource: lastLeaf,
        getWalkParentData: (nodeSource) => WalkParentData(
          parent: nodeSource.parent,
          indexInParent: nodeSource.indexInParent,
          parentChildren: nodeSource.parent?.children.toList() ?? [nodeSource],
        ),
        getChildrenSource: (node) => node.children.toList(),
      );

      expect(traceParent.first.sourceNode.sourceNode, lastLeaf.sourceNode);
      expect(traceParent.last.sourceNode.sourceNode, "R");
      expect(traceParent.length, trace.length);
    });
  });

  group('walkParentDFS', () {
    test('test simple map', () {
      final trace = walkDFS(
        rootNodeSource: "R",
        getChildrenSource: (n) => n.length < 5 //
            ? ["$n.0", "$n.1", "$n.2"]
            : [],
      );

      final traceParent = walkParentDFS(
        startNodeSource: trace.last,
        getWalkParentData: (nodeSource) => WalkParentData(
          parent: nodeSource.parent,
          indexInParent: nodeSource.indexInParent,
          parentChildren: nodeSource.parent?.children.toList() ?? [nodeSource],
        ),
        getChildrenSource: (node) => node.children.toList(),
      );

      List<String> _children(TreeNodeDFS<TreeNodeDFS<String>> e) =>
          e.children.map((e) => e.sourceNode.sourceNode).toList();
      String _id(TreeNodeDFS<TreeNodeDFS<String>> e) => e.sourceNode.sourceNode;

      // =================================
      final invertedRoot = traceParent.first;
      expect(_id(invertedRoot), "R.2.2");
      expect(_children(invertedRoot), ["R.2"]);

      // =================================
      final firstParentR2 = invertedRoot.children.first;
      expect(_id(firstParentR2), "R.2");
      expect(_children(firstParentR2), ["R.2.0", "R.2.1", "R"]);

      final childBranchR20 = firstParentR2.children.toList()[0];
      expect(_id(childBranchR20), "R.2.0");
      expect(_children(childBranchR20), []);

      final childBranchR21 = firstParentR2.children.toList()[1];
      expect(_id(childBranchR21), "R.2.1");
      expect(_children(childBranchR21), []);

      // =================================
      final secondParentR = firstParentR2.children.last;
      expect(_id(secondParentR), "R");
      expect(_children(secondParentR), ["R.0", "R.1"]);

      final childBranchR0 = secondParentR.children.toList()[0];
      expect(_id(childBranchR0), "R.0");
      expect(_children(childBranchR0), ["R.0.0", "R.0.1", "R.0.2"]);

      final childBranchR1 = secondParentR.children.toList()[1];
      expect(_id(childBranchR1), "R.1");
      expect(_children(childBranchR1), ["R.1.0", "R.1.1", "R.1.2"]);

      return;
    });
  });
}
