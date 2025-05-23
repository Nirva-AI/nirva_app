import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';
import 'package:nirva_app/custom_fruchterman_reingold_algorithm.dart';
import 'package:nirva_app/social_map_page.dart';

class SocialMapGraphCard extends StatefulWidget {
  const SocialMapGraphCard({super.key});

  @override
  State<SocialMapGraphCard> createState() => _SocialMapGraphCardState();
}

class _SocialMapGraphCardState extends State<SocialMapGraphCard> {
  // 图形相关变量
  late Graph graph;
  late CustomFruchtermanReingoldAlgorithm algorithm;
  Key graphKey = UniqueKey();

  // 控制参数
  double screenWidth = 0.0;
  final double graphBackgroundHeight = 600.0;
  final double nodeWidth = 80.0;
  final double nodeHeight = 40.0;
  final int nodeCount = 8;
  bool shouldRandomLinkNodes = false;

  @override
  void initState() {
    super.initState();
    _initializeGraph();
  }

  void _initializeGraph() {
    // 创建图
    final newGraph = createGraph(nodeCount);

    setState(() {
      graph = newGraph;
      algorithm = CustomFruchtermanReingoldAlgorithm(
        myWidth: screenWidth > 0 ? screenWidth : 300, // 默认值以防未初始化
        myHeight: graphBackgroundHeight,
        nodeWidth: nodeWidth,
        nodeHeight: nodeHeight,
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
      _initializeGraph();
      graphKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题和箭头
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Social Map', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    // 添加重置按钮
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _resetGraph,
                    ),
                    // 添加随机连接开关
                    Row(
                      children: [
                        const Text('随机连接', style: TextStyle(fontSize: 12)),
                        Switch(
                          value: shouldRandomLinkNodes,
                          onChanged: (value) {
                            setState(() {
                              shouldRandomLinkNodes = value;
                              _resetGraph();
                            });
                          },
                          //scale: 0.7,
                        ),
                      ],
                    ),
                    // 原有的箭头按钮
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        debugPrint('Social Map arrow clicked!');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SocialMapPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),

            // 图表视图
            SizedBox(
              width: screenWidth,
              height: graphBackgroundHeight,
              child: Card(
                key: graphKey,
                color: Colors.grey[200],
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InteractiveViewer(
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(1000),
                    minScale: 0.01,
                    maxScale: 5.0,
                    child: GraphView(
                      key: ValueKey(graph),
                      graph: graph,
                      algorithm: algorithm,
                      builder: (Node node) {
                        final nodeValue = node.key?.value?.toString() ?? '未知节点';
                        return GestureDetector(
                          onPanStart: (details) {
                            algorithm.setFocusedNode(node);
                          },
                          onPanUpdate: (details) {
                            node.position += details.delta;
                            setState(() {});
                          },
                          onPanEnd: (details) {
                            algorithm.setFocusedNode(null);
                          },
                          child: SizedBox(
                            width: nodeWidth,
                            height: nodeHeight,
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
          ],
        ),
      ),
    );
  }
}
