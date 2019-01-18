//
//  TriathlonEvent.swift
//  Assignment1
//

class TriathlonEvent {
    var triathlon: Triathlon
    private(set) var eventPerformed: Bool = false
    var participants = Dictionary<String, Int>()
    var registeredArray = Array<Participant>()
    
    init(triathlon: Triathlon) {
        self.triathlon = triathlon
    }
    
    func register(_ participant: Participant) {
        guard eventPerformed == false else {
            fatalError()
        }
        participants[participant.name] = 0
        registeredArray.append(participant)
    }
    
    var registeredParticipants: [Participant] {
        get {
            return registeredArray
            }
        }
    
    func raceTime(for participant: Participant) -> Int? {
        guard let time = participants[participant.name] else {
            return nil
        }
        return time
    }
    
    func simulate(_ sport: Sport, for participant: Participant, randomValue: Double = Double.random()) {
        guard let totalTime = raceTime(for: participant) else {
            return
        }
        
        // participant starting event
        print("\(participant.name) is about to begin \(sport).")
        
        if sport == participant.favoriteSport || randomValue >= 0.06 {
                
            //participant finishing event
            let result: Int = participant.completionTime(for: sport, in: triathlon)
            participants[participant.name] = totalTime + result
            print("\(participant.name) finished the \(sport) event in \(result) minutes; their total race time is now \(participants[participant.name]!) minutes.")
                
        } else if randomValue < 0.06 && sport != participant.favoriteSport {
                
            //participant dropping out of race
            participants[participant.name] = nil
            print("\(participant.name) could not finish the \(sport) event and will not finish the race.")
        }
    }
    
    func simulate() {
        guard eventPerformed == false else {
            fatalError()
        }
        
        for sport in Triathlon.sports {
            for participant in registeredParticipants {
                simulate(sport, for: participant)
            }
        }
        eventPerformed = true
    }
    
    var winner: Participant? {
        get {
            var leadTime: Int = 0
            var leadParticipant: Participant?
            var count = 1;
            
            guard eventPerformed == true else {
                fatalError()
            }
            
            for (currName, currTime) in participants {
                if currTime < leadTime || count == 1 {
                    leadTime = currTime
                    
                    for participant in registeredParticipants {
                        if currName == participant.name {
                            leadParticipant = participant
                            count += 1
                        }
                    }
                }
            }
            return leadParticipant
        }
    }
}

