# 日志：测试API Gateway

## 步骤 1: 创建一个 REST API 与 Lambda 函数

我们将使用 Amplify CLI 来创建 API Gateway 和 Lambda 函数。这种方法比直接在 AWS 控制台操作更容易与 Amplify 项目集成。

### 准备工作

首先确认 Amplify CLI 已正确安装并配置：

```bash
amplify --version
```

应该显示 Amplify CLI 的版本号，如 `14.0.0`。

### 添加 API 服务和 Lambda 函数

执行以下命令添加 API 服务和 Lambda 函数到 Amplify 项目：

```bash
amplify add api
```

系统会提示一系列问题，按照以下方式回答：

1. **请选择服务类型**：REST
2. **提供 API 名称**：echoapi
3. **提供 API 的路径**：/echo
4. **选择 Lambda 源**：选择 "Create a new Lambda function"
5. **Lambda 函数名称**：echofunc
6. **选择运行时**：NodeJS
7. **选择模板**：Hello World
8. **配置高级设置**：No
9. **是否要编辑 Lambda 函数现在**：Yes

这将创建一个基本的 API Gateway 配置，包含一个 `/echo` 路径，并且连接到一个新的 Lambda 函数。

### 编辑 Lambda 函数

Lambda 函数的默认代码需要修改，以便它可以接收查询参数并做简单处理。我们修改后的代码如下：

```javascript
/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);
    
    // 从查询字符串参数中获取消息
    const message = event.queryStringParameters && event.queryStringParameters.message 
        ? event.queryStringParameters.message 
        : 'Hello';
    
    // 添加 "_test" 后缀到消息
    const enhancedMessage = message + '_test';
    
    return {
        statusCode: 200,
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*"
        },
        body: JSON.stringify({
            originalMessage: message,
            enhancedMessage: enhancedMessage,
            timestamp: new Date().toISOString()
        }),
    };
};
```

这个 Lambda 函数现在将：

1. 从查询字符串参数中获取 `message` 值
2. 如果没有提供 `message`，则使用默认值 'Hello'
3. 在消息后添加 "_test" 后缀
4. 返回一个 JSON 对象，包含原始消息、增强的消息和时间戳

### 部署资源到云端

编辑完 Lambda 函数后，我们需要将这些资源部署到 AWS 云端：

```bash
amplify push
```

这个命令将会：

1. 创建 Lambda 函数
2. 配置 API Gateway
3. 设置必要的 IAM 权限
4. 将所有资源部署到云端

部署完成后，CLI 会显示生成的 API 端点 URL。

### 测试 API

使用以下命令测试我们的 API：

```bash
curl "https://2jgsjgyddd.execute-api.us-east-1.amazonaws.com/dev/echo?message=Hello"
```

预期的输出应该类似于：

```json
{
  "originalMessage": "Hello",
  "enhancedMessage": "Hello_test",
  "timestamp": "2025-07-02T16:07:45.059Z"
}
```

这表明我们已经成功创建并部署了一个 API Gateway 端点，它能够调用我们的 Lambda 函数，并按照预期处理请求参数。

## 下一步

现在我们已经有了一个基本的 API Gateway 和 Lambda 函数设置，可以继续扩展功能：

1. 添加更多的 API 路径和方法
2. 实现更复杂的业务逻辑
3. 添加身份验证和授权
4. 连接到其他 AWS 服务，如 DynamoDB 或 S3

这个基本设置为使用 Serverless 架构构建更复杂的应用程序提供了良好的基础。
