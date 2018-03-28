//
//  YJScrollPageView.swift
//  CloudPlatform
//
//  Created by o dream boy on 2018/3/28.
//  Copyright © 2018年 冯垚杰. All rights reserved.
//

import UIKit

public class YJScrollPageView: UIView {
    static let cellId = "cellId"
    private var segmentStyle = YJScrollSegmentStyle()
    /// 附加按钮点击响应
    public var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)? {
        didSet {
            segView.extraBtnOnClick = extraBtnOnClick
        }
    }
    
    private(set) var segView: YJScrollSegmentView!
    private(set) var contentView: YJScrollContentView!
    private var titlesArray: [String] = []
    /// 所有的子控制器
    private var childVcs: [UIViewController] = []
    // 这里使用weak避免循环引用
    private weak var parentViewController: UIViewController?
    
    public init(frame:CGRect, segmentStyle: YJScrollSegmentStyle, titles: [String], childVcs:[UIViewController], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
        assert(childVcs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        segView = YJScrollSegmentView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), segmentStyle: segmentStyle, titles: titlesArray)
        
        guard let parentVc = parentViewController else { return }
        
        contentView = YJScrollContentView(frame: CGRect(x: 0, y: segView.frame.maxY, width: bounds.size.width, height: bounds.size.height - 44), childVcs: childVcs, parentViewController: parentVc)
        contentView.delegate = self
        
        addSubview(segView)
        addSubview(contentView)
        // 避免循环引用
        segView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            // 切换内容显示(update content)
            
            self.contentView.setContentOffSet(offSet: CGPoint(x: Double(self.contentView.frame.width) * Double(index), y: 0), animated: self.segmentStyle.changeContentAnimated)
            
        }
    }
    
    deinit {
        parentViewController = nil
    }
    
    
}

//MARK: - public helper
extension YJScrollPageView {
    
    /// 给外界设置选中的下标的方法(public method to set currentIndex)
    public func selectedIndex(selectedIndex: Int, animated: Bool) {
        // 移动滑块的位置
        segView.selectedIndex(selectedIndex: selectedIndex, animated: animated)
        
    }
    
    ///   给外界重新设置视图内容的标题的方法,添加新的childViewControllers
    /// (public method to reset childVcs)
    ///  - parameter titles:      newTitles
    ///  - parameter newChildVcs: newChildVcs
    public func reloadChildVcsWithNewTitles(titles: [String], andNewChildVcs newChildVcs: [UIViewController]) {
        self.childVcs = newChildVcs
        self.titlesArray = titles
        
        segView.reloadTitlesWithNewTitles(titles: titlesArray)
        contentView.reloadAllViewsWithNewChildVcs(newChildVcs: childVcs)
    }
}

extension YJScrollPageView: YJScrollContentViewDelegate {
    
    public var segmentView: YJScrollSegmentView {
        return segView
    }
}

