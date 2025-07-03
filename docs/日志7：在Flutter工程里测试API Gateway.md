# 日志7：在Flutter工程里测试API Gateway

## 项目状态回顾

**时间**：2025年7月3日

### 前置条件

- ✅ AWS IAM 用户已创建并配置
- ✅ AWS CLI 已配置 (us-east-1)
- ✅ Amplify CLI 已安装并配置
- ✅ Amplify 项目已初始化 (nirvaapp/dev)
- ✅ API Gateway 和 Lambda 函数已部署
- ✅ curl 测试已通过：`curl "https://2jgsjgyddd.execute-api.us-east-1.amazonaws.com/dev/echo?message=Hello"`

## 任务目标

在 Flutter 应用中使用 Amplify API 调用已部署的 API Gateway，实现与 curl 相同的功能。

## 实现过程

### 1. 项目准备工作

#### 1.1 解决依赖包冲突

升级了 `connectivity_plus` 包版本以兼容新的 `amplify_api` 包：

**pubspec.yaml 修改**：

```yaml
dependencies:
  # ...其他依赖...
  connectivity_plus: ^6.1.4  # 从 ^5.0.2 升级
  amplify_flutter: ^2.4.0
  amplify_api: ^2.4.0        # 新添加
```

#### 1.2 修复 connectivity_plus API 变更

新版本的 `connectivity_plus` API 有变化，修复了相关代码：

**splash_screen.dart 修改**：

```dart
// 修改前
final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {

// 修改后  
final connectivityResults = await Connectivity().checkConnectivity();
if (connectivityResults.contains(ConnectivityResult.none)) {
```

#### 1.3 iOS 构建问题解决

遇到 ConnectivityPlusPlugin 模块冲突错误，通过以下步骤解决：

```bash
# 清理所有缓存
flutter clean
cd ios && rm -rf Pods Podfile.lock .symlinks && pod cache clean --all

# 重新安装依赖
flutter pub get
cd ios && pod install --repo-update

# 构建测试
flutter build ios --simulator
```

### 2. Amplify 配置完善

#### 2.1 在 main.dart 中添加 Amplify 初始化

```dart
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'amplifyconfiguration.dart';

Future<void> _configureAmplify() async {
  try {
    // 添加 Amplify 插件
    await Amplify.addPlugin(AmplifyAPI());
    
    // 配置 Amplify
    await Amplify.configure(amplifyconfig);
    
    safePrint('Successfully configured Amplify');
  } on AmplifyException catch (e) {
    safePrint('Error configuring Amplify: ${e.message}');
  }
}
```

### 3. 实现 API 测试功能

#### 3.1 创建测试页面功能

在 `speech_to_text_test_page.dart` 中实现了 `_testAPIGateway` 函数：

```dart
Future<void> _testAPIGateway() async {
  setState(() {
    _isLoading = true;
    _apiResult = '正在调用 API Gateway...';
  });

  try {
    safePrint('开始调用 Amplify API...');
    
    // 使用 Amplify API 调用 REST 端点
    final restOperation = Amplify.API.get(
      '/echo',
      apiName: 'echoapi',
      queryParameters: {'message': 'Hello'},
    );
    
    final response = await restOperation.response;
    
    if (response.statusCode == 200) {
      final responseBody = response.decodeBody();
      final Map<String, dynamic> jsonData = jsonDecode(responseBody);
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(jsonData);
      
      setState(() {
        _apiResult = '✅ API 调用成功!\n\n📡 请求信息:\n'
            '• API: echoapi\n'
            '• 路径: /echo\n'
            '• 参数: message=Hello\n'
            '• 状态码: ${response.statusCode}\n\n'
            '📄 响应内容:\n$prettyJson';
      });
    }
  } catch (e) {
    // 错误处理...
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
```

#### 3.2 UI 增强

- 添加了加载状态指示器
- 按钮在加载时禁用并显示 "测试中..."
- 结果区域动态显示 API 响应

### 4. 问题排查与解决

#### 4.1 认证配置错误

**问题**：初次测试时出现错误

```shell
ConfigurationError {
  "message": "No auth provider found for auth mode iam.",
  "recoverySuggestion": "Ensure API plugin correctly configured."
}
```

**分析**：

- curl 测试成功说明 API Gateway 本身是开放的

- `amplifyconfiguration.dart` 中配置为 `"authorizationType": "AWS_IAM"`
- 但实际 API 配置为开放访问 (`"setting": "open"`)

**解决**：
修改 `amplifyconfiguration.dart`：

```dart
const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "echoapi": {
                    "endpointType": "REST",
                    "endpoint": "https://2jgsjgyddd.execute-api.us-east-1.amazonaws.com/dev",
                    "region": "us-east-1",
                    "authorizationType": "NONE"  // 从 "AWS_IAM" 改为 "NONE"
                }
            }
        }
    }
}''';
```

## 测试结果

### 成功输出

```shell
flutter: Successfully configured Amplify
flutter: 开始调用 Amplify API...
flutter: API 调用成功，状态码: 200
flutter: 响应内容: {"originalMessage":"Hello","enhancedMessage":"Hello_test","timestamp":"2025-07-03T03:40:42.126Z"}
```

### 应用界面效果

- ✅ 按钮点击后显示加载状态
- ✅ 成功调用 API 并获得预期响应
- ✅ 格式化显示 JSON 结果
- ✅ 与 curl 测试结果完全一致

## 关键经验总结

### 1. 配置一致性很重要

- 确保 `amplifyconfiguration.dart` 中的认证设置与实际 API Gateway 配置一致
- curl 能成功但 Amplify API 失败时，优先检查认证配置差异

### 2. 依赖包版本兼容性

- 升级 Amplify 相关包时，需要同步检查其他依赖包的版本兼容性
- `connectivity_plus` 在新版本中 API 有重大变更

### 3. iOS 构建缓存问题

- 遇到模块冲突时，完整清理缓存和重新安装是有效解决方案
- 顺序：flutter clean → 清理 iOS pods → 重新安装依赖

### 4. 错误诊断思路

- 从简单到复杂：先检查配置，再检查代码
- 对比工作的方法（如 curl）与不工作的方法（如 Amplify API）
- 仔细分析错误信息，通常包含明确的解决提示

## 下一步计划

1. ✅ **基础 API 调用** - 已完成
2. 🔄 **文件上传到 S3** - 待实现
3. 🔄 **S3 事件触发 Lambda** - 待实现  
4. 🔄 **启动 Transcribe 任务** - 待实现
5. 🔄 **获取转写结果** - 待实现

## 项目文件结构

```shell
lib/
├── amplifyconfiguration.dart          # Amplify 配置（已修正认证设置）
├── main.dart                          # 主应用入口（已添加 Amplify 初始化）
├── speech_to_text_test_page.dart      # API 测试页面（已实现完整功能）
└── splash_screen.dart                 # 启动页面（已修复 connectivity 问题）

amplify/
├── backend/
│   ├── api/echoapi/                   # API Gateway 配置
│   └── function/echofunc/             # Lambda 函数
└── cli.json                           # Amplify CLI 配置
```

## 技术栈确认

- ✅ **Flutter**: 3.29.3
- ✅ **Amplify Flutter SDK**: 2.6.1
- ✅ **Amplify API Plugin**: 2.6.1
- ✅ **AWS Lambda**: echofunc-dev (NodeJS)
- ✅ **API Gateway**: echoapi (REST API)
- ✅ **开发环境**: iOS Simulator iPhone 16 Pro
