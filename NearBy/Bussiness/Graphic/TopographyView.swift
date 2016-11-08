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
        for (i, p) in points.enumerated() {
            let xCoord = p.x * mutiplier
            let yCoord = p.y * mutiplier
            let label = UILabel()
            label.isHidden = true
            label.text = "     " + p.id.stripePrefix()
            label.backgroundColor = UIColor.clear
            label.clipsToBounds = true
            label.frame = CGRect(x: xCoord, y: yCoord, width: 200, height: 25)
            addSubview(label)
            idLabels.append(label)
            
            var potWidth: CGFloat = 10
            if p.id == BLEManager.default().advertisingName {
               potWidth = 20
            }
            let pot = UIView(frame: CGRect(x: label.frame.minX, y: label.frame.minY, width: potWidth, height: potWidth))
            pot.layer.cornerRadius = potWidth / 2
            pot.backgroundColor = UIColor.red
            addSubview(pot)
            pointViews.append(pot)
        }
    }

    var points: [TopoPoint] = [] {
        didSet {
            updatePoints()
        }
    }
}
