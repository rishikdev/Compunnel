//
//  PostView.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 13/03/23.
//

import UIKit

class PostView: UIView {
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelTimeCreated: UILabel!
    @IBOutlet weak var imageViewPostPhoto: UIImageView!
    @IBOutlet weak var labelUserNameDescription: UILabel!
    @IBOutlet weak var labelPostDescription: UILabel!
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var stackViewDescription: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("PostView", owner: self)![0] as! UIView
        stackViewMain.layer.cornerRadius = 10
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
