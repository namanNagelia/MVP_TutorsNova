//
//  FirebaseManager.swift
//  MVP_Tutors
//
//  Created by Manas Nagelia on 10/27/23.
//
import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
