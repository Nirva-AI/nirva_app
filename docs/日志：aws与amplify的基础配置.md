# 日志：aws与amplify的基础配置

## 首先清空所有aws与amplify的配置，并保证aws-cli和amplify-cli正确安装，再进行后续操作

```bash
# 相关的命令
aws --version
amplify --version
aws configure list
rm -rf ~/.aws
```

## 什么是IAM用户？为什么需要创建IAM用户？

### Root账户 vs IAM用户

**Root账户（根账户）**：

- 这是你注册AWS时创建的主账户
- 拥有对整个AWS账户的完全访问权限
- 可以做任何事情，包括删除整个账户、修改计费信息等
- 相当于系统管理员的"超级用户"权限

**IAM用户（Identity and Access Management用户）**：

- 是在你的AWS账户内创建的子用户
- 可以被分配特定的权限（比如只能访问某些服务）
- 用于日常开发和操作任务
- 遵循"最小权限原则"

### 为什么不直接使用Root账户？

1. **安全性考虑**：Root账户权限过大，如果凭证泄露会造成严重后果
2. **最佳实践**：AWS官方强烈建议不要在日常开发中使用Root账户
3. **权限控制**：IAM用户可以精确控制权限，只给予必要的访问权限
4. **审计追踪**：每个IAM用户的操作都可以独立追踪

### 创建IAM用户的步骤

1. **登录AWS控制台**（使用Root账户）
2. **进入IAM服务**
3. **创建新用户**
4. **分配必要权限**
5. **获取访问密钥**

## 创建一个IAM用户

### 步骤1：登录AWS控制台并进入IAM服务

1. 使用你的Root账户登录AWS控制台
2. 在服务搜索框中输入"IAM"
3. 点击进入IAM服务

### 步骤2：创建新用户

1. 在IAM控制台左侧导航栏中，点击"用户"
2. 点击"创建用户"按钮
3. 输入用户名（建议：`amplify-developer` 或 `nirva-app-dev`）
4. 选择"为用户提供对AWS管理控制台的访问权限"（可选）
5. 设置控制台密码（如果需要控制台访问）

### 步骤3：设置权限

对于Amplify开发，建议使用以下权限策略：

#### 方法1：使用AWS托管策略（推荐）

- `AdministratorAccess-Amplify`：专门为Amplify设计的权限
- `IAMFullAccess`：管理IAM资源的权限

#### 方法2：自定义权限（更安全）

- 根据项目需要逐步添加权限

### 步骤4：创建访问密钥

1. 用户创建完成后，进入用户详情页
2. 点击"安全凭证"标签页
3. 点击"创建访问密钥"
4. 选择"命令行界面(CLI)"
5. 下载或记录 Access Key ID 和 Secret Access Key

### 重要提醒

⚠️ **访问密钥安全提醒**：

- 访问密钥只会显示一次，请妥善保存
- 不要将访问密钥提交到代码仓库  
- 定期轮换访问密钥
- 如果泄露，立即在IAM控制台中禁用

## 关系图示

```text
AWS账户 (Root)
├── IAM用户1 (amplify-developer)
│   ├── 访问密钥对
│   └── 权限策略
├── IAM用户2 (其他开发者)
└── AWS资源 (S3, Lambda, API Gateway等)
```

## 下一步

创建IAM用户后，我们将：

1. 使用IAM用户的访问密钥配置AWS CLI
2. 配置Amplify CLI
3. 初始化Amplify项目

---

## 实际操作记录

### ✅ 第一阶段：IAM用户创建完成

- **日期**：2025年7月2日
- **用户名**：`nirva-app-dev`
- **状态**：已成功创建
- **下一步**：配置AWS CLI

### ✅ 第二阶段：配置AWS CLI

**准备工作已完成**：

1. **访问密钥状态**：✅ 已创建并下载CSV文件
2. **权限策略**：✅ 已配置以下权限：
   - `AdministratorAccess-Amplify`
   - `IAMFullAccess`
   - `IAMUserChangePassword`
3. **区域选择**：✅ us-east-1

#### 配置AWS CLI的步骤

我们将使用以下命令来配置AWS CLI：

```bash
aws configure
```

需要输入的信息：

- **AWS Access Key ID**：你的访问密钥ID
- **AWS Secret Access Key**：你的秘密访问密钥  
- **Default region name**：建议使用 `us-east-1`
- **Default output format**：建议使用 `json`

#### ✅ AWS CLI配置结果

**配置成功**！验证信息：

```bash
# 验证配置
aws configure list
aws sts get-caller-identity
```

**结果确认**：

- **用户身份**：nirva-app-dev
- **账户ID**：256105712922  
- **区域**：us-east-1
- **输出格式**：json
- **状态**：✅ 配置成功，连接正常

---

### 第三阶段：配置Amplify CLI

## AWS CLI vs Amplify CLI - 新手必知

### 什么是CLI？

**CLI**（Command Line Interface）= 命令行界面，就是在终端中输入命令来操作的工具。

### AWS CLI vs Amplify CLI 的关系

#### AWS CLI（基础层）

- **定义**：AWS官方提供的通用命令行工具
- **作用**：可以操作AWS的所有服务（S3、EC2、Lambda、IAM等200+服务）
- **特点**：功能全面但使用复杂，需要你了解具体的AWS服务细节
- **举例**：

  ```bash
  # 创建S3存储桶
  aws s3 mb s3://my-bucket
  # 查看IAM用户
  aws iam list-users
  # 部署Lambda函数
  aws lambda create-function --function-name MyFunction...
  ```

#### Amplify CLI（专业层）

- **定义**：专门为全栈应用开发设计的命令行工具
- **作用**：简化常见的应用开发任务（认证、API、存储、托管等）
- **特点**：高级抽象，一个命令背后会自动配置多个AWS服务
- **举例**：

  ```bash
  # 一个命令添加用户认证功能（背后会创建Cognito、IAM角色等）
  amplify add auth
  # 一个命令添加API（背后会创建API Gateway、Lambda、DynamoDB等）
  amplify add api
  # 一个命令部署整个应用
  amplify push
  ```

### 形象比喻

想象建房子：

- **AWS CLI** = 各种专业工具（锤子、螺丝刀、电钻、切割机...）
  - 每个工具都很专业，但需要你知道什么时候用哪个
  - 灵活但复杂

- **Amplify CLI** = 电动工具套装（一体化工具）
  - 一个工具可以完成多项任务
  - 简单易用，但功能相对固定

### 依赖关系

```text
你的Flutter应用
       ↓
   Amplify CLI (高级工具)
       ↓
    AWS CLI (基础工具)
       ↓
    AWS服务 (云资源)
```

**重要关系**：

1. **Amplify CLI 依赖 AWS CLI**：Amplify CLI在后台使用AWS CLI来创建和管理AWS资源
2. **AWS CLI 提供认证**：我们刚才配置的AWS CLI为Amplify CLI提供了访问AWS的凭证
3. **Amplify CLI 简化操作**：让你不需要直接使用复杂的AWS CLI命令

### 为什么需要两个都配置？

1. **AWS CLI**：提供基础的AWS账户连接和认证
2. **Amplify CLI**：使用AWS CLI的认证来简化应用开发

### 实际工作流程

当你运行 `amplify add auth` 时，背后发生的事情：

```text
你：amplify add auth
 ↓
Amplify CLI：理解你要添加认证功能
 ↓
Amplify CLI：调用AWS CLI创建以下资源：
 - aws cognito-idp create-user-pool
 - aws iam create-role  
 - aws iam attach-role-policy
 - ... (更多命令)
 ↓
结果：完整的用户认证系统就绪
```

如果直接用AWS CLI，你需要手动运行十几个命令才能达到同样效果！

下一步我们需要配置Amplify CLI，让它能够使用我们刚才配置的AWS CLI凭证。

## 配置Amplify CLI的步骤

### 步骤1：配置Amplify CLI

Amplify CLI配置命令：

```bash
amplify configure
```

**这个命令会做什么？**

- 验证你的AWS CLI配置
- 设置Amplify CLI的默认配置
- 为你的项目准备Amplify环境

**预期的交互过程**：

1. 会检测到你已配置的AWS CLI凭证
2. 询问你要使用的AWS区域（我们会选择us-east-1）
3. 可能会询问默认的编辑器选择
4. 确认配置信息

### 步骤2：验证配置

配置完成后，我们会验证：

```bash
amplify --version
amplify status
```

---

## 开始配置

**⚠️ 重要提醒**：

- 配置过程中如果遇到任何问题或疑问，随时告诉我
- 每个选择都会影响后续的项目配置，有疑问就暂停

**准备好了吗？** 请确认是否开始运行 `amplify configure` 命令。

### ✅ Amplify CLI配置成功

**配置过程记录**：

1. ✅ 选择区域：us-east-1
2. ✅ 输入访问密钥：使用nirva-app-dev用户的密钥
3. ✅ 配置文件：使用默认配置文件名
4. ✅ 配置完成：成功设置新用户

**验证结果**：

```bash
amplify status
# 返回：No Amplify backend project files detected
# 这是正常的，说明CLI配置成功，只是项目还未初始化
```

**状态确认**：

- **Amplify CLI版本**：14.0.0 ✅
- **AWS连接**：正常 ✅  
- **用户凭证**：nirva-app-dev ✅
- **区域配置**：us-east-1 ✅
- **下一步**：初始化Amplify项目

---

### 第四阶段：初始化Amplify项目

现在我们可以在Flutter项目中初始化Amplify了。
