//
//  NBGraphicViewController.swift
//  NearBy
//
//  Created by 王坜 on 16/11/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class NBGraphicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "蓝牙拓扑图"
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getServerData() {
        //http://10.5.1.249:3000/data/getData
        let message = AIMessage()
        message.url = "http://171.221.254.231:3003/data/getData"

        AINetEngine.default().post(message, success: { (response) -> Void in

        }, fail: { (ErrorType, error) -> Void in

        })
    }

}
