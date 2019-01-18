//
//  Participant.swift
//  Assignment1
//

protocol Participant {
    init(name: String)
    var name: String { get }
    var favoriteSport: Sport? { get }
    func completionTime(for: Sport, in: Triathlon, randomValue: Double) -> Int
    func completionTime(for: Sport, in: Triathlon) -> Int
}

extension Participant {
    
    func metersPerMinute (for sport: Sport, randomValue: Double = Double.random()) -> Int {
        var value: Double
        
        switch sport {
        case .swimming:
            value = 43
        case .cycling:
            value = 500
        case .running:
            value = 157
        }
        
        var modifier = 0.8 + (randomValue * 0.4)
        if let favoriteSport = self.favoriteSport {
            if favoriteSport == sport {
                modifier += 0.1
            }
            else {
                modifier -= 0.1
            }
        }
        return Int(value * modifier)
    }
    
    func completionTime(for sport: Sport, in tri: Triathlon) -> Int {
        return completionTime(for: sport, in: tri, randomValue: Double.random())
    }
    
    func completionTime(for sport: Sport, in tri: Triathlon, randomValue: Double) -> Int {
        let triDist: Int = tri.distance(for: sport)
        let sportTime: Int = metersPerMinute(for: sport, randomValue: randomValue)
        return triDist / sportTime
    }
}
