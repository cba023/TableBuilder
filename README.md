# TableBuilder

[![Version](https://img.shields.io/cocoapods/v/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)
[![License](https://img.shields.io/cocoapods/l/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)
[![Platform](https://img.shields.io/cocoapods/p/TableBuilder.svg?style=flat)](https://cocoapods.org/pods/TableBuilder)


[-> 中文说明](https://github.com/cba023/TableBuilder/blob/main/README_CN.md)

Easier to write TableView page

Advantages:

* Less code
* Declarative
* Flexible
* Base on UITableViewDelegate & UITableViewDataSource
* Already handled the reuse function
* Easy to rewrite and extend


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

> Swift 5+

## Installation

TableBuilder is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TableBuilder'
```

## Usage 

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


## Author

chenbo, cba023@hotmail.com

## License

TableBuilder is available under the MIT license. See the LICENSE file for more info.
