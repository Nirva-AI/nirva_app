# 请你仔细阅读但前代码。然后完成我的修改需求

## 需求：我希望在底部添加BottomAppBar。

1. BottomAppBar上从左至右有3个按钮。按钮text分别是Smart Diary，Reflections与Dashboard。
2. 按钮的icon请你根据text自选。
3. 按钮的icon与text以垂直方向排列。
4. 【注意】text 与 icon 的size均可以小一些，防止出现overflowed的问题
5. 3和按钮的点击相应分别对应将Scaffold的body导航到不同的内容页上。
  - 第一个页面【Smart Diary】就默认是当前页面。
  - 第2/3个页面的内容可以是简单的文本提示，分别是“Reflections Page”和“Dashboard Page”。
6. 不要改变目前floatingActionButton的设置。



# 好的，目前的修改是可以的。我也做了一定调整。见 floatingActionButton 的部分的修改。我现在有新的需求。我希望调整FloatingActionButton的位置。

## 目标
让FloatingActionButton的位置在BottomAppBar的右上方。
这样就不会挡住BottomAppBar的按钮了。


请再调整下 。
我的目的：floatingActionButton 让其位置在BottomAppBar的外部的右上方。
但是目前的效果是：floatingActionButton 有一部分在 BottomAppBar内，一部分在body内。
我希望是 floatingActionButton 脱离 BottomAppBar的显示区域，并在BottomAppBar右上方显示。



请注意我的代码调整。
我新的需求：是调整 appBar 的 title 的位置。
目标：调整成在appBar内部并靠近左侧的位置。


好的。
请在appBar内添加一个按钮，置于appBar的右侧。按钮只有一个icon。
icon可以选择 表达 ‘to-do list’意图的图标。这个你可以自选。
这个按钮的相应函数有一个打印语句，打印“to-do list”。


# 我希望进一步添加这一段代码的case0 的内容。即——Smart Diary Page

## 代码段
```dart
  Widget _getBodyContent() {
    switch (_selectedPage) {
      case 0:
        return const Center(child: Text('Smart Diary Page'));
      case 1:
        return const Center(child: Text('Reflections Page'));
      case 2:
        return const Center(child: Text('Dashboard Page'));
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }
```

## 我的需求：
1. 将case 0的内容修改为如下：一个页面，居中有一个测试按钮，按钮上文本为“测试按钮”。
2. 点击按钮后，将整个HomePage切换到另外一个空的测试页面。
3. 空的页面有一个返回的按钮，点击后返回到HomePage。