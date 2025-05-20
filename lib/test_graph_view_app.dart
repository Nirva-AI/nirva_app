import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';

double globalScreenWidth = 0.0; // 全局变量，用于存储屏幕宽度
final double globalGraphBackgroundHeight = 600.0; // 全局变量，用于存储卡片高度
final double globalNodeWidth = 80.0; // 全局变量，用于存储节点宽度
final double globalNodeHeight = 40.0; // 全局变量，用于存储节点高度
final int testNodeCount = 3;

class TestGraphViewApp extends StatelessWidget {
  const TestGraphViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    globalScreenWidth = MediaQuery.of(context).size.width;
    debugPrint('Screen Width: $globalScreenWidth'); // 打印屏幕宽度
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
    // 创建图
    final newGraph = createGraph(testNodeCount);

    setState(() {
      graph = newGraph; // 替换 graph 的引用
      algorithm = CustomFruchtermanReingoldAlgorithm(
        myWidth: globalScreenWidth, // 传入宽度
        myHeight: globalGraphBackgroundHeight, // 传入高度
        nodeWidth: globalNodeWidth, // 传入节点宽度
        nodeHeight: globalNodeHeight, // 传入节点高度
      );
    });
  }

  Graph createGraph(int nodeCount) {
    final newGraph = Graph();
    final random = Random();

    // 创建指定数量的节点
    final nodes = List.generate(
      nodeCount,
      (index) => Node.Id('节点${index + 1}'),
    );

    // 添加节点到图中
    for (var node in nodes) {
      newGraph.addNode(node);
    }

    // 确保每个节点都与节点[0]有一条边
    for (int i = 1; i < nodeCount; i++) {
      newGraph.addEdge(nodes[0], nodes[i]);
    }

    // 随机生成节点之间的连接关系
    for (int i = 0; i < nodeCount; i++) {
      //break;
      // 每个节点随机连接 1 到 nodeCount/2 个其他节点
      final connections = random.nextInt(nodeCount ~/ 2) + 1;
      for (int j = 0; j < connections; j++) {
        final targetIndex = random.nextInt(nodeCount);
        if (targetIndex != i && targetIndex != 0) {
          // 避免重复连接到[0]
          newGraph.addEdge(nodes[i], nodes[targetIndex]);
        }
      }
    }

    return newGraph;
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
                    return GestureDetector(
                      onPanStart: (details) {
                        algorithm.setFocusedNode(node); // 设置拖动的节点为 focusedNode
                      },
                      onPanUpdate: (details) {
                        node.position += details.delta; // 更新节点位置
                        setState(() {}); // 重新渲染
                      },
                      onPanEnd: (details) {
                        algorithm.setFocusedNode(null); // 清除 focusedNode
                      },
                      child: SizedBox(
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
  late double myWidth; // 用来存储宽度
  late double myHeight; // 用来存储高度
  late double nodeWidth; // 用来存储节点宽度
  late double nodeHeight; // 用来存储节点高度

  // 构造函数，用于初始化成员变量
  CustomFruchtermanReingoldAlgorithm({
    required this.myWidth,
    required this.myHeight,
    required this.nodeWidth,
    required this.nodeHeight,
  }) {
    repulsionRate = 1.2; // 增大排斥力
    attractionRate = 0.05; // 减小吸引力
    repulsionPercentage = 0.8; // 增大排斥力作用范围
    attractionPercentage = 0.1; // 减小吸引力作用范围
  }

  @override
  void step(Graph? graph) {
    if (focusedNode != null) {
      return;
    }

    super.step(graph);
    // 使用 shiftCoordinates 方法将整个图形平移到中心区域
    if (graph != null) {
      final offsetToCenter = getOffsetToCenter(graph);
      shiftCoordinates(graph, offsetToCenter.dx, offsetToCenter.dy);
    }
  }

  @override
  void init(Graph? graph) {
    // 这里可以使用 graphWidth 和 graphHeight 来控制区域
    // 例如，你可以在这里设置节点的初始位
    setDimensions(myWidth / 2, myHeight / 2);
    super.init(graph);
  }

  Offset getGraphCenter(Graph graph) {
    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;

    // 遍历所有节点，计算边界
    for (var node in graph.nodes) {
      left = min(left, node.x);
      top = min(top, node.y);
      right = max(right, node.x + node.width);
      bottom = max(bottom, node.y + node.height);
    }

    // 计算中心点
    double centerX = (left + right) / 2;
    double centerY = (top + bottom) / 2;

    return Offset(centerX, centerY);
  }

  Offset getOffsetToCenter(Graph graph) {
    // 计算目标中心位置（例如屏幕中心）
    final targetCenter = Offset(
      myWidth / 2 - nodeWidth,
      myHeight / 2 - nodeHeight,
    );

    // 计算当前节点与目标中心的偏移量
    return targetCenter - getGraphCenter(graph);
  }

  @override
  void setFocusedNode(Node? node) {
    // 这里可以设置当前聚焦的节点
    focusedNode = node;
  }
}
