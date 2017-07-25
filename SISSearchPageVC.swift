//
//  SISSearchPageVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSearchPageVC: UIViewController {

    let totalItemCount: Int
    let itemsPerSection: Int
    let buttonSize: CGSize
    weak var searchStack: SISSearchPageButtonStack!
    
    weak var buttonContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    init(totalItemCount: Int, itemsPerSection: Int, buttonSize: CGSize) {
        self.totalItemCount = totalItemCount
        self.itemsPerSection = itemsPerSection
        self.buttonSize = buttonSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create button view / setup scroll view
        let totalSections = totalItemCount / itemsPerSection + 1
        let ss = SISSearchPageButtonStack(
            totalSections: totalSections,
            buttonSize: CGSize(width: 44.0, height: 44.0),
            spacing: 2.0,
            color_1: .black,
            color_2: .white,
            borderWidth: 2.0,
            delegate: self)
        scrollView.addSubview(ss)
        searchStack = ss
        scrollViewHeight.constant = ss.bounds.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if scrollView.bounds.size.width < searchStack.bounds.size.width {
            
            let naturalFrame = searchStack.naturalFrame
            searchStack.frame = searchStack.naturalFrame
            scrollView.contentSize = naturalFrame.size
            scrollView.isScrollEnabled = true
            
        } else {
            
            searchStack.center = scrollView.center
            scrollView.contentSize = scrollView.bounds.size
            scrollView.isScrollEnabled = false
            
        }
    }
}

extension SISSearchPageVC: MasterPageControllerProtocol {
    
}
















