//
//  NBGraphicViewController.swift
//  NearBy
//
//  Created by 王坜 on 16/11/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class NBGraphicViewController: UIViewController {
    var topoView: TopographyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "蓝牙拓扑图"
        view.backgroundColor = UIColor.white
        topoView = TopographyView()
        view.addSubview(topoView)
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(NBGraphicViewController.getServerData))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topoView.frame = view.bounds
    }

    func getServerData() {
        let message = AIMessage()
        message.url = "http://171.221.254.231:3003/data/getAllPoints"
        AINetEngine.default().post(message, success: { (response) -> Void in
            print(response)
        }, fail: { (ErrorType, error) -> Void in

        })
    }

}
