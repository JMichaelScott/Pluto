//
//  ViewController.swift
//  Pluto
//
//  Created by Faisal Lalani on 9/11/16.
//  Copyright © 2016 Faisal M. Lalani. All rights reserved.
//

import Firebase
import FirebaseAuth
import pop
import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    // Buttons
    @IBOutlet weak var goButton: Button!
    @IBOutlet weak var facebookButton: UIButton!
    
    // Constraints
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var goButtonTopConstraint: NSLayoutConstraint!
    
    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Variables
    
    // Animation Engine
    var animEngine: AnimationEngine!
    
    // MARK: View Functions
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Starts the animation engine and brings all elements up.
        self.animEngine.animateOnScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gives the animation engine the constraints it needs to modify in order to create the animation.
        self.animEngine = AnimationEngine(constraints: [titleTopConstraint, emailFieldTopConstraint, passwordFieldTopConstraint, goButtonTopConstraint])
        
        // Dismisses the keyboard if the user taps anywhere on the screen.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard)))
        
        // Sets the text field delegates accordingly.
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func goButtonAction(_ sender: AnyObject) {
        
        dismissKeyboard()
        logIn()
    }
    
    @IBAction func facebookLoginButtonAction(_ sender: AnyObject) {
        //look up code in firebase docs	
    }
    
    // MARK: - Firebase
    
    /**
 
     Checks the inputted email and password, creates the user on Firebase, and logs the user in if successful.
 
    */
    func createAccount() {
        
        FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {
            
            user, error in
                
                if error != nil {
                    
                    // Error!
                                        
                    print("ERROR: Something went wrong creating an account")
                    
                } else {
                    
                    // No errors!
                    
                    print("SUCCESS: User is created")
                    self.logIn()
                }
        })
    }
    
    /**
     
        Logs the user in if successful; creates an account if user is not found in database.
     
     */
    func logIn() {
        
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: {
          
            user, error in
                
                if error != nil {
                    
                    // Error!
                    
                    print("ERROR: Something went wrong logging in.")
                    print(error)
                    
                    if error?._code == STATUS_ACCOUNT_NONEXIST {
                        
                        print("This user doesn't exist. Creating account now...")
                        
                        self.createAccount()
                    }
                    
                } else {
                    
                    // No errors!
                    
                    print("SUCCESS: User is logged in.")
                    
                    self.animateOffScreen(view: self.goButton)
                    self.animateOffScreen(view: self.passwordField)
                    self.animateOffScreen(view: self.emailField)
                    self.animateOffScreen(view: self.titleLabel)
                    
                    // Switches to the setup screen.
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Setup")
                    self.present(vc!, animated: true, completion: nil)
                }
        })
    }
    
    // MARK: - Helpers
    
    func animateOffScreen(view: UIView) {
        
        AnimationEngine.animateToPosition(view: view, position: CGPoint(x: AnimationEngine.centerPosition.x, y: AnimationEngine.offScreenBottomPosition.y + 1000))
    }
    
    func dismissKeyboard() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    // MARK: - Text Field Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Dismisses the keyboard.
        textField.resignFirstResponder()
        return true
    }
}

