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
    
    var tableBuilder: TableBuilder<ListVC>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTable()
    }
    
    var show: Bool = true
    
    func buildTable() {
        tableBuilder = TableBuilder(tableView, with: self) { target in
            for _ in 0..<10 {
                TableBuilder.Section {
                    TableBuilder.TRow(target: target, cellHeight: 50, cellType: TableViewCell1.self, reuseType: .nib) { target, tableView, indexPath, cell in
                        cell.name = "yoyoyo\(indexPath.section)"
                    }.done()
                    TableBuilder.TRow(target: target, cellHeight: 50, cellType: TableViewCell2.self) { target, tableView, indexPath, cell in
                        cell.titleLab.text = "hahaadfsd\(indexPath.section)"
                        cell.contentView.backgroundColor = .green
                    }.done()
                }
            }
        }
        tableBuilder.reloadData()
    }
    
    deinit {
        print("\(self) deinited")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tableBuilder.appendRowsToLastSection {
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
//        }
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

