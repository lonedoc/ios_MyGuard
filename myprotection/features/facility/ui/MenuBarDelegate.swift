//
//  MenuBarDelegate.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.12.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

protocol MenuBarDelegate {
    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int)
}
