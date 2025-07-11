/// 转录错误提示常量类
///
/// 提供了针对不同错误类型的详细错误分析和解决方案
class ErrorMessages {
  static const Map<String, Map<String, String>> messages = {
    'apiGateway': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. Cognito Identity Pool 不允许未认证访问\n'
          '2. 需要用户登录后才能调用 API\n'
          '3. Identity Pool 权限配置问题\n'
          '4. API Gateway 权限配置问题',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 在 AWS Console 中启用 Identity Pool 的未认证访问\n'
          '2. 或者实现用户登录功能\n'
          '3. 检查 IAM 角色权限',
    },
    'fileUpload': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. S3 存储桶权限问题\n'
          '2. Cognito Identity Pool 权限不足\n'
          '3. 网络连接问题\n'
          '4. 文件格式或大小限制\n'
          '5. 临时文件创建失败',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶策略\n'
          '2. 确认 Identity Pool 角色权限\n'
          '3. 检查网络连接\n'
          '4. 确认设备存储空间充足',
    },
    'transcriptionNotFound': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 转录任务尚未完成\n'
          '2. 转录任务失败\n'
          '3. 文件路径不正确',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 等待几分钟后重试（转录需要时间）\n'
          '2. 检查 AWS CloudWatch 日志确认 Lambda 执行状态\n'
          '3. 确认 S3 中是否存在转录结果文件',
    },
    'accessDenied': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. S3 存储桶权限问题\n'
          '2. Cognito Identity Pool 权限不足',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶策略\n'
          '2. 确认 Identity Pool 角色权限',
    },
    'general': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 网络连接问题\n'
          '2. 转录结果文件格式异常\n'
          '3. JSON 解析失败',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查网络连接\n'
          '2. 重新上传音频文件\n'
          '3. 检查转录结果文件格式',
    },
    'deletion': {
      'reasons':
          '🔍 可能的原因:\n'
          '1. 文件已被手动删除\n'
          '2. S3 存储桶权限问题\n'
          '3. Cognito Identity Pool 权限不足\n'
          '4. 网络连接问题',
      'solutions':
          '💡 建议解决方案:\n'
          '1. 检查 S3 存储桶中文件是否存在\n'
          '2. 确认删除权限配置\n'
          '3. 检查网络连接',
    },
  };
}
