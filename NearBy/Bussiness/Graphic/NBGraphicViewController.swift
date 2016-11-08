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
    var rotation: CGFloat = 0
    var refreshBarButtonItem: UIBarButtonItem!
    var showIdBarButtonItem: UIBarButtonItem!
    var loadingBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拓扑图"
        view.backgroundColor = UIColor.white
        topoView = TopographyView()
        topoView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        topoView.center = view.center
        view.addSubview(topoView)
        
        setupNavigationItems()
        hideLoading()
        setupGestures()
        getServerData()
    }
    
    func showLoading() {
        navigationItem.rightBarButtonItems = [loadingBarButtonItem]
    }
    
    func hideLoading() {
        navigationItem.rightBarButtonItems = [showIdBarButtonItem,refreshBarButtonItem]
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupNavigationItems() {
        refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(NBGraphicViewController.getServerData))
        showIdBarButtonItem = UIBarButtonItem(title: "显示ID", style: .plain, target: self, action: #selector(NBGraphicViewController.toggleId))
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.startAnimating()
        loadingBarButtonItem = UIBarButtonItem(customView: loadingView)
    }
    
    func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(NBGraphicViewController.panG(sender:)))
        view.addGestureRecognizer(pan)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(NBGraphicViewController.rotateAction(sender:)))
        view.addGestureRecognizer(rotate)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(NBGraphicViewController.pinchAction(sender:)))
        view.addGestureRecognizer(pinch)
        
        pinch.require(toFail: rotate)
    }
    
    @IBAction func rotateAction(sender: UIRotationGestureRecognizer) {
        var lastRotation = CGFloat()
        if(sender.state == UIGestureRecognizerState.ended){
            lastRotation = 0.0;
        }
        rotation = lastRotation + sender.rotation
        let currentTrans = topoView.transform
        let newTrans = currentTrans.rotated(by: rotation)
        topoView.transform = newTrans
        lastRotation = sender.rotation
        sender.rotation = 0
    }
    
    @IBAction func pinchAction(sender: UIPinchGestureRecognizer) {
        let currentTrans = topoView.transform
        topoView.transform = currentTrans.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    
    func panG(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        topoView.center = CGPoint(x: topoView.center.x + translation.x, y: topoView.center.y + translation.y)
        sender.setTranslation(.zero, in: view)
    }
    
    func toggleId() {
        topoView.hideId = !topoView.hideId
    }
    
    func getServerData() {
        topoView.clearAllPoints()
        showLoading()
        let message = AIMessage()
        message.url = "http://171.221.254.231:3003/data/getAllPoints"
        AINetEngine.default().post(message, success: { [weak self] (response) -> Void in
            self?.hideLoading()
            let points = response as! [[String: AnyObject]]
//            print(points)
            let brain = TopoBrain()
            var result = [TopoPoint]()
            for p in points {
                let point = brain.parse(point: p)
//                print(point)
                result.append(TopoPoint(x: point.x, y: point.y, id: p["id"] as! String))
            }
            self?.topoView.points = result
        }, fail: { (ErrorType, error) -> Void in

        })
    }

}
