//
//  MenuViewController.swift
//  CompunnelBootcamp
//
//  Created by Rishik Dev on 27/01/23.
//

import UIKit

class ContentListViewController: UIViewController {

    @IBOutlet weak var segmentedControlsContentType: UISegmentedControl!
    
    @IBOutlet weak var labelUsername: UILabel!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var buttonLogout: UIButton!
    
    var username: String?
    
    var yourContent: [ContentStruct] = [
        ContentStruct(name: "Police Story 1", genre: "Action", thumbnail: "policeStory1"),
        ContentStruct(name: "Police Story 2", genre: "Action", thumbnail: "policeStory2"),
        ContentStruct(name: "Police Story 3", genre: "Action", thumbnail: "policeStory3"),
        ContentStruct(name: "Armour of God 1", genre: "Adventure", thumbnail: "armourOfGod1"),
        ContentStruct(name: "Armour of God 2", genre: "Adventure", thumbnail: "armourOfGod2"),
        ContentStruct(name: "Project A", genre: "Action", thumbnail: "projectA"),
        ContentStruct(name: "Project A Part 2", genre: "Action", thumbnail: "projectAPart2"),
        ContentStruct(name: "City Hunter", genre: "Comedy", thumbnail: "cityHunter")]
    
    var contentSharedWithYou: [ContentStruct] = [
        ContentStruct(name: "Scooby-Doo, Where Are You!", genre: "Adventure", thumbnail: "scoobyDoo"),
        ContentStruct(name: "Tom and Jerry", genre: "Comedy", thumbnail: "tomAndJerry"),
        ContentStruct(name: "The Jetsons", genre: "Comedy", thumbnail: "theJetsons"),
        ContentStruct(name: "The Flintstones", genre: "Comedy", thumbnail: "theFlintstones"),
        ContentStruct(name: "Dexter's Laboratory", genre: "Adventure", thumbnail: "dextersLaboratory"),
        ContentStruct(name: "Johnny Bravo", genre: "Comedy", thumbnail: "johnnyBravo"),
        ContentStruct(name: "Courage the Cowardly Dog", genre: "Adventure", thumbnail: "courageTheCowardlyDog"),
        ContentStruct(name: "The Powerpuff Girls", genre: "Action", thumbnail: "thePowerpuffGirls"),
        ContentStruct(name: "Ed, Edd n Eddy", genre: "Adventure", thumbnail: "edEddNEddy")]
    
    var content: [ContentStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        labelUsername.text = "Hello " + username! + "!"
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        content = yourContent
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        configureButton(button: buttonLogout, buttonTitle: "Logout", buttonColour: .systemRed)
    }
    
    @IBAction func onContentTypeValueChange(_ sender: Any) {
        
        switch(segmentedControlsContentType.selectedSegmentIndex) {
            
        case 0:
            content = yourContent
            self.contentTableView.reloadData()
        
        case 1:
            content = contentSharedWithYou
            self.contentTableView.reloadData()
        
        default: content = yourContent
            
        }
    }
    
    private func configureButton(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
        button.configuration?.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        button.configuration?.imagePadding = 10
    }
    
    @IBAction func buttonLogoutAction(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }

}

struct ContentStruct {
    var title: String
    var genre: String
    var thumbnail: String
    
    init(name: String, genre: String, thumbnail: String) {
        self.title = name
        self.genre = genre
        self.thumbnail = thumbnail
    }
}

extension ContentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected \(content[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
                
        cell.labelTitle.text = content[indexPath.row].title
        cell.labelGenre.text = content[indexPath.row].genre
        cell.imageViewThumbnail.image = UIImage(named: content[indexPath.row].thumbnail)
        
        return cell
    }
    
}
