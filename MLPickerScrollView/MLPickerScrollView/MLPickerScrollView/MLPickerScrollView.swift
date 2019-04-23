//
//  MLPickerScrollView.swift
//  MLPickerScrollView
//
//  Created by melody on 2019/4/22.
//  Copyright © 2019 melody. All rights reserved.
//

import UIKit

// MARK: - 代理
@objc protocol MLPickerScrollViewDelegate: NSObjectProtocol {
    /// 选中某个Item
    @objc optional func pickerScrollView(menuScrollView: MLPickerScrollView, didSelecteItemAtIndex index: NSInteger) -> Void
    /// 改变中心位置的Item样式
    @objc optional func itemForIndexChange(item: MLPickerItem) -> Void
    /// 改变-非-中心位置的Item样式
    @objc optional func itemForIndexBack(item: MLPickerItem) -> Void
}

// MARK: - 数据源
protocol MLPickerScrollViewDataSource: NSObjectProtocol {
    /// 个数
    func numberOfItemAtPickerScrollView(_ pickerScrollView: MLPickerScrollView) ->NSInteger
    /// 用来创建MLPickerItem
    func pickerScrollView(pickerScrollView: MLPickerScrollView, itemAtIndex index: NSInteger) ->MLPickerItem
}

class MLPickerScrollView: UIView {
    
    // MARK: -  open var
    weak var delegate: MLPickerScrollViewDelegate?
    weak var dataSource: MLPickerScrollViewDataSource?
    
    /// 选中下标
    public var seletedIndex: NSInteger = 0
    /// menu宽
    public var itemWidth: CGFloat = 50
    /// menu高
    public var itemHeight: CGFloat = 50
    /// 第一个item X值
    public var firstItemX: CGFloat = 10
    
    fileprivate let kAnimationTime: TimeInterval = 0.2
    
    // MARK: - private var
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.showsVerticalScrollIndicator = false
        scrollV.delegate = self
        scrollV.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.5)
        scrollV.backgroundColor = .clear
        return scrollV
    }()
    
    fileprivate lazy var items = [MLPickerItem]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Pubulic Method
    /// 刷新数据
    open func reloadData() {
    
        // remove
        for item in items {
            item.removeFromSuperview()
        }
        
        items.removeAll()
        
        // create
        var count: NSInteger = 0
        if dataSource != nil {
            count = dataSource?.numberOfItemAtPickerScrollView(self) ?? 0
        }
        
        for i in 0..<count {
            var item = MLPickerItem()
            if dataSource != nil {
                item = dataSource?.pickerScrollView(pickerScrollView: self, itemAtIndex: i) ?? MLPickerItem()
            }
//            assert(item == nil, "pickerScrollView(pickerScrollView: MLPickerScrollView, itemAtIndex index: NSInteger) can not nil")
            item.originalSize = CGSize.init(width: itemWidth, height: itemHeight)
            items.append(item)
            scrollView.addSubview(item)
            item.index = i
        }
        
        // layout
        layoutItems()
        
    }
    
    /// 滚动到对应选中的下标位置
    open func scollToSelectdIndex(_ index: NSInteger) {
        selectItemAtIndex(index: index)
    }
    
}

// MARK: - UI
extension MLPickerScrollView: UIScrollViewDelegate {
    
    fileprivate func setUp() {
        
        firstItemX = 0
        addSubview(scrollView)
        
    }
    
    // MARK: - layout Items
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard items.count > 0 else {
            return
        }
        
        layoutItems()
    }
    
    fileprivate func layoutItems() {
        // 1.layout
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        scrollView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        // 2.item起始X值
        var startX: CGFloat = firstItemX
        for item in items {
            item.frame = CGRect.init(x: startX, y: height - itemHeight, width: itemWidth, height: itemHeight)
            startX += self.itemWidth
        }
        
        // 3.set contentSize
        scrollView.contentSize = CGSize.init(width: max(startX + width - firstItemX - itemWidth * 0.5, startX), height: height)
        
        // 4.set center item
        setItemAtContentOffset(scrollView.contentOffset)
        
    }
    
}

// MARK: - Hepler
extension MLPickerScrollView {
    
    /// 根据scrollView的contentoffset来判断 是哪个item处于中心点区域， 然后传出去通知外面
    fileprivate func setItemAtContentOffset(_ offset: CGPoint) {
        let centerIndex: NSInteger = NSInteger(roundf(Float(offset.x / itemWidth)))
        
        for (i,item) in items.enumerated() {
            itemInCenterBack(item)
            
            if centerIndex == i {
                itemInCenterChange(item)
                seletedIndex = centerIndex
            }
        }
        
    }
    
    /// 滚动到相应位置
    fileprivate func scollToItemViewAtIndex(index: NSInteger, animated: Bool) {
        let point = CGPoint.init(x: CGFloat(index) * itemWidth, y: scrollView.contentOffset.y)
        UIView.animate(withDuration: kAnimationTime, animations: {
            self.scrollView.setContentOffset(point, animated: true)
        }) { (finished) in
            self.setItemAtContentOffset(point)
        }
    }
    
    /// 设置中心点位置
    fileprivate func setCenterContentOffset(scollView: UIScrollView) {
        var offsetX = scollView.contentOffset.x
        if offsetX < 0 {
            offsetX = itemWidth * 0.5
        }
        else if offsetX > CGFloat(items.count - 1) * itemWidth {
            offsetX = CGFloat((self.items.count - 1)) * itemWidth
        }
        
        let value: NSInteger = NSInteger(roundf(Float(offsetX / itemWidth)))
        UIView.animate(withDuration: kAnimationTime, animations: {
            self.scrollView.setContentOffset(CGPoint.init(x: self.itemWidth * CGFloat(value), y: self.scrollView.contentOffset.y), animated: true)
        }) { (finished) in
            if self.delegate != nil {
                let centerIndex: NSInteger = NSInteger(roundf(Float(self.scrollView.contentOffset.x / self.itemWidth)))
                self.delegate?.pickerScrollView!(menuScrollView: self, didSelecteItemAtIndex: centerIndex)
            }
            self.setItemAtContentOffset(scollView.contentOffset)
        }
    }
    
}

// MARK: - Delegate
extension MLPickerScrollView {
    
    fileprivate func selectItemAtIndex(index: NSInteger) {
        seletedIndex = index
        scollToItemViewAtIndex(index: seletedIndex, animated: true)
        
        if delegate != nil {
            delegate?.pickerScrollView!(menuScrollView: self, didSelecteItemAtIndex: seletedIndex)
        }
    }
    
    fileprivate func itemInCenterChange(_ item: MLPickerItem) {
        if delegate != nil {
            delegate?.itemForIndexChange!(item: item)
        }
    }
    
    fileprivate func itemInCenterBack(_ item: MLPickerItem) {
        if delegate != nil {
            delegate?.itemForIndexBack!(item: item)
        }
    }
    
}

// MARK: - ScrollViewDelegate
extension MLPickerScrollView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerIndex: NSInteger = NSInteger(roundf(Float(scrollView.contentOffset.x / itemWidth)))

        for (i,item) in items.enumerated() {
            if centerIndex == i {
                 itemInCenterChange(item)
            }else{
                 itemInCenterBack(item)
            }
        }
    }
    
    /// 手指离开屏幕后ScrollView还会继续滚动一段时间直到停止 时执行
    /// 如果需要scrollview在停止滑动后一定要执行某段代码的话应该搭配scrollViewDidEndDragging函数使用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCenterContentOffset(scollView: scrollView)
    }
    
    ///  UIScrollView真正停止滑动，应该怎么判断: 当decelerate = true时，才会调UIScrollView的delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setCenterContentOffset(scollView: scrollView)
        }
    }
    
}

// MARK: - MLPickerItem
//////////////////////////////// - MLPickerItem -///////////////////////////////////////
class MLPickerItem: UIView {
    
    /// selected closer
    var pickerItemSelectBlock: ((_ index: NSInteger)->())?
    
    // MARK: - Property
    /// tag
    public var index: NSInteger = 0
    /// item original size
    public var originalSize: CGSize = CGSize.zero
    /// item is selected
    public var selected: Bool = false
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        addGestureRecognizer(tapGes)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        if let back = self.pickerItemSelectBlock {
            back(index)
        }
    }
    
    // MARK: - For subview use
    open func changeSizeOfItem() {}
    
    open func backSizeOfItem() {}
    
}
