import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class TestGraphViewApp extends StatelessWidget {
  const TestGraphViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Graph View App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TestGraphView(),
    );
  }
}

class TestGraphView extends StatelessWidget {
  const TestGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建图和节点
    final Graph graph = Graph();
    final Node node1 = Node.Id('节点1');
    final Node node2 = Node.Id('节点2');
    final Node node3 = Node.Id('节点3');

    // 添加边
    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3);

    // 配置布局算法
    final BuchheimWalkerConfiguration builder =
        BuchheimWalkerConfiguration()
          ..siblingSeparation = 100
          ..levelSeparation = 150
          ..subtreeSeparation = 150
          ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return Scaffold(
      appBar: AppBar(title: const Text('测试图形视图')),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(8),
          minScale: 0.01,
          maxScale: 5.0,
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(
              builder,
              TreeEdgeRenderer(builder),
            ),
            builder: (Node node) {
              // 自定义节点外观，添加空值检查
              final nodeValue = node.key?.value?.toString() ?? '未知节点';
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(nodeValue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
