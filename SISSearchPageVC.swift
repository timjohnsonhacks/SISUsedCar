//
//  SISSearchPageVC.swift
//  SISUsedCar
//
//  Created by Trevor Beasty on 7/24/17.
//  Copyright © 2017 SouthernImportSpecialist. All rights reserved.
//

import UIKit

class SISSearchPageVC: UIViewController {

    private var totalItemCount: Int
    private var itemsPerPage: Int
    private var buttonSize: CGSize
    private weak var delegate: SISSearchPageButtonDelegate?
    private weak var searchStack: SISSearchPageButtonStack!
    private var lastSelectedPageNumber: Int?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    init(totalItemCount: Int, itemsPerPage: Int, buttonSize: CGSize, delegate: SISSearchPageButtonDelegate) {
        self.totalItemCount = totalItemCount
        self.itemsPerPage = itemsPerPage
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
        configure(
            totalItemCount: totalItemCount,
            itemsPerPage: itemsPerPage)
        scrollViewWidth.constant = 0.0
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
    
    public func giveButtonSelectedAppearance(pageNumber: Int) {
        if let lastSelectedPageNumber = lastSelectedPageNumber {
            searchStack.buttons[lastSelectedPageNumber].isSelected = false
        }
        searchStack.buttons[pageNumber].isSelected = true
        lastSelectedPageNumber = pageNumber
    }
    
    public func configure(totalItemCount: Int, itemsPerPage: Int) {
        searchStack?.removeFromSuperview()
        // create button view / setup scroll view
        let totalSections = totalItemCount / itemsPerPage + 1
        print("total sections: \(totalSections)")
        let ss = SISSearchPageButtonStack(
            totalSections: totalSections,
            buttonSize: buttonSize,
            spacing: 2.0,
            color_1: SISGlobalConstants.calmBlue,
            color_2: .white,
            borderWidth: 2.0,
            delegate: delegate!)
        scrollView.addSubview(ss)
        scrollViewHeight.constant = ss.bounds.height
        searchStack = ss
        self.totalItemCount = totalItemCount
        self.itemsPerPage = itemsPerPage
    }
}

















