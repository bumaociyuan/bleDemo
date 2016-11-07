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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        layer.masksToBounds = false
        clipsToBounds = false
        updatePoints()
    }
    func updatePoints() {
        pointViews.forEach { (l) in
            l.removeFromSuperview()
        }
        pointViews.removeAll()
        let radius: CGFloat = 8
        let mutiplier: CGFloat = CGFloat(30)
        for (i, p) in points.enumerated() {
            let xCoord = p.x * mutiplier
            let yCoord = p.y * mutiplier
            let label = UILabel()
            label.text = p.id
            label.clipsToBounds = true
            label.layer.cornerRadius = 4
            label.textAlignment = .center
            label.backgroundColor = UIColor.red
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 2
            label.frame = CGRect(x: xCoord, y: yCoord, width: radius*3, height: radius*3)
            label.sizeToFit()
            addSubview(label)
            pointViews.append(label)
        }
    }
    
    
    
    var pointViews: [UILabel] = []
    var points: [TopoPoint] = [] {
        didSet {
            updatePoints()
        }
    }
}
