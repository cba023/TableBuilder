//
//  TableBuildable.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

/// `可构造`协议
public protocol TableBuildable {
    
    associatedtype Base
    
    static var tb: TableBuildableWrapper<Base>.Type { get }
    
    var tb: TableBuildableWrapper<Base>  { get }
    
}

/// `可构造`协议的默认实现
public extension TableBuildable {
    
    /// 静态扩展后缀
    static var tb: TableBuildableWrapper<Self>.Type {
        return TableBuildableWrapper<Self>.self
    }
    
    /// 实例扩展后缀
    var tb: TableBuildableWrapper<Self> {
        return TableBuildableWrapper(self)
    }
}

/// `可构造`协议的容器类
public struct TableBuildableWrapper<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }

}

extension UITableView: TableBuildable {}




