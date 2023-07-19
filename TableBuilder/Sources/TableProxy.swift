//
//  TableProxy.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/22.
//

import UIKit

open class TableProxy: NSObject {
    
    open var builder: TableBuilder
    
    open var didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    
    open var didScroll: ((_ scrollView: UIScrollView) -> Void)?
    
    open var willBeginDragging: ((_ scrollView: UIScrollView) -> Void)?
    
    open var didEndDragging: ((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)?
    
    open var willBeginDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    
    open var didEndDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    
    open var didEndScrollingAnimation: ((_ scrollView: UIScrollView) -> Void)?

    
    init(tableView: UITableView, builder: TableBuilder) {
        self.builder = builder
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension TableProxy: UITableViewDataSource, UITableViewDelegate {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return builder.sections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return builder.sections[section].rows.count
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return builder.sections[section].headerHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return builder.sections[section].headerHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return builder.sections[section].footerHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return builder.sections[section].headerHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return builder.sections[indexPath.section].rows[indexPath.row].cellHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return builder.sections[indexPath.section].rows[indexPath.row].cellHeight
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionBuilder = self.builder.sections[section]
        return sectionBuilder.viewForHeader?(tableView, section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionBuilder = self.builder.sections[section]
        return sectionBuilder.viewForFooter?(tableView, section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionBuilder = self.builder.sections[indexPath.section]
        let rowBuilder = sectionBuilder.rows[indexPath.row]
        return rowBuilder.cellForRowAtIndexPath(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRowAtIndexPath?(tableView, indexPath)
        let sectionBuilder = self.builder.sections[indexPath.section]
        let rowBuilder = sectionBuilder.rows[indexPath.row]
        rowBuilder.didSelectRowAtIndexPath(tableView, indexPath)
    }
    
}

extension TableProxy: UIScrollViewDelegate {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging?(scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView, decelerate)
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation?(scrollView)
    }
    
}

