//
//  SearchViewController.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/07.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.placeholder = "場所を検索"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search bar is send")
    }

}
