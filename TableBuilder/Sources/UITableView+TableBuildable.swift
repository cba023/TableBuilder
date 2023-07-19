//
//  UITableView+TableBuildable.swift
//  TableBuilder
//
//  Created by chenb3 on 2022/3/8.
//

import UIKit

extension TableBuildableWrapper where Base: UITableView {
    
    /// 命名空间
    private func nameSpace(bundle: Bundle) -> String? {
        return bundle.infoDictionary?["CFBundleExecutable"] as? String
    }
    
    /// 获取指定类的类名
    private func className<Object: AnyObject>(_ cls: Object.Type) -> String {
        let className = NSStringFromClass(cls)
        return className
    }
    
    /// 通过类名,限定的类的子类以及Bundle生成实例
    private func generateClass(name: String) -> AnyObject {
        let cls: AnyClass = NSClassFromString(name)!
        return cls
    }
    
    /// 复用Cell(nibClass)
    func dequeueReusableCell<T: UITableViewCell>(nibClass: T.Type, bundle: Bundle = .main) -> T {
        let className = String(className(nibClass).split(separator: ".").last ?? "")
        let cell = (base.dequeueReusableCell(withIdentifier: className) ??
        bundle.loadNibNamed(className, owner: nil, options: nil)?.first) as! T
        return cell
    }
    
    /// 复用Cell(anyClass)
    func dequeueReusableCell<T: UITableViewCell>(anyClass: T.Type, bundle: Bundle = .main) -> T {
        let className = className(anyClass)
        var cell = base.dequeueReusableCell(withIdentifier: className)
        if cell == nil {
            let cls = generateClass(name: className)
            let initClass = cls as! T.Type
            cell = initClass.init(style: .default, reuseIdentifier: className)
        }
        return cell as! T
        
    }
    
    /// 复用Header或Footer(nibClass)
    func dequeueReusableHeaderFooterView<T: UIView>(nibClass: T.Type, bundle: Bundle = .main) -> T {
        let className = String(className(nibClass).split(separator: ".").last ?? "")
        let headerFooter = (base.dequeueReusableHeaderFooterView(withIdentifier: className)) ??
        ((bundle.loadNibNamed(className, owner: nil, options: nil)?.first) as! UIView)
        return headerFooter as! T
    }
    
    /// 复用Header或Footer(anyClass)
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(anyClass: T.Type, bundle: Bundle = .main) -> T {
        let className = className(anyClass)
        var headerFooter:UIView? = base.dequeueReusableHeaderFooterView(withIdentifier: className)
        if headerFooter == nil {
            let cls = generateClass(name: className)
            let initClass = cls as! T.Type
            headerFooter = initClass.init(reuseIdentifier: className)
        }
        return headerFooter as! T
    }
    
}

extension TableBuildableWrapper where Base: UITableView {
    
    public func build(_ builder: TableBuilder) -> TableProxy {
        let agent = TableProxy(tableView: base, builder: builder)
        return agent
    }
    
}
