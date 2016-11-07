//
//  TopoBrain.swift
//  topographyDemo
//
//  Created by zx on 10/28/16.
//  Copyright © 2016 zx. All rights reserved.
//

import JavaScriptCore


class TopoBrain: NSObject {
    
    func parse(point: [String: AnyObject]) -> CGPoint {
        var result = CGPoint.zero
        let x = point["x"]!
        let y = point["y"]!
        
        let unwrap: (AnyObject) -> CGFloat = { input in
            if input is Int {
                return CGFloat(input as! Int)
            } else if input is String {
                let inputString = input as! String
                let positiveValue = inputString.components(separatedBy: ",").last!
                if positiveValue.contains("/") {
                    return positiveValue.fraction
                } else {
                    let floatValue = NSString(string: positiveValue).floatValue
                    return CGFloat(floatValue)
                }
            }
            return 0
        }
        
        result.x = unwrap(x)
        result.y = unwrap(y)
//        print(result)
        
        return result
    }
}

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            return try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as AnyObject?
        } else {
            return nil
        }
    }
    
    var fraction: CGFloat {
        var comps = components(separatedBy: "/")
        let op1 = NSString(string: comps[0]).floatValue
        let op2 = NSString(string: comps[1]).floatValue
        return CGFloat(op1/op2)
    }
}
