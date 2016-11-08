//
//  TopographyView.swift
//  topographyDemo
//
//  Created by zx on 10/28/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

struct TopoPoint {
    var x: CGFloat
    var y: CGFloat
    var id: String
}

class TopographyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    var hideId: Bool = true {
        didSet {
            idLabels.forEach { (l) in
                l.isHidden = hideId
            }
        }
    }
    
    var idLabels: [UILabel] = []
    var pointViews: [UIView] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.masksToBounds = false
        clipsToBounds = false
        updatePoints()
    }
    
    func clearAllPoints() {
        points = []
    }
    
    func updatePoints() {
        pointViews.forEach { (l) in
            l.removeFromSuperview()
        }
        pointViews.removeAll()
        
        idLabels.forEach { (l) in
            l.removeFromSuperview()
        }
        idLabels.removeAll()
        let mutiplier: CGFloat = CGFloat(30)
        for (_, p) in points.enumerated() {
            let xCoord = p.x * mutiplier
            let yCoord = p.y * mutiplier

            var potSize: CGFloat = 10
            if p.id == BLEManager.default().advertisingName {
                potSize = 20
            }

            // 绘点
            let pot = UIView(frame: CGRect(x: xCoord, y: yCoord, width: potSize, height: potSize))
            pot.layer.cornerRadius = potSize / 2
            pot.backgroundColor = UIColor.red
            addSubview(pot)
            pointViews.append(pot)


            // 绘name
            let label = UPLabel()
            label.isHidden = true
            label.text = p.id.stripePrefix()
            label.font = UIFont.systemFont(ofSize: 6)
            label.backgroundColor = UIColor.clear
            label.clipsToBounds = true
            label.frame = CGRect(x: pot.frame.minX + potSize, y: pot.frame.minY, width: 200, height: potSize)
            label.verticalAlignment = UPVerticalAlignmentMiddle
            addSubview(label)
            idLabels.append(label)
            

        }
    }

    var points: [TopoPoint] = [] {
        didSet {
            updatePoints()
        }
    }
}
