//
//  Athlete.swift
//  Assignment1
//

class Athlete : Participant {
    var name: String
    
    required init(name: String) {
         self.name = name
    }
    
    var favoriteSport: Sport? {
        get {
           return nil
        }
    }
    
}

