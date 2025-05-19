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
    final Node node4 = Node.Id('节点4');

    // 添加边
    graph.addEdge(node1, node2); // 节点1 -> 节点2
    graph.addEdge(node1, node3); // 节点1 -> 节点3
    graph.addEdge(node1, node4); // 节点1 -> 节点4
    graph.addEdge(node2, node3); // 节点2 -> 节点3

    // 使用 FruchtermanReingoldAlgorithm 布局算法
    final FruchtermanReingoldAlgorithm algorithm =
        FruchtermanReingoldAlgorithm();

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
            algorithm: algorithm,
            builder: (Node node) {
              // 自定义节点外观
              final nodeValue = node.key?.value?.toString() ?? '未知节点';
              return Card(
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    nodeValue,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
