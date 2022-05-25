# Point Health Data Service

Use the Health Data Service to get user data and generated metric from the Point database.

## User Data
Retrieves information about the ``User``, such as email, first name, birthday, last workout, goals and more.
```swift
func getUser() async -> User? {
    do {
        return try await Point.healthDataService.getUserData()
    } catch {
        print("Error retrieving user data: \(error.localizedDescription)")
        return nil
    }
}
```

## User Workouts
Retrieves a list of the User's last 16 ``Workout``s, in descending order. The offset is meant to be used as a pagination, and if no value is passed, it is defaulted to 0.
```swift
func retrieveUserWorkouts(offset: Int = 0) async -> [Workout]? {
    do {
        return try await Point.healthDataService.getUserWorkouts(offset: offset)
    } catch {
        print("Error retrieving user workouts: \(error.localizedDescription)")
        return nil
    }
}
```

Retrieves a single ``Workout`` for the given id.
```swift
func retrieveWorkout(id: Int) async -> Workout? {
    do {
        return try await Point.healthDataService.getWorkout(id: id)
    } catch {
        print("Error retrieving workout: \(error.localizedDescription)")
        return nil
    }
}
```

### Workout Rating
You can allow users to rate their past workouts. A workout rating is divided in "Difficulty", "Energy" and "Instructor" ratings. Each field can be rated from 1 to 5, defaulting to 0 if a value is not set.

```swift
func rateWorkout(workout: Workout) async -> Workout {
    let ratings = WorkoutRatings(difficulty: 4, energy: 5, instructor: 3)
    do {
        let newWorkout = try await healthDataService.rate(workout: workout, ratings: ratings)
        return newWorkout
    } catch {
        print("Error when rating workout: \(error.localizedDescription)")
        return workout
    }
}
```

> We recommend you to rate a workout only once.

## Daily History
Retrieves a list of the User's last 16 days worth of ``DailyHistory``, in descending order. The ``DailyHistory`` is composed of daily total calories, exertion rate and total workout duration. The offset is meant to be used as a pagination, and if no value is passed, it is defaulted to 0.
```swift
func getDailyHistory(offset: Int = 0) async -> [DailyHistory]? {
    do {
        return try await Point.healthDataService.getDailyHistory(offset: offset)
    } catch {
        print("Error retrieving daily history: \(error.localizedDescription)")
        return nil
    }
}
```

## User Health Metrics

You can get a set of user health metrics, which are a summary of the collected samples. Check ``HealthMetric`` to know all kinds of health metrics available.

```swift
func getUserHealthMetrics() async -> [HealthMetric]? {
    do {
        return try await Point.healthDataService.getHealthMetrics(
            filter: Set(HealthMetric.Kind.allCases),
            workoutId: nil,
            date: nil
        )
    } catch {
        print("Error retrieving user health metrics: \(error.localizedDescription)")
        return nil
    }
}
```
> You can filter by type, workout or date.

## Goals
Goals are used to generate **recommendations** and insights for the user.

Sets the user ``Goal``. This is more limited set of options. If you wish to provide more options, use the **Specific Goal**.
```swift
func setUserGoal(goal: Goal) async {
    do {
        let result = try await Point.healthDataService.syncUserGoal(goal: goal)
        print(result)
    } catch {
        print(error.localizedDescription)
    }
}
```

Sets the user ``SpecificGoal``. This provides a wider array of options. Calling this function also sets the ``Goal``.
```swift
func setUserSpecificGoal(goal: SpecificGoal) async {
    do {
        let result = try await Point.healthDataService.syncUserSpecificGoal(specificGoal: goal)
        print(result)
    } catch {
        print(error.localizedDescription)
    }
}
```

> Important: Both functions are mutually exclusive. Do not use both as it may cause unintended changes in the database.

## Workout Recommendations
Retrieves a list of ``WorkoutRecommendation``. Workout recommendations are generated weekly on the Point database, based in the user **goal**. The date parameter defines which week you will get recommendations from. 
```swift
func getWorkoutsRecommendations(date: Date) async -> [WorkoutRecommendation]? {
    do {
        return try await Point.healthDataService.getWorkoutRecommendations(date: date)
    } catch {
        print("Error retrieving workout recommendations \(error.localizedDescription)")
        return nil
    }
}
```

> Tip: Use the current date to get recommendations from the current week.


## Trends
You can get the user ``Trend``s for the last 3 months, like average workout duration and record calories burned. To get a trend content, you must access the dictionary ``Trend/additionalFields`` and handle its content individually. Each trend has an associated ``Trend/TrendType`` that determines what keys will be available in the dictionary and how you should handle its values.

```swift
func printAverageWorkoutDuration() async {
    guard let trends = await getUserTrends() else { return }
    for trend in trends {
        if trend.type == .avgWorkoutDuration {
            print("Average workout duration: \(trend.additionalFields["avg_value"]! as! Double)")
        }
    }
}

func getUserTrends() async -> [Trend]? {
    do {
        return try await Point.healthDataService.getUserTrends()
    } catch {
        print("Error retrieving user trends \(error.localizedDescription)")
        return nil
    }
}
```

## User Recommendations

Retrieves a list of ``UserRecommendation``. `Point` periodically checks if it can create a new personalized recommendation. A recommendation will be available for a finite time before it expires. There are different types of insights, listed in ``InsightType``.

```swift
func getUserRecommendations() async -> [UserRecommendations]? {
    do {
        try await healthDataService.getUserRecommendations()
    } catch {
        print("Error retrieving user recommendations \(error.localizedDescription)")
        return nil
    }
}
```

You can also filter for specific insight types.
```swift
func getUserRecommendations() async -> [UserRecommendations]? {
    do {
        try await healthDataService.getUserRecommendations(types: [.routineWorkoutTypeOptimization])
    } catch {
        print("Error retrieving user recommendations \(error.localizedDescription)")
        return nil
    }
}
```

## Topics

### API Data 
- ``HealthDataService``
- ``SyncResult``
- ``BatchSyncResult``
- ``User``
- ``Workout``
- ``WorkoutRatings``
- ``HealthMetric``
- ``DailyHistory``
- ``Goal``
- ``SpecificGoal``
- ``GoalProgress``
- ``GoalProgressItem``
- ``Trend``
- ``WorkoutRecommendation``
- ``UserRecommendation``
