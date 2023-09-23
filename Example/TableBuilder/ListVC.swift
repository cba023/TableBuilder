//
//  ListVC.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/22.
//

import UIKit
import TableBuilder

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableProxy: TableProxy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTable()
    }
    
    var show: Bool = true
    
    func buildTable() {
        tableProxy = TableProxy(tableView) { [weak self] in
            guard let self = self else { return nil }
            return TableBuilder {
                for _ in 0..<3 {
                    TableBuilder.Section(
                        headerHeight: 50,
                        headerReuse: .anyClass(UITableViewHeaderFooterView.self, { tableView, section, reusableView in
                        reusableView.contentView.backgroundColor = .red
                    }, { tableView, reusableView, indexPath in
                        /// headerWillDisplay
                        reusableView.layoutIfNeeded()
                        reusableView.contentView.cutRectCorner([.topRight, .bottomLeft], cornerRadius: 25)
                    })) {
                        TableBuilder.Row(
                            cellHeight: 50,
                            cellType: TableViewCell1.self, reuseType: .nib)
                        { tableView, indexPath, cell in
                            
                        } didSelectRowAtIndexPath: { tableView, indexPath, cell in
                            print("CellType1的单独的点击事件")
                        }
                        TableBuilder.Row(
                            cellHeight: 50,
                            cellType: TableViewCell2.self, reuseType: .anyClass)
                        { tableView, indexPath, cell in
                            cell.contentView.backgroundColor = .green
                            cell.textLabel?.text = "\(indexPath.row)"
                        } didSelectRowAtIndexPath: { tableView, indexPath, cell in
                            print("=====Cell类型2的单独的点击事件")
                        } willDisplay: { tableView, cell, indexPath in
                            cell.contentView.cutRectCorner([.topLeft, .bottomRight], cornerRadius: 25)
                        }
                        let count = 10
                        for _ in 0..<count {
                            TableBuilder.Row(
                                cellHeight: 30,
                                autoCellHeight: false,
                                cellType: UITableViewCell.self,
                                reuseType: .anyClass)
                            { tableView, indexPath, cell in
                                cell.contentView.backgroundColor = .blue
                                cell.textLabel?.text = "\(indexPath.row)"
                            }
                        }
                        if self.show {
                            TableBuilder.Row(
                                cellHeight: 50,
                                cellType: UITableViewCell.self)
                            { tableView, indexPath, cell in
                                cell.contentView.backgroundColor = .purple
                                cell.textLabel?.text = "\(indexPath.row)"
                            }
                            TableBuilder.Row(
                                cellHeight: 50,
                                cellType: UITableViewCell.self)
                            { tableView, indexPath, cell in
                                cell.contentView.backgroundColor = .purple
                                cell.textLabel?.text = "\(indexPath.row)"
                            }
                        }
                        else {
                            TableBuilder.Row(
                                cellHeight: 90,
                                cellType: UITableViewCell.self)
                            { tableView, indexPath, cell in
                                cell.contentView.backgroundColor = .yellow
                                cell.textLabel?.text = "\(indexPath.row)"
                            }
                        }
                    }
                }
            }
        }
        tableProxy.didSelectRowAtIndexPath = { tableView, indexPath in
            print("clicked: \(indexPath.section) - \(indexPath.row)")
        }
        tableProxy.reloadData()
    }
    
    deinit {
        print("\(self) deinited")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableProxy.appendRowsToLastSection {
            for _ in 0..<10 {
                TableBuilder.Row(
                    cellHeight: 30,
                    autoCellHeight: false,
                    cellType: UITableViewCell.self,
                    reuseType: .anyClass
                ) { tableView, indexPath, cell in
                    cell.contentView.backgroundColor = .blue
                    cell.textLabel?.text = "\(indexPath.row)"
                }
            }
        }
    }
    
}

public extension  UIView {
    
    /// UIView切部分圆角
    func cutRectCorner(_ rectCorner: UIRectCorner, cornerRadius: CGFloat) {
        let base = self
        let maskPath = UIBezierPath(
            roundedRect: base.bounds,
            byRoundingCorners: rectCorner,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = base.bounds
        maskLayer.path = maskPath.cgPath
        base.layer.mask = maskLayer
    }
    
}

