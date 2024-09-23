//
//  TableBuidlerRow.swift
//  TableBuilder
//
//  Created by chenbo on 2024/9/1.
//

import UIKit

extension TableBuilder {

    public struct Row {
        
        let cellHeight: CGFloat
        
        let autoCellHeight: Bool
        
        let cellForRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
        
        var didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?

        var willDisplay: ((_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ())?
        
        public init<T: UITableViewCell>(
            target: Target,
            cellHeight: CGFloat,
            autoCellHeight: Bool = false,
            cellType: T.Type,
            reuseType: RegisterType = .anyClass,
            _ cellForRowAtIndexPath: @escaping (_ target: Target, _ tableView: UITableView, _ indexPath:IndexPath) -> UITableViewCell
        ) {
            self.autoCellHeight = autoCellHeight
            self.cellHeight = self.autoCellHeight == true ? UITableView.automaticDimension: cellHeight;
            self.cellForRowAtIndexPath = { [weak target] tableView, indexPath in
                let cell = cellForRowAtIndexPath(target!, tableView, indexPath)
                return cell
            }
        }
        
        public func didSelected(target: Target, _ callback: @escaping (_ target: Target, _ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
            var newValue = self
            newValue.didSelectRowAtIndexPath = {[weak target] tableView, indexPath in
                guard let target else { return }
                callback(target, tableView, indexPath)
            }
            return newValue
        }
        
        public func willDisplay(target: Target, _ callback: @escaping (_ target: Target, _ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) -> Self {
            var newValue = self
            newValue.willDisplay = { [weak target] tableView, cell, indexPath in
                guard let target else { return }
                callback(target, tableView, cell, indexPath)
            }
            return newValue
        }
    }
}

public enum RegisterType {
    case anyClass
    case nib
}

extension TableBuilder.Row {
    
    @resultBuilder
    public struct Builder: ResultBuilderRule {
        public typealias Base = TableBuilder.Row
    }
}


extension TableBuilder {
    
    public struct TRow<T: UITableViewCell> {
        
        let cellHeight: CGFloat
        
        let autoCellHeight: Bool
        
        let cellForRowAtIndexPath: (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
        
        var didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?

        var willDisplay: ((_ tableView: UITableView, _ cell: T, _ indexPath: IndexPath) -> ())?
        
        var target: Target
        
        var cellType: T.Type
        
        public init(
            target: Target,
            cellHeight: CGFloat,
            autoCellHeight: Bool = false,
            cellType: T.Type,
            reuseType: RegisterType = .anyClass,
            _ cellForRowAtIndexPath: @escaping (_ target: Target, _ tableView: UITableView, _ indexPath:IndexPath, _ cell: T) -> ()
        ) {
            self.target = target
            self.cellType = cellType
            self.autoCellHeight = autoCellHeight
            self.cellHeight = self.autoCellHeight == true ? UITableView.automaticDimension: cellHeight;
            self.cellForRowAtIndexPath = { [weak target] tableView, indexPath in
                let cell = reuseType == .anyClass ? tableView.tb.dequeueReusableCell(anyClass: cellType) : tableView.tb.dequeueReusableCell(nibClass: cellType)
                guard let target else { return cell }
                cellForRowAtIndexPath(target, tableView, indexPath, cell)
                return cell
            }
        }
        
        public func didSelected(target: Target, _ callback: @escaping (_ target: Target, _ tableView: UITableView, _ indexPath: IndexPath, _ cell: T) -> ()) -> Self {
            var newValue = self
            newValue.didSelectRowAtIndexPath = {[weak target] tableView, indexPath in
                guard let target else { return }
                guard let cell = tableView.cellForRow(at: indexPath) as? T else { return }
                callback(target, tableView, indexPath, cell)
            }
            return newValue
        }
        
        public func willDisplay(target: Target, _ callback: @escaping (_ target: Target, _ tableView: UITableView, _ cell: T, _ indexPath: IndexPath) -> ()) -> Self {
            var newValue = self
            newValue.willDisplay = { [weak target] tableView, cell, indexPath in
                guard let target else { return }
                callback(target, tableView, cell, indexPath)
            }
            return newValue
        }
        
        public func done() -> Row {
            return TableBuilder.Row(target: self.target, cellHeight: self.cellHeight, cellType: T.self) { target, tableView, indexPath in
                return cellForRowAtIndexPath(tableView, indexPath)
            }
        }
    }

}
