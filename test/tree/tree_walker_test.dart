import 'dart:math';

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

  group('walkParentDFS', () {
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

      final traceParent = walkParentDFS(
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
}
