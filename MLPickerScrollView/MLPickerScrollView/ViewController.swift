//
//  ViewController.swift
//  MLPickerScrollView
//
//  Created by melody on 2019/4/22.
//  Copyright © 2019 melody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
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
    
    fileprivate lazy var dataArray = [MLDemoModel]()
    fileprivate var currentMonthIndex: NSInteger = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setUpUI()
        
    }
    
    fileprivate func setUpUI() {
        
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
        
    }
    
}

extension ViewController: MLPickerScrollViewDataSource,MLPickerScrollViewDelegate {
    
    func numberOfItemAtPickerScrollView(_ pickerScrollView: MLPickerScrollView) -> NSInteger {
        return dataArray.count
    }
    
    func pickerScrollView(pickerScrollView: MLPickerScrollView, itemAtIndex index: NSInteger) -> MLPickerItem {
        // creat
        let item = MLDemoItem.init(frame: CGRect.init(x: 0, y: 0, width: pickerScollView.itemWidth, height: pickerScollView.itemHeight))
        
        // assignment
        let model = dataArray[index]
        model.index = index
        item.title = model.title
        item.setGrayTitle()
        
        // tap
        item.pickerItemSelectBlock = { [weak self](selIndex) in
            self?.pickerScollView.scollToSelectdIndex(selIndex)
        }
        
        return item
    }
    
    func pickerScrollView(menuScrollView: MLPickerScrollView, didSelecteItemAtIndex index: NSInteger) {
        print("当前选中item---\(index)")
    }
    
    func itemForIndexBack(item: MLPickerItem) {
       item.backSizeOfItem()
    }
    
    func itemForIndexChange(item: MLPickerItem) {
        item.changeSizeOfItem()
    }
    
}

