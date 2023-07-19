//
//  TableBuilder.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/22.
//

import UIKit

@resultBuilder
public struct TableBuilder {
    
    public var sections: [TableSectionBuilder] = []
    
    public init(@TableBuilder _ sections: () -> [TableSectionBuilder]) {
        self.sections = sections()
    }
}

extension TableBuilder: ResultBuilderRule {
    
    public typealias Base = TableSectionBuilder
    
}

@resultBuilder
public struct TableSectionBuilder {
    
    public enum HeaderFooterReuseType<T: UIView, U: UITableViewHeaderFooterView> {
        case nibClass(
            _ class: T.Type,
            _ view:((_ tableView: UITableView, _ section: Int, _ reusableHeaderFooterView: T) -> Void))
        case anyClass(
            _ class: U.Type,
            _ view:((_ tableView: UITableView, _ section: Int, _ reusableHeaderFooterView: U) -> Void))
    }
    
    public var rows: [TableRowBuilder] = []
    
    public let headerHeight: CGFloat
    
    public let autoHeaderHeight: Bool
    
    public var viewForHeader: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    
    public let autoFooterHeight: Bool
    
    public let footerHeight: CGFloat
    
    public var viewForFooter: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    
    public init<T1: UIView, T2: UIView, U1: UITableViewHeaderFooterView, U2: UITableViewHeaderFooterView>(
        headerHeight: CGFloat = CGFloat.leastNormalMagnitude,
        autoHeaderHeight: Bool = false,
        headerReuse: HeaderFooterReuseType<T1, U1>? = nil,
        footerHeight: CGFloat = CGFloat.leastNormalMagnitude,
        autoFooterHeight: Bool = false,
        footerReuse: HeaderFooterReuseType<T2, U2>? = nil,
        @TableSectionBuilder _ rows: () -> [TableRowBuilder])
    {
        self.autoHeaderHeight = autoHeaderHeight
        self.autoFooterHeight = autoFooterHeight
        self.headerHeight = self.autoHeaderHeight ? UITableView.automaticDimension : headerHeight
        self.footerHeight = self.autoFooterHeight ? UITableView.automaticDimension : footerHeight
        
        switch headerReuse {
        case let .nibClass(headerType, reuse):
            self.viewForHeader = {tableView, section in
                let header = tableView.bd.dequeueReusableHeaderFooterView(nibClass: headerType)
                reuse(tableView, section, header)
                return header
            }
        case let .anyClass(headerType, reuse):
            self.viewForHeader = {tableView, section in
                let header = tableView.bd.dequeueReusableHeaderFooterView(anyClass: headerType)
                reuse(tableView, section, header)
                return header
            }
        case .none:
            self.viewForHeader = nil
        }
        
        switch footerReuse {
        case let .nibClass(footerType, reuse):
            self.viewForFooter = {tableView, section in
                let footer = tableView.bd.dequeueReusableHeaderFooterView(nibClass: footerType)
                reuse(tableView, section, footer)
                return footer
            }
        case let .anyClass(footerType, reuse):
            self.viewForFooter = {tableView, section in
                let footer = tableView.bd.dequeueReusableHeaderFooterView(anyClass: footerType)
                reuse(tableView, section, footer)
                return footer
            }
        case .none:
            self.viewForFooter = nil
            
        }
        self.rows = rows()
    }
    
}

extension TableSectionBuilder: ResultBuilderRule {
    
    public typealias Base = TableRowBuilder
   
}

public struct TableRowBuilder {
    
    public enum RegisterType {
        case anyClass
        case nib
    }
    
    let cellHeight: CGFloat
    
    let autoCellHeight: Bool
    
    let didSelectRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
    
    let cellForRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    
    public init<T: UITableViewCell>(
        cellHeight: CGFloat,
        autoCellHeight: Bool = false,
        cellType: T.Type,
        reuseType: RegisterType = .anyClass,
        _ cellForRowAtIndexPath:@escaping (_ tableView: UITableView, _ indexPath:IndexPath, _ cell: T) -> Void,
        didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath:IndexPath, _ cell: T) -> Void)? = nil)
    {
        self.autoCellHeight = autoCellHeight
        self.cellHeight = self.autoCellHeight == true ? UITableView.automaticDimension: cellHeight;
        self.cellForRowAtIndexPath = {tableView, indexPath in
            let cell = reuseType == .anyClass ?
            tableView.bd.dequeueReusableCell(anyClass: cellType) :
            tableView.bd.dequeueReusableCell(nibClass: cellType)
            cellForRowAtIndexPath(tableView, indexPath, cell)
            return cell
        }
        self.didSelectRowAtIndexPath = {tableView, indexPath in
            guard let cell = tableView.cellForRow(at: indexPath) as? T else { return }
            didSelectRowAtIndexPath?(tableView, indexPath, cell)
        }
    }
    
}

