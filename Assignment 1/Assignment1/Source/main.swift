//
//  main.swift
//  Assignment1
//

let triEvent = TriathlonEvent(triathlon: Triathlon.halfIronman)

triEvent.register(Swimmer(name: "Cassi"))
triEvent.register(Swimmer(name: "Jason"))
triEvent.register(Swimmer(name: "Kathy"))
triEvent.register(Cyclist(name: "Asia"))
triEvent.register(Cyclist(name: "David"))
triEvent.register(Runner(name: "Sigh"))
triEvent.register(Runner(name: "Becky"))
triEvent.register(Athlete(name: "Charles"))
triEvent.register(Athlete(name: "Chuck"))

triEvent.simulate()

if let winner = triEvent.winner {
    print("\(winner.name) wins first place with a total time of \(triEvent.participants[winner.name]!) minutes!")
} else {
    print("No one finished the race!")
}
