//
//  ListDelegate.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit
import Combine

public enum ListScrollDirection {
    case idl
    case up
    case down
    case left
    case right
}

public enum ListScrollStatus {
    case idl
    case scrolling
    case ending
}

public class ListCommonDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
    
    weak var commonAdapter: ListCommonAdapter?
    
    // 滚动速率
    @Published public var scrollSpeed: CGFloat = 0
    
    // 当前的偏移值
    @Published public var lastContentOffset: CGPoint = .zero
    
    // 滚动方向
    @Published public var scrollDirection: ListScrollDirection = .idl
    
    // 用户触摸行为或带有偏移动画行为
    @Published public var scrollStatus: ListScrollStatus = .idl
    
    public init(commonAdapter: ListCommonAdapter) {
        self.commonAdapter = commonAdapter
    }
}

extension ListCommonDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        commonAdapter?.listDidScrollClosure?(scrollView)
        
        if lastContentOffset.y > scrollView.contentOffset.y {
            scrollDirection = .up
            scrollSpeed = lastContentOffset.y - scrollView.contentOffset.y
        } else if lastContentOffset.y < scrollView.contentOffset.y {
            scrollDirection = .down
            scrollSpeed = scrollView.contentOffset.y - lastContentOffset.y
        } else if lastContentOffset.x > scrollView.contentOffset.x {
            scrollDirection = .left
            scrollSpeed = lastContentOffset.x - scrollView.contentOffset.x
        } else if lastContentOffset.x < scrollView.contentOffset.x {
            scrollDirection = .right
            scrollSpeed = scrollView.contentOffset.x - lastContentOffset.x
        } else {
            scrollDirection = .idl
            scrollSpeed = 0
        }
        lastContentOffset = scrollView.contentOffset
        
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        commonAdapter?.listDidZoomClosure?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        commonAdapter?.listWillBeginDraggingClosure?(scrollView)
        
        scrollStatus = .scrolling
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        commonAdapter?.listWillEndDraggingClosure?(scrollView, velocity, targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        commonAdapter?.listDidEndDraggingClosure?(scrollView, decelerate)
        
        if !decelerate {
            scrollStatus = .ending
        }
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        commonAdapter?.listWillBeginDeceleratingClosure?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        commonAdapter?.listDidEndDeceleratingClosure?(scrollView)
        
        scrollStatus = .ending
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        commonAdapter?.listDidEndScrollingAnimationClosure?(scrollView)
        
        scrollStatus = .ending
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard let closure = commonAdapter?.listShouldScrollToTopClosure else { return false }
        return closure(scrollView)
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        commonAdapter?.listDidScrollToTopClosure?(scrollView)
    }
}
