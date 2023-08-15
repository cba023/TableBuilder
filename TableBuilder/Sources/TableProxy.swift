//
//  TableProxy.swift
//  TableBuilder
//
//  Created by chenbo on 2022/7/22.
//

import UIKit

open class TableProxy: NSObject {
    
    open var builder: TableBuilder!
    
    open var didSelectRowAtIndexPath: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?
    
    open var didScroll: ((_ scrollView: UIScrollView) -> ())?
    
    open var willBeginDragging: ((_ scrollView: UIScrollView) -> ())?
    
    open var didEndDragging: ((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> ())?
    
    open var willBeginDecelerating: ((_ scrollView: UIScrollView) -> ())?
    
    open var didEndDecelerating: ((_ scrollView: UIScrollView) -> ())?
    
    open var didEndScrollingAnimation: ((_ scrollView: UIScrollView) -> ())?
    
    open var canEditRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Bool)?
    
    open var commitEdit: ((_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> ())?
    
    open var willBeginEditing: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?
    
    open var didEndEditing: ((_ tableView: UITableView, _ indexPath: IndexPath?) -> ())?
    
    open var editStyle: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?
    
    open var titleForDeleteConfirmationButton: ((_ tableView: UITableView, _ indexPath: IndexPath?) -> String?)?
    
    open var shouldIndentWhileEditing: ((_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool)?
    
    public init(_ tableView: UITableView) {
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
        let sectionBuilder = builder.sections[section]
        return sectionBuilder.viewForHeader?(tableView, section)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionBuilder = builder.sections[section]
        return sectionBuilder.viewForFooter?(tableView, section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionBuilder = builder.sections[indexPath.section]
        let rowBuilder = sectionBuilder.rows[indexPath.row]
        return rowBuilder.cellForRowAtIndexPath(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPath?(tableView, indexPath)
        let sectionBuilder = builder.sections[indexPath.section]
        let rowBuilder = sectionBuilder.rows[indexPath.row]
        rowBuilder.didSelectRowAtIndexPath(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRow?(tableView, indexPath) ?? false
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEdit?(tableView, editingStyle, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditing?(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditing?(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return editStyle?(tableView, indexPath) ?? .none
    }
    
    open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return titleForDeleteConfirmationButton?(tableView, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return shouldIndentWhileEditing?(tableView, indexPath) ?? false
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

