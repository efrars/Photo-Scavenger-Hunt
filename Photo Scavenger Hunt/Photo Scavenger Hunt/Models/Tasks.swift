//
//  Tasks.swift
//  Photo Scavenger Hunt
//
//  Created by Efrain Rodriguez on 2/16/23.
//

import UIKit
import CoreLocation
import MapKit


// creating the Task class

class Task {
    let title: String
    let question: String
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }
    
    init(title: String, question: String) {
        self.title = title
        self.question = question
    }
    
    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }
    
}

extension Task {
    static var mockedTasks: [Task] {
        return [
        
        Task(title: "Your favorite hiking spot", question: "Where do you go to be with nature?"),
        Task(title: "Your favorite restaurant", question: "Which is your favorite restaurant?"),
        Task(title: "Your favorite store", question: "Where do you usually shop?"),
        Task(title: "Your favorite beach", question: "Where is your favorite beach?"),
        Task(title: "Your favorite park", question: "Where is your favorite park?"),
        ]
    }
    
  
}
