import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphview/GraphView.dart';
import 'package:nirva_app/custom_fruchterman_reingold_algorithm.dart';
import 'package:nirva_app/social_map_page.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/data.dart';

class SocialMapCard extends StatefulWidget {
  const SocialMapCard({super.key});

  @override
  State<SocialMapCard> createState() => _SocialMapCardState();
}

class _SocialMapCardState extends State<SocialMapCard> {
  // 图形相关变量
  late Graph graph;
  late CustomFruchtermanReingoldAlgorithm algorithm;
  Key graphKey = UniqueKey();

  // 控制参数
  double screenWidth = 0.0;
  final double graphBackgroundHeight = 400.0;
  final double nodeWidth = 100.0;
  final double nodeHeight = 40.0;

  @override
  void initState() {
    super.initState();
    _initializeGraph();
  }

  void _initializeGraph() {
    // 创建图
    final newGraph = createGraph();

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

  Graph createGraph() {
    final newGraph = Graph();

    User user = context.read<UserProvider>().user;
    final journalFilesProvider = context.read<JournalFilesProvider>();
    Node userNode = Node.Id(user.displayName);
    newGraph.addNode(userNode);

    for (var peoplesName
        in journalFilesProvider.currentJournalFile.peoples_involved) {
      Node node = Node.Id(peoplesName);
      newGraph.addNode(node);
      newGraph.addEdge(userNode, node);
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
              // 用 SizedBox 替代 Container
              key: graphKey,
              width: screenWidth,
              height: graphBackgroundHeight,
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
                        //algorithm.setFocusedNode(node);
                      },
                      onPanUpdate: (details) {
                        // node.position += details.delta;
                        // setState(() {});
                      },
                      onPanEnd: (details) {
                        //algorithm.setFocusedNode(null);
                      },
                      child: SizedBox(
                        width: nodeWidth,
                        height: nodeHeight,
                        child: Card(
                          color: _parseNodeColor(nodeValue),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                nodeValue,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
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
          ],
        ),
      ),
    );
  }

  Color? _parseNodeColor(String nodeName) {
    // 根据节点名称返回不同的颜色
    if (nodeName == context.read<UserProvider>().user.displayName) {
      return Colors.yellow[100];
    }

    final journalFilesProvider = context.read<JournalFilesProvider>();
    SocialEntity entity = journalFilesProvider.currentJournalFile
        .getSocialEntity(nodeName);
    return Color(entity.color);
  }
}
