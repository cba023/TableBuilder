//
//  TableBuidlerSection.swift
//  TableBuilder
//
//  Created by chenbo on 2024/9/1.
//

import UIKit

extension TableBuilder {
    
    @resultBuilder
    public struct Section {
        
        public var rows: [Row] = []
        
        public let headerHeight: CGFloat
        
        public let autoHeaderHeight: Bool
        
        public var viewForHeader: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
        
        public var headerWillDisplay: ((_ tableView: UITableView, _ reusableView: UIView, _ section: Int) -> ())?
        
        public var footerWillDisplay: ((_ tableView: UITableView, _ reusableView: UIView, _ section: Int) -> ())?
        
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
            @Section _ rows: () -> [Row]
        ) {
            self.autoHeaderHeight = autoHeaderHeight
            self.autoFooterHeight = autoFooterHeight
            self.headerHeight = self.autoHeaderHeight ? UITableView.automaticDimension : headerHeight
            self.footerHeight = self.autoFooterHeight ? UITableView.automaticDimension : footerHeight
            
            switch headerReuse {
            case let .nibClass(headerType, reuse, willDisaplay):
                self.viewForHeader = { tableView, section in
                    let header = tableView.tb.dequeueReusableHeaderFooterView(nibClass: headerType)
                    reuse(tableView, section, header)
                    return header
                }
                self.headerWillDisplay = { tableView, cell, indexPath in
                    willDisaplay?(tableView, cell as! H1, indexPath)
                }
            case let .anyClass(headerType, reuse, willDisplay):
                self.viewForHeader = { tableView, section in
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
                self.viewForFooter = { tableView, section in
                    let footer = tableView.tb.dequeueReusableHeaderFooterView(nibClass: footerType)
                    reuse(tableView, section, footer)
                    return footer
                }
                self.footerWillDisplay = { tableView, cell, indexPath in
                    willDisplay?(tableView, cell as! F1, indexPath)
                }
            case let .anyClass(footerType, reuse, willDisplay):
                self.viewForFooter = { tableView, section in
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

extension TableBuilder.Section {

    @resultBuilder
    public struct Builder: ResultBuilderRule {
        public typealias Base = TableBuilder.Section
    }
    
    public enum HeaderFooterReuseType<N: UIView, C: UITableViewHeaderFooterView> {
        case nibClass(
            class: N.Type,
            view: (_ tableView: UITableView, _ section: Int, _ reusableView: N) -> (),
            willDisplay: ((_ tableView: UITableView, _ reusableView: N, _ section: Int) -> ())? = nil
        )
        case anyClass(
            class: C.Type,
            view:(_ tableView: UITableView, _ section: Int, _ reusableView: C) -> (),
            willDisplay: ((_ tableView: UITableView, _ reusableView: C, _ section: Int) -> ())? = nil
        )
    }
}

extension TableBuilder.Section: ResultBuilderRule {
    
    public typealias Base = TableBuilder.Row
}
