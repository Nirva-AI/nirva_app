

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);
    
    // 获取查询参数
    const queryParams = event.queryStringParameters || {};
    const message = queryParams.message || "Hello";
    
    // 添加"test"字符串
    const enhancedMessage = `${message}_test`;
    
    // 准备响应
    const response = {
        originalMessage: message,
        enhancedMessage: enhancedMessage,
        timestamp: new Date().toISOString()
    };
    
    return {
        statusCode: 200,
        // 启用CORS请求
        headers: {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*"
        },
        body: JSON.stringify(response),
    };
};
