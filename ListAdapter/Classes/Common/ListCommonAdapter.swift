//
//  ListCommonAdapter.swift
//  ListAdapter
//
//  Created by tanxl on 2023/12/2.
//

import UIKit

public class ListCommonAdapter: NSObject {
    
    public var listDidScrollClosure: ((UIScrollView) -> Void)?
    public var listDidZoomClosure: ((UIScrollView) -> Void)?
    public var listWillBeginDraggingClosure: ((UIScrollView) -> Void)?
    public var listWillEndDraggingClosure: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void)?
    public var listDidEndDraggingClosure: ((UIScrollView, Bool) -> Void)?
    public var listWillBeginDeceleratingClosure: ((UIScrollView) -> Void)?
    public var listDidEndDeceleratingClosure: ((UIScrollView) -> Void)?
    public var listDidEndScrollingAnimationClosure: ((UIScrollView) -> Void)?
    public var listShouldScrollToTopClosure: ((UIScrollView) -> Bool)?
    public var listDidScrollToTopClosure: ((UIScrollView) -> Void)?
}
