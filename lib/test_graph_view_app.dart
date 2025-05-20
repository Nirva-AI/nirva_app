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

class TestGraphView extends StatefulWidget {
  const TestGraphView({super.key});

  @override
  State<TestGraphView> createState() => _TestGraphViewState();
}

class _TestGraphViewState extends State<TestGraphView> {
  late Graph graph;
  late CustomFruchtermanReingoldAlgorithm algorithm;

  @override
  void initState() {
    super.initState();
    _initializeGraph();
  }

  void _initializeGraph() {
    final newGraph = Graph(); // 创建新的 Graph 对象
    final Node node1 = Node.Id('节点1');
    final Node node2 = Node.Id('节点2');
    final Node node3 = Node.Id('节点3');
    final Node node4 = Node.Id('节点4');

    newGraph.addEdge(node1, node2);
    newGraph.addEdge(node1, node3);
    newGraph.addEdge(node1, node4);
    newGraph.addEdge(node2, node3);

    setState(() {
      graph = newGraph; // 替换 graph 的引用
      algorithm = CustomFruchtermanReingoldAlgorithm(); // 替换 algorithm 的引用
    });
  }

  void _resetGraph() {
    setState(() {
      _initializeGraph(); // 重新初始化图
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试图形视图'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGraph, // 点击按钮时重置图
          ),
        ],
      ),
      body: Center(
        child: Card(
          color: Colors.grey[200],
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.0,
              child: GraphView(
                key: ValueKey(graph), // 强制重新构建 GraphView
                graph: graph,
                algorithm: algorithm,
                builder: (Node node) {
                  final nodeValue = node.key?.value?.toString() ?? '未知节点';
                  return SizedBox(
                    width: 100, // 设置宽度
                    height: 40, // 设置高度
                    child: Card(
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            nodeValue,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFruchtermanReingoldAlgorithm extends FruchtermanReingoldAlgorithm {
  // 暂时不覆盖或扩展任何方法
}
