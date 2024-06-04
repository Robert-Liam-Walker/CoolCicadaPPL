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
    private let type = Expression<String>("type")
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
    
    func clearDatabase() {
        // Define SQL commands to drop tables
        let dropWorkoutsTableSQL = "DROP TABLE IF EXISTS workouts;"
        let dropExercisesTableSQL = "DROP TABLE IF EXISTS exercises;"
        let deleteWorkoutsSQL = "DELETE FROM workouts;"
        let deleteExercisesSQL = "DELETE FROM exercises;"
        
        do {
            // Open a connection to your SQLite database
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let db = try Connection("\(path)/workouts.sqlite3")
            
            // Execute SQL commands to drop tables
            try db.execute(dropExercisesTableSQL)
            try db.execute(dropWorkoutsTableSQL)
            
            // Execute SQL commands to delete data from each table
            try db.execute(deleteWorkoutsSQL)
            try db.execute(deleteExercisesSQL)
            
            print("Database cleared successfully")
        } catch {
            print("Error clearing database: \(error)")
        }
    }

    
    private func createTables() {
        do {
            try db?.run(workouts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(type, defaultValue: "default")
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
            let insert = workouts.insert(id <- uuidString, name <- workout.name, type <- workout.type, date <- workout.date)
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
    /*
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
    }*/
    
    func fetchHistoryWorkouts() -> [Workout] {
        var workoutsList = [Workout]()
        do {
            for workoutRow in try db!.prepare(workouts) {
                var workout = Workout(id: UUID(uuidString: workoutRow[id]) ?? UUID(), name: workoutRow[name], type: workoutRow[type], date: workoutRow[date], exercises: [])
                print("fetchHistoryWorkout workout type: ", workout.type)
                if workout.type == "history" {
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
            }
            print("Fetch workouts succeeded")
        } catch {
            print("Fetch workouts failed: \(error)")
        }
        return workoutsList
    }
    
    func fetchDefaultWorkouts() -> [Workout] {
        var workoutsList = [Workout]()
        do {
            for workoutRow in try db!.prepare(workouts) {
                var workout = Workout(id: UUID(uuidString: workoutRow[id]) ?? UUID(), name: workoutRow[name], type: workoutRow[type], date: workoutRow[date], exercises: [])

                if workout.type == "default" {
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
            }
            print("Fetch workouts succeeded")
        } catch {
            print("Fetch workouts failed: \(error)")
        }
        return workoutsList
    }
    
    func fetchCustomWorkouts() -> [Workout] {
        var workoutsList = [Workout]()
        do {
            for workoutRow in try db!.prepare(workouts) {
                var workout = Workout(id: UUID(uuidString: workoutRow[id]) ?? UUID(), name: workoutRow[name], type: workoutRow[type], date: workoutRow[date], exercises: [])

                if workout.type == "custom" {
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
            }
            print("Fetch workouts succeeded")
        } catch {
            print("Fetch workouts failed: \(error)")
        }
        return workoutsList
    }
}
