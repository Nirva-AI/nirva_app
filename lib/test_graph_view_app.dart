import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

double globalScreenWidth = 0.0; // 全局变量，用于存储屏幕宽度
final double globalGraphBackgroundHeight = 600.0; // 全局变量，用于存储卡片高度
final double globalNodeWidth = 100.0; // 全局变量，用于存储节点宽度
final double globalNodeHeight = 40.0; // 全局变量，用于存储节点高度

class TestGraphViewApp extends StatelessWidget {
  const TestGraphViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    globalScreenWidth = MediaQuery.of(context).size.width;
    debugPrint('Screen Width: $globalScreenWidth'); // 打印屏幕宽度
    //flutter: Screen Width: 402.0
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
  Key cardKey = UniqueKey(); // 用于强制重新构建 Card

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
      algorithm = CustomFruchtermanReingoldAlgorithm(
        rootNode: node1, // 传入 node1
        myWidth: globalScreenWidth, // 传入宽度
        myHeight: globalGraphBackgroundHeight, // 传入高度
        nodeWidth: globalNodeWidth, // 传入节点宽度
        nodeHeight: globalNodeHeight, // 传入节点高度
      );
    });
  }

  void _resetGraph() {
    setState(() {
      _initializeGraph(); // 重新初始化图
      cardKey = UniqueKey(); // 更新 key，强制重新构建 Card
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
        child: SizedBox(
          width: globalScreenWidth, // 设置宽度为屏幕宽度
          height: globalGraphBackgroundHeight, // 固定高度为 600
          child: Card(
            key: cardKey, // 使用动态 key 强制重新构建 Card
            color: Colors.grey[200],
            elevation: 4,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(1000),
                minScale: 0.01,
                maxScale: 5.0,
                child: GraphView(
                  key: ValueKey(graph), // 强制重新构建 GraphView
                  graph: graph,
                  algorithm: algorithm,
                  builder: (Node node) {
                    final nodeValue = node.key?.value?.toString() ?? '未知节点';
                    return SizedBox(
                      width: globalNodeWidth, // 设置宽度
                      height: globalNodeHeight, // 设置高度
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
      ),
    );
  }
}

class CustomFruchtermanReingoldAlgorithm extends FruchtermanReingoldAlgorithm {
  late Node rootNode; // 用来存储 node1
  late double myWidth; // 用来存储宽度
  late double myHeight; // 用来存储高度
  late double nodeWidth; // 用来存储节点宽度
  late double nodeHeight; // 用来存储节点高度

  // 构造函数，用于初始化成员变量
  CustomFruchtermanReingoldAlgorithm({
    required this.rootNode,
    required this.myWidth,
    required this.myHeight,
    required this.nodeWidth,
    required this.nodeHeight,
  });

  // 你可以在这里扩展算法逻辑，利用 graphWidth 和 graphHeight 控制区域
  @override
  Size run(Graph? graph, double shiftX, double shiftY) {
    return super.run(graph, offsetToCenter.dx, offsetToCenter.dy);
  }

  @override
  void step(Graph? graph) {
    super.step(graph);
    // 使用 shiftCoordinates 方法将整个图形平移到中心区域
    if (graph != null) {
      shiftCoordinates(graph, offsetToCenter.dx, offsetToCenter.dy);
    }
  }

  @override
  void init(Graph? graph) {
    // 这里可以使用 graphWidth 和 graphHeight 来控制区域
    // 例如，你可以在这里设置节点的初始位
    super.init(graph);
  }

  //
  Offset get offsetToCenter {
    // 计算目标中心位置（例如屏幕中心）
    final targetCenter = Offset(
      myWidth / 2 - nodeWidth,
      myHeight / 2 - nodeHeight,
    );

    // 计算当前节点与目标中心的偏移量
    return targetCenter - rootNode.position;
  }
}
