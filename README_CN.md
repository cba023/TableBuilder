# TableBuilder

[![Version](https://img.shields.io/cocoapods/v/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)
[![License](https://img.shields.io/cocoapods/l/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)
[![Platform](https://img.shields.io/cocoapods/p/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)

更方便快捷构建TableView页面

优点:

* 更少代码
* 声明式
* 灵活度高
* 基于 UITableViewDelegate & UITableViewDataSource
* 已经处理好Cell复用
* 方便重写和扩展

## 示例

要运行示例项目，请克隆仓库，并首先从示例目录运行`pod install`。

## 要求

> Swift 5+

## 安装

TableBuilder可以通过[CocoaPods](https://cocoapods.org)获得。安装
只需将下面这行添加到你的Podfile中:

```ruby
pod 'TableBuilder'
```

## 使用

```swift
import TableBuilder

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableProxy: TableProxy!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTable()
    }
    
    var show: Bool = true
    
    func reloadTable() {
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
    }
}
```

## 作者

陈波, cba023@hotmail.com

## 开源许可

TableBuilder在MIT许可下可用。查看许可证文件以获取更多信息。
