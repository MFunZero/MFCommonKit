//
//  BaseTabelAdapter.swift
//  Base
//
//  Created by MFun on 2019/6/3.
//  Copyright © 2019 MFun. All rights reserved.
//

import Foundation
import UIKit

//MARK:- 选中block
typealias BaseTableViewSelectedBlock = (IndexPath) -> Void
typealias BaseTableViewCellBlock = (UITableViewCell) -> Void

//MARK:- tableView使用适配器
open class BaseTableAdapter: NSObject {
    var selectedBlock: BaseTableViewSelectedBlock?
    var deselectedBlock: BaseTableViewSelectedBlock?
    var cellBlock: BaseTableViewCellBlock?
    
    var tableView: UITableView?
    weak var controller: UIViewController?
    var dataArray: [AnyObject] = []    
    public static func adapterWith<T:BaseTableAdapter>(tableView: UITableView) -> T {
        let adapter = T.init(tableView: tableView)
        return adapter
    }    
    required public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        registerCell()
    }    
    
    
    func registerCell() {
        
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cell())
        
    }
    
    func selectAll(selected: Bool) {
        
    }
    
    func enableMultiSelected(enable: Bool) {
        self.tableView?.allowsMultipleSelection = enable
    }
    
}

extension BaseTableAdapter: UITableViewDelegate, UITableViewDataSource {    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cell(), for: indexPath)
        cell.selectionStyle = .none
        if let cellItem = cell as? BaseTableViewCell {
            cellItem.model = self.dataArray[indexPath.row]
        }
        
        if let block = cellBlock {
            block(cell)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = selectedBlock {
            block(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let block = deselectedBlock {
            block(indexPath)
        }
    }
    
}
