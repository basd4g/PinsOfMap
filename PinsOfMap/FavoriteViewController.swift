//
//  FavoriteViewController.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/07.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import UIKit
import MapKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PINS.registerUITableView(uitableview: tableView)
        return PINS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = PINS.getTitle(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let UINavigationController = tabBarController?.viewControllers?[0]
        tabBarController?.selectedViewController = UINavigationController
        
        if let controller: ViewController = tabBarController?.viewControllers?[0] as? ViewController {
            controller.showPoint(point: PINS.getPin(index: indexPath.row) )
        }
    }

}
