// SQLiteDatabase.swift

import SQLite
import Foundation

class SQLiteDatabase {
    static let shared = SQLiteDatabase()
    private var db: Connection?
    
    private let workouts = Table("workouts")
    private let exercises = Table("exercises")
    
    private let id = Expression<String>("id")
    private let workoutId = Expression<String>("workout_id")
    private let name = Expression<String>("name")
    private let date = Expression<Date>("date")
    private let exerciseName = Expression<String>("exercise_name")
    private let sets = Expression<Int>("sets")
    private let reps = Expression<String>("reps")
    private let weight = Expression<Int>("weight")
    
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
                table.column(date)
            })
            
            try db?.run(exercises.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(workoutId)
                table.column(exerciseName)
                table.column(sets)
                table.column(reps)
                table.column(weight)
                table.foreignKey(workoutId, references: workouts, id, delete: .cascade)
            })
        } catch {
            print("Unable to create tables.")
        }
    }
    
    func insertWorkout(_ workout: Workout) -> String? {
        do {
            let uuidString = workout.id.uuidString
            let insert = workouts.insert(id <- uuidString, name <- workout.name, date <- workout.date)
            try db?.run(insert)
            print("Insert workout succeeded")
            return uuidString
        } catch {
            print("Insert workout failed: \(error)")
            return nil
        }
    }
    
    func insertExercise(_ exercise: Exercise, forWorkoutId workoutId: UUID) -> String? {
        do {
            let exerciseId = UUID().uuidString
            let insert = exercises.insert(self.id <- exerciseId, self.workoutId <- workoutId.uuidString, self.exerciseName <- exercise.name, self.sets <- exercise.sets, self.reps <- exercise.reps, self.weight <- exercise.weight)
            try db?.run(insert)
            print("Insert exercise succeeded")
            return exerciseId
        } catch {
            print("Insert exercise failed: \(error)")
            return nil
        }
    }
    
    func fetchWorkouts() -> [Workout] {
        var workoutsList = [Workout]()
        do {
            for workoutRow in try db!.prepare(workouts) {
                var workout = Workout(id: UUID(uuidString: workoutRow[id]) ?? UUID(), name: workoutRow[name], date: workoutRow[date], exercises: [])

                // Fetch exercises for the workout
                var exercisesList = [Exercise]()
                let workoutIdString = workoutRow[id]
                let workoutExercises = exercises.filter(self.workoutId == workoutIdString)
                for exerciseRow in try db!.prepare(workoutExercises) {
                    let exercise = Exercise(name: exerciseRow[exerciseName], sets: exerciseRow[sets], reps: exerciseRow[reps], weight: exerciseRow[weight])
                    exercisesList.append(exercise)
                }
                workout.exercises = exercisesList
                
                workoutsList.append(workout)
            }
            print("Fetch workouts succeeded")
        } catch {
            print("Fetch workouts failed: \(error)")
        }
        return workoutsList
    }
}
