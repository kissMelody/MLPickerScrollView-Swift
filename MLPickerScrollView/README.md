# MLPickerScrollView-Swift
## Introduction:
* The easiest way to use PickerScrollView
* 这是一个对横向滚动选择器的自定义UI控件，只要几行代码就可以集成类似横向滚动中间放大的效果并且选中的功能。
 
## Presentation:
#### 模拟场景<选择月日期>
* 效果:有滚动选中中间Item和点击效果Item

![](https://github.com/kissMelody/MLPickerScrollView/blob/master/MLPickerScrollView.gif)

## Usage:
#### 代码例子:选择场景为 选择日期
```swift
用法与tableView类似，但并没有做重用

一、初始化
fileprivate let kItemW: CGFloat = (UIScreen.main.bounds.size.width - 296) / 2 + 118
fileprivate let kItemH: CGFloat = 85

fileprivate lazy var pickerScollView: MLPickerScrollView = {
    let scrollView = MLPickerScrollView.init(frame: CGRect.init(x: 0, y: SCREEN_HEIGHT - 350, width: SCREEN_WIDTH, height: kItemH))
    scrollView.backgroundColor = .white
    scrollView.itemWidth = kItemW
    scrollView.itemHeight = kItemH
    scrollView.firstItemX = (scrollView.frame.size.width - scrollView.itemWidth) * 0.5
    scrollView.dataSource = self
    scrollView.delegate = self
    return scrollView
}()

二、用法

// 1.数据源
let titleArray = ["2018.10","2018.11","2018.12","2019.01","2019.02","2019.03","2019.04","2019.05","2019.06","2019.07","2019.08","2019.09"]

for (i,title) in titleArray.enumerated() {
    let model = MLDemoModel()
    model.title = title
    model.index = i
    if title == "2019.04" {
    model.isCurrentMonth = true
    currentMonthIndex = i
}else{
    model.isCurrentMonth = false
}
    dataArray.append(model)
}

// 2.初始化
view.addSubview(pickerScollView)

// 3.刷新数据
pickerScollView.reloadData()

// 4.滚动到当前月份
var number: NSInteger = 0
for (i,model) in dataArray.enumerated() {
    if model.index == currentMonthIndex {
    number = i
    }
}

pickerScollView.seletedIndex = number
pickerScollView.scollToSelectdIndex(number)

三、滚动或点击选中日期代理
func pickerScrollView(menuScrollView: MLPickerScrollView, didSelecteItemAtIndex index: NSInteger) {
    print("当前选中item---\(index)")
}

```
## Requirement:
* Swfit5 以上
* iOS12.2以上
* Xcode 10.2.1
