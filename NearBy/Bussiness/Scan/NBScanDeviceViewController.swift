//
//  NBScanDeviceViewController.swift
//  BTLE Transfer
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

class NBScanDeviceViewController: UIViewController {


    var tableView: UITableView!

    var discoveredDevices: [BLEDevice]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        discoveredDevices = [BLEDevice]()
        title = "扫描"
        makeTabelView()
        startScanDevices()
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BLE_MODE_CHANGED"), object: nil, queue: nil, using: { n in
//            print(n)
//        })
    }

    func makeTabelView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    func startScanDevices() {
        BLEManager.default().delegate = self
        BLEManager.default().advertisingName =  "SBOSS-\(UIDevice.current.name)"
        BLEManager.default().advertisingUUID = UserDefaults.standard.object(forKey: "ApplicationUUIDKey") as! String
        BLEManager.default().startScan()
    }

}

extension NBScanDeviceViewController: BLEManagerDelegate {

    func managerDidFindDevices(_ devices: [Any]!) {
        discoveredDevices.removeAll()
        let newlist: [BLEDevice] = devices as! [BLEDevice]
        discoveredDevices.append(contentsOf: newlist)
        tableView.reloadData()
    }

    private func managerDidFind(_ device: BLEDevice!) {

        if discoveredDevices.count == 0 {
            discoveredDevices.append(device)
        } else {
            for i in 0..<discoveredDevices.count {
                let de: BLEDevice = discoveredDevices[i]

                if de.uuidString == device.uuidString {
                    discoveredDevices[i] = device
                    tableView.reloadData()
                    return
                }
            }
        }

        discoveredDevices.append(device)
        tableView.reloadData()

    }
}

extension NBScanDeviceViewController: UITableViewDelegate {

    //MARK: delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {


        let label = UPLabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width, height: 30))

        label.text = "    扫描中..."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.verticalAlignment = UPVerticalAlignmentMiddle;

        return label
    }

}


extension NBScanDeviceViewController: UITableViewDataSource {
    //MARK: datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredDevices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let device: BLEDevice = discoveredDevices[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DeviceCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = device.name.stripePrefix()
        cell.detailTextLabel?.text = "\(device.distance)"
        return cell
    }
}

extension String {
    func stripePrefix() -> String {
        if self.hasPrefix("SBOSS-") {
            let i = index(self.startIndex, offsetBy: 6)
            let result = self.substring(from: i)
            return result
        }
        else {
            return self
        }
    }
}

