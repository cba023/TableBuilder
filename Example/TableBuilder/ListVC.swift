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
    
    var tableProxy: TableProxy<ListVC>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTable()
    }
    
    var show: Bool = true
    
    func buildTable() {
        tableProxy = TableProxy(tableView, with: self) { target in
            for _ in 0..<10 {
                TableBuilder.Section(
                    headerHeight: 50,
                    headerReuse: .anyClass(
                        UITableViewHeaderFooterView.self, { tableView, section, reusableView in
                            reusableView.contentView.backgroundColor = .red
                        },
                        { tableView, reusableView, indexPath in
                            /// headerWillDisplay
                            reusableView.layoutIfNeeded()
                            reusableView.contentView.cutRectCorner([.topRight, .bottomLeft], cornerRadius: 25)
                        }
                    )
                ) {
                    TableBuilder.Row(target: target, cellHeight: 50, cellType: TableViewCell1.self, reuseType: .nib) { target, tableView, indexPath, cell in
                        
                    }
                    .didSelected(target: target, { target, tableView, indexPath in
                        print(tableView)
                        target.show = false
                    })
                    .willDisplay(target: target) { target, tableView, cell, indexPath in
//                        cell.name = "yoyo"
                    }
                }
            }
        }
//        tableProxy.didSelectRowAtIndexPath = { tableView, indexPath in
//            print("clicked: \(indexPath.section) - \(indexPath.row)")
//        }
        tableProxy.reloadData()
    }
    
    deinit {
        print("\(self) deinited")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableProxy.appendRowsToLastSection {
//            for _ in 0..<10 {
//                TableBuilder.Row(
//                    cellHeight: 30,
//                    autoCellHeight: false,
//                    cellType: UITableViewCell.self,
//                    reuseType: .anyClass
//                ) { tableView, indexPath, cell in
//                    cell.contentView.backgroundColor = .blue
//                    cell.textLabel?.text = "\(indexPath.row)"
//                }
//            }
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

