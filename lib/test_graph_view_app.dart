import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';
import 'package:nirva_app/custom_fruchterman_reingold_algorithm.dart';

double globalScreenWidth = 0.0; // 全局变量，用于存储屏幕宽度
final double globalGraphBackgroundHeight = 600.0; // 全局变量，用于存储卡片高度
final double globalNodeWidth = 80.0; // 全局变量，用于存储节点宽度
final double globalNodeHeight = 40.0; // 全局变量，用于存储节点高度
final int testNodeCount = 8;
bool shouldRandomLinkNodes = false;

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
    if (shouldRandomLinkNodes) {
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
          Row(
            children: [
              const Text('随机连接'),
              Switch(
                value: shouldRandomLinkNodes, // 绑定全局变量 shouldLinkNodes
                onChanged: (value) {
                  setState(() {
                    shouldRandomLinkNodes = value; // 更新 shouldLinkNodes 的状态
                    _resetGraph(); // 切换后重新生成图
                  });
                },
              ),
            ],
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
