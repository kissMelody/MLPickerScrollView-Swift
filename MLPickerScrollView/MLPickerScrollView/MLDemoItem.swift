//
//  MLDemoItem.swift
//  MLPickerScrollView
//
//  Created by melody on 2019/4/22.
//  Copyright © 2019 melody. All rights reserved.
//

import UIKit

class MLDemoItem: MLPickerItem {


    public var title: String? {
        didSet{
            btn.setTitle(title, for: .normal)
        }
    }
    
    public lazy var btn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.isEnabled = false
        return button
    }()
    
    fileprivate let kITEM_W: CGFloat = (UIScreen.main.bounds.size.width - 296) / 2 + 118
    fileprivate let kITEM_H: CGFloat = 38
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    fileprivate func setUI() {
        let itemW: CGFloat = kITEM_W
        let itemH: CGFloat = kITEM_H
        let itemX: CGFloat = (frame.width - itemW) * 0.5
        let itemY: CGFloat = (frame.height - itemH) * 0.5
        btn.frame = CGRect.init(x: itemX, y: itemY, width: itemW, height: itemH)
        
        addSubview(btn)
    }
    
    // MARK: - Public method
    open func setBlackTitle() {
        btn.setTitleColor(.black, for: .normal)
    }
    
    open func setGrayTitle() {
        btn.setTitleColor(.lightGray, for: .normal)
    }
    
    override func changeSizeOfItem() {
        setBlackTitle()
    }
    
    override func backSizeOfItem() {
        setGrayTitle()
    }
}
