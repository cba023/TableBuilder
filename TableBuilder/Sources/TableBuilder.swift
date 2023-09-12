//
//  TableBuilder.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/22.
//

import UIKit

@resultBuilder
public struct TableBuilder {
    
    public var sections: [Section] = []
    
    public init(@TableBuilder _ sections: () -> [Section]) {
        self.sections = sections()
    }

}

extension TableBuilder: ResultBuilderRule {

    public typealias Base = Section
    
}

extension TableBuilder {
    
    @resultBuilder
    public struct Section {
        
        public enum HeaderFooterReuseType<N: UIView, C: UITableViewHeaderFooterView> {
            case nibClass(
                _ class: N.Type,
                _ view: (_ tableView: UITableView, _ section: Int, _ reusableView: N) -> Void,
                _ willDisplay: ((_ tableView: UITableView, _ reusableView: N, _ section: Int) -> Void)? = nil
            )
            case anyClass(
                _ class: C.Type,
                _ view:(_ tableView: UITableView, _ section: Int, _ reusableView: C) -> Void,
                _ willDisplay: ((_ tableView: UITableView, _ reusableView: C, _ section: Int) -> Void)? = nil
            )
        }
        
        public var rows: [Row] = []
        
        public let headerHeight: CGFloat
        
        public let autoHeaderHeight: Bool
        
        public var viewForHeader: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
        
        public var headerWillDisplay: ((_ tableView: UITableView, _ reusableView: UIView, _ section: Int) -> Void)?
        
        public var footerWillDisplay: ((_ tableView: UITableView, _ reusableView: UIView, _ section: Int) -> Void)?
        
        public let autoFooterHeight: Bool
        
        public let footerHeight: CGFloat
        
        public var viewForFooter: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
        
        public init<H1: UIView, F1: UIView, H2: UITableViewHeaderFooterView, F2: UITableViewHeaderFooterView>(
            headerHeight: CGFloat = CGFloat.leastNormalMagnitude,
            autoHeaderHeight: Bool = false,
            headerReuse: HeaderFooterReuseType<H1, H2>? = nil,
            footerHeight: CGFloat = CGFloat.leastNormalMagnitude,
            autoFooterHeight: Bool = false,
            footerReuse: HeaderFooterReuseType<F1, F2>? = nil,
            @Section _ rows: () -> [Row])
        {
            self.autoHeaderHeight = autoHeaderHeight
            self.autoFooterHeight = autoFooterHeight
            self.headerHeight = self.autoHeaderHeight ? UITableView.automaticDimension : headerHeight
            self.footerHeight = self.autoFooterHeight ? UITableView.automaticDimension : footerHeight
            
            switch headerReuse {
            case let .nibClass(headerType, reuse, willDisaplay):
                self.viewForHeader = {tableView, section in
                    let header = tableView.tb.dequeueReusableHeaderFooterView(nibClass: headerType)
                    reuse(tableView, section, header)
                    return header
                }
                self.headerWillDisplay = { tableView, cell, indexPath in
                    willDisaplay?(tableView, cell as! H1, indexPath)
                }
            case let .anyClass(headerType, reuse, willDisplay):
                self.viewForHeader = {tableView, section in
                    let header = tableView.tb.dequeueReusableHeaderFooterView(anyClass: headerType)
                    reuse(tableView, section, header)
                    return header
                }
                self.headerWillDisplay = { tableView, cell, indexPath in
                    willDisplay?(tableView, cell as! H2, indexPath)
                }
            case .none:
                self.viewForHeader = nil
            }
            
            switch footerReuse {
            case let .nibClass(footerType, reuse, willDisplay):
                self.viewForFooter = {tableView, section in
                    let footer = tableView.tb.dequeueReusableHeaderFooterView(nibClass: footerType)
                    reuse(tableView, section, footer)
                    return footer
                }
                self.footerWillDisplay = { tableView, cell, indexPath in
                    willDisplay?(tableView, cell as! F1, indexPath)
                }
            case let .anyClass(footerType, reuse, willDisplay):
                self.viewForFooter = {tableView, section in
                    let footer = tableView.tb.dequeueReusableHeaderFooterView(anyClass: footerType)
                    reuse(tableView, section, footer)
                    return footer
                }
                self.footerWillDisplay = { tableView, cell, indexPath in
                    willDisplay?(tableView, cell as! F2, indexPath)
                }
            case .none:
                self.viewForFooter = nil
                self.footerWillDisplay = nil
            }
            self.rows = rows()
        }
    }
}

extension TableBuilder.Section: ResultBuilderRule {

    public typealias Base = TableBuilder.Row

}

extension TableBuilder {
    
    public struct Row {
        
        public enum RegisterType {
            case anyClass
            case nib
        }
        
        let cellHeight: CGFloat
        
        let autoCellHeight: Bool
        
        let didSelectRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
        
        let cellForRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
        
        let willDisplay: (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void
        
        public init<T: UITableViewCell>(
            cellHeight: CGFloat,
            autoCellHeight: Bool = false,
            cellType: T.Type,
            reuseType: RegisterType = .anyClass,
            _ cellForRowAtIndexPath:@escaping (_ tableView: UITableView, _ indexPath:IndexPath, _ cell: T) -> Void,
            didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath:IndexPath, _ cell: T) -> Void)? = nil,
            willDisplay:((_ tableView: UITableView, _ cell: T, _ indexPath: IndexPath) -> Void)? = nil
        )
        {
            self.autoCellHeight = autoCellHeight
            self.cellHeight = self.autoCellHeight == true ? UITableView.automaticDimension: cellHeight;
            self.cellForRowAtIndexPath = {tableView, indexPath in
                let cell = reuseType == .anyClass ?
                tableView.tb.dequeueReusableCell(anyClass: cellType) :
                tableView.tb.dequeueReusableCell(nibClass: cellType)
                cellForRowAtIndexPath(tableView, indexPath, cell)
                return cell
            }
            self.didSelectRowAtIndexPath = {tableView, indexPath in
                guard let cell = tableView.cellForRow(at: indexPath) as? T else { return }
                didSelectRowAtIndexPath?(tableView, indexPath, cell)
            }
            self.willDisplay = { tableView, cell, indexPath in
                guard let cell = cell as? T else { return }
                willDisplay?(tableView, cell , indexPath)
            }
        }
        
    }
    
}



