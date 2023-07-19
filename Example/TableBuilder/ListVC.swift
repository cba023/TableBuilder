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
    
    var tableAgent: TableProxy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTable()
    }
    
    var show: Bool = true
    
    func buildTable() {
        tableAgent = tableView.bd.build(TableBuilder {
            for _ in 0..<3 {
                TableSectionBuilder {
                    TableRowBuilder(
                        cellHeight: 50,
                        cellType: TableViewCell1.self, reuseType: .nib)
                    { tableView, indexPath, cell in
                        
                    } didSelectRowAtIndexPath: { tableView, indexPath, cell in
                        print("CellType1的单独的点击事件")
                    }
                    TableRowBuilder(
                        cellHeight: 50,
                        cellType: TableViewCell2.self, reuseType: .anyClass)
                    { tableView, indexPath, cell in
                        cell.contentView.backgroundColor = .green
                        cell.textLabel?.text = "\(indexPath.row)"
                    } didSelectRowAtIndexPath: { tableView, indexPath, cell in
                        print("=====Cell类型2的单独的点击事件")
                    }
                    let count = 10
                    for _ in 0..<count {
                        TableRowBuilder(
                            cellHeight: 30,
                            autoCellHeight: false,
                            cellType: UITableViewCell.self,
                            reuseType: .anyClass)
                        { tableView, indexPath, cell in
                            cell.contentView.backgroundColor = .blue
                            cell.textLabel?.text = "\(indexPath.row)"
                        }
                    }
                    if show {
                        TableRowBuilder(
                            cellHeight: 50,
                            cellType: UITableViewCell.self)
                        { tableView, indexPath, cell in
                            cell.contentView.backgroundColor = .purple
                            cell.textLabel?.text = "\(indexPath.row)"
                        }
                        TableRowBuilder(
                            cellHeight: 50,
                            cellType: UITableViewCell.self)
                        { tableView, indexPath, cell in
                            cell.contentView.backgroundColor = .purple
                            cell.textLabel?.text = "\(indexPath.row)"
                        }
                    }
                    else {
                        TableRowBuilder(
                            cellHeight: 90,
                            cellType: UITableViewCell.self)
                        { tableView, indexPath, cell in
                            cell.contentView.backgroundColor = .yellow
                            cell.textLabel?.text = "\(indexPath.row)"
                        }
                    }
                }
            }
        })
        
        tableAgent.didSelectRowAtIndexPath = { tableView, indexPath in
            print("clicked: \(indexPath.section) - \(indexPath.row)")
        }
    }
    
}
