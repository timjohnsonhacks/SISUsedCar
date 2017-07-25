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
    let calmBlue = UIColor(
        colorLiteralRed: 94.0 / 255.0,
        green: 198.0 / 255.0,
        blue: 255.0 / 255.0,
        alpha: 1.0)
    let delegate: SISSearchPageButtonDelegate
    weak var searchStack: SISSearchPageButtonStack!
    
    weak var buttonContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    init(totalItemCount: Int, itemsPerSection: Int, buttonSize: CGSize, delegate: SISSearchPageButtonDelegate) {
        self.totalItemCount = totalItemCount
        self.itemsPerSection = itemsPerSection
        self.buttonSize = buttonSize
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsHorizontalScrollIndicator = false
        
        // create button view / setup scroll view
        let totalSections = totalItemCount / itemsPerSection + 1
        let ss = SISSearchPageButtonStack(
            totalSections: totalSections,
            buttonSize: buttonSize,
            spacing: 2.0,
            color_1: calmBlue,
            color_2: .white,
            borderWidth: 2.0,
            delegate: delegate)
        scrollView.addSubview(ss)
        searchStack = ss
        scrollViewHeight.constant = ss.bounds.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if view.bounds.size.width < searchStack.naturalFrame.size.width {
            
            scrollViewWidth.constant = view.bounds.size.width
            let naturalFrame = searchStack.naturalFrame
            searchStack.frame = searchStack.naturalFrame
            scrollView.contentSize = naturalFrame.size
            scrollView.isScrollEnabled = true
            
        } else {
            
            scrollViewWidth.constant = searchStack.naturalFrame.size.width
            scrollView.contentSize = scrollView.bounds.size
            scrollView.isScrollEnabled = false
            
        }
    }
}

















