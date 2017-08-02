//
//  UIViewController+Custom.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/26/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

extension UIViewController {
    func fullyImplementAsChild(parent: UIViewController, viewHierarchyConfig: () -> Void) {
        parent.addChildViewController(self)
        viewHierarchyConfig()
        self.didMove(toParentViewController: parent)
    }
}
