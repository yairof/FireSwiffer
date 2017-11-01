//
//  SweetsTableViewController.swift
//  
//
//  Created by Yairo Fernandez on 10/17/17.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SweetsTableViewController: UITableViewController {

    var dbRef:DatabaseReference!
    var sweets = [Sweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("sweet-items")
        startObservingDB()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener({ (Auth, User) in
            if let user = User {
                print("Welcome \(user.email)")
                self.startObservingDB()
            } else{
                print("You need to sign up or login first")
            }
        })
    }
    
    @IBAction func loginAndSignUp(_ sender: Any) {
        
        let userAlert = UIAlertController(title: "Login/Sign up", message: "Enter email and password", preferredStyle: .alert)
        userAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "email"
            
        })
        
        userAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.isSecureTextEntry = true
            textField.placeholder = "password"
        })
        
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: {
            alert -> Void in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign up", style: .default, handler: {
            alert -> Void in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }))
        
        self.present(userAlert, animated: true, completion: nil)
    }
    
    
    func startObservingDB () {
        dbRef.observe(.value, with: { (snapshot:DataSnapshot) in
            var newSweets = [Sweet]()
            
            for sweet in snapshot.children {
                let sweetObject = Sweet(snapshot: sweet as! DataSnapshot)
                newSweets.append(sweetObject)
            }
            self.sweets = newSweets
            self.tableView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
    }

    @IBAction func addSweet(_ sender: Any) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your Sweet", preferredStyle: .alert)
        sweetAlert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Your sweet"
        })
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {
            alert -> Void in
            if let sweetContent = sweetAlert.textFields?.first?.text {
                let sweet = Sweet(content: sweetContent, addedByUser: "Yairo")
                
                let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.toAnyObject())
            }
        }))
        self.present(sweetAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let sweet = sweets[indexPath.row]
        
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.addedByUser

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sweet = sweets[indexPath.row]
            
            sweet.itemRef?.removeValue()
        }
    }

}
