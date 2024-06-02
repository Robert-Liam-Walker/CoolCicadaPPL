import SQLite
import Foundation

class SQLiteDatabase {
    static let shared = SQLiteDatabase()
    private var db: Connection?
    
    private let workouts = Table("workouts")
    
    private let id = Expression<UUID>("id")
    private let name = Expression<String>("name")
    private let date = Expression<Date>("date") // New column for date
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/workouts.sqlite3")
            createTables()
        } catch {
            print("Unable to open database.")
        }
    }
    
    private func createTables() {
        do {
            try db?.run(workouts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(date) // Add column for date
            })
        } catch {
            print("Unable to create tables.")
        }
    }
    
    func insertWorkout(_ workout: Workout) -> UUID? {
        do {
            let insert = workouts.insert(id <- workout.id, name <- workout.name, date <- workout.date)
            try db?.run(insert)
            return workout.id
            print("insertWorkout succeeded")
        } catch {
            print("Insert workout failed: \(error)")
            return nil
        }
    }
    
    func fetchWorkouts() -> [Workout] {
        var workoutsList = [Workout]()
        do {
            for workout in try db!.prepare(workouts) {
                let workoutItem = Workout(name: workout[name], exercises: [], date: workout[date]) // Include date
                workoutsList.append(workoutItem)
            }
            print("Fetch workouts succeeded")
        } catch {
            print("Fetch workouts failed: \(error)")
        }
        return workoutsList
    }
}
