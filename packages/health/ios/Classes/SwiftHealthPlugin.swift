import Flutter
import HealthKit
import UIKit

public class SwiftHealthPlugin: NSObject, FlutterPlugin {
    
    let healthStore = HKHealthStore()
    var healthDataTypes = [HKSampleType]()
    var heartRateEventTypes = Set<HKSampleType>()
    var ecgTypes = Set<HKSampleType>()
    var allDataTypes = Set<HKSampleType>()
    var dataTypesDict: [String: HKSampleType] = [:]
    var symptomTypesDict: [String: HKSampleType] = [:]
    var unitDict: [String: HKUnit] = [:]
    
    // Health Data Type Keys
    let ACTIVE_ENERGY_BURNED = "ACTIVE_ENERGY_BURNED"
    let BASAL_ENERGY_BURNED = "BASAL_ENERGY_BURNED"
    let BLOOD_GLUCOSE = "BLOOD_GLUCOSE"
    let BLOOD_OXYGEN = "BLOOD_OXYGEN"
    let BLOOD_PRESSURE_DIASTOLIC = "BLOOD_PRESSURE_DIASTOLIC"
    let BLOOD_PRESSURE_SYSTOLIC = "BLOOD_PRESSURE_SYSTOLIC"
    let BODY_FAT_PERCENTAGE = "BODY_FAT_PERCENTAGE"
    let BODY_MASS_INDEX = "BODY_MASS_INDEX"
    let BODY_TEMPERATURE = "BODY_TEMPERATURE"
    let ELECTRODERMAL_ACTIVITY = "ELECTRODERMAL_ACTIVITY"
    let SIEMENS = "SIEMENS"
    let HEART_RATE = "HEART_RATE"
    let HEART_RATE_VARIABILITY_SDNN = "HEART_RATE_VARIABILITY_SDNN"
    let HEIGHT = "HEIGHT"
    let HIGH_HEART_RATE_EVENT = "HIGH_HEART_RATE_EVENT"
    let IRREGULAR_HEART_RATE_EVENT = "IRREGULAR_HEART_RATE_EVENT"
    let LOW_HEART_RATE_EVENT = "LOW_HEART_RATE_EVENT"
    let RESTING_HEART_RATE = "RESTING_HEART_RATE"
    let STEPS = "STEPS"
    let WAIST_CIRCUMFERENCE = "WAIST_CIRCUMFERENCE"
    let WALKING_HEART_RATE = "WALKING_HEART_RATE"
    let WEIGHT = "WEIGHT"
    let DISTANCE_WALKING_RUNNING = "DISTANCE_WALKING_RUNNING"
    let FLIGHTS_CLIMBED = "FLIGHTS_CLIMBED"
    let WATER = "WATER"
    let MINDFULNESS = "MINDFULNESS"
    let SLEEP_IN_BED = "SLEEP_IN_BED"
    let SLEEP_ASLEEP = "SLEEP_ASLEEP"
    let SLEEP_AWAKE = "SLEEP_AWAKE"
    let ELECTROCARDIOGRAM = "ELECTROCARDIOGRAM"
    let FORCED_EXPIRATORY_VOLUME = "FORCED_EXPIRATORY_VOLUME"
    let INSULIN_DELIVERY = "INSULIN_DELIVERY"
    let RESPIRATORY_RATE = "RESPIRATORY_RATE"
    let PERIPHERAL_PERFUSION_INDEX = "PERIPHERAL_PERFUSION_INDEX"
    let DISTANCE_SWIMMING = "DISTANCE_SWIMMING"
    let DISTANCE_CYCLING = "DISTANCE_CYCLING"
    let SLEEP_DEEP = "SLEEP_DEEP"
    let SLEEP_LIGHT = "SLEEP_LIGHT"
    let SLEEP_REM = "SLEEP_REM"
    
    let EXERCISE_TIME = "EXERCISE_TIME"
    let WORKOUT = "WORKOUT"
    let HEADACHE_UNSPECIFIED = "HEADACHE_UNSPECIFIED"
    let HEADACHE_NOT_PRESENT = "HEADACHE_NOT_PRESENT"
    let HEADACHE_MILD = "HEADACHE_MILD"
    let HEADACHE_MODERATE = "HEADACHE_MODERATE"
    let HEADACHE_SEVERE = "HEADACHE_SEVERE"
    let NUTRITION = "NUTRITION"
    let BIRTH_DATE = "BIRTH_DATE"
    let GENDER = "GENDER"
    let BLOOD_TYPE = "BLOOD_TYPE"
    let MENSTRUATION_FLOW = "MENSTRUATION_FLOW"
    
    // SYMPTOMS
    let ABDOMINAL_CRAMPS = "ABDOMINAL_CRAMPS"
    let ACNE = "ACNE"
    let APPETITE_CHANGES = "APPETITE_CHANGES"
    let BLADDER_INCONTINENCE = "BLADDER_INCONTINENCE"
    let BLOATING = "BLOATING"
    let BREAST_PAIN = "BREAST_PAIN"
    let CHEST_TIGHTNESS_OR_PAIN = "CHEST_TIGHTNESS_OR_PAIN"
    let CHILLS = "CHILLS"
    let CONSTIPATION = "CONSTIPATION"
    let COUGHING = "COUGHING"
    let DIARRHEA = "DIARRHEA"
    let DIZZINESS = "DIZZINESS"
    let DRY_SKIN = "DRY_SKIN"
    let FAINTING = "FAINTING"
    let FATIGUE = "FATIGUE"
    let FEVER = "FEVER"
    let GENERALIZED_BODY_ACHE = "GENERALIZED_BODY_ACHE"
    let HAIR_LOSS = "HAIR_LOSS"
    let HEADACHE = "HEADACHE"
    let HEARTBURN = "HEARTBURN"
    let HOT_FLASHES = "HOT_FLASHES"
    let LOSS_OF_SMELL = "LOSS_OF_SMELL"
    let LOSS_OF_TASTE = "LOSS_OF_TASTE"
    let LOWER_BACK_PAIN = "LOWER_BACK_PAIN"
    let MEMORY_LAPSE = "MEMORY_LAPSE"
    let MOOD_CHANGES = "MOOD_CHANGES"
    let NAUSEA = "NAUSEA"
    let NIGHT_SWEATS = "NIGHT_SWEATS"
    let PELVIC_PAIN = "PELVIC_PAIN"
    let RAPID_POUNDING_OR_FLUTTERING_HEARTBEAT = "RAPID_POUNDING_OR_FLUTTERING_HEARTBEAT"
    let RUNNY_NOSE = "RUNNY_NOSE"
    let SHORTNESS_OF_BREATH = "SHORTNESS_OF_BREATH"
    let SINUS_CONGESTION = "SINUS_CONGESTION"
    let SKIPPED_HEARTBEAT = "SKIPPED_HEARTBEAT"
    let SLEEP_CHANGES = "SLEEP_CHANGES"
    let SORE_THROAT = "SORE_THROAT"
    let VAGINAL_DRYNESS = "VAGINAL_DRYNESS"
    let VOMITING = "VOMITING"
    let WHEEZING = "WHEEZING"
    
    // Health Unit types
    // MOLE_UNIT_WITH_MOLAR_MASS, // requires molar mass input - not supported yet
    // MOLE_UNIT_WITH_PREFIX_MOLAR_MASS, // requires molar mass & prefix input - not supported yet
    let GRAM = "GRAM"
    let KILOGRAM = "KILOGRAM"
    let KILOGRAMS = "KILOGRAMS"
    let OUNCE = "OUNCE"
    let POUND = "POUND"
    let STONE = "STONE"
    let METER = "METER"
    let METERS = "METERS"
    let INCH = "INCH"
    let FOOT = "FOOT"
    let YARD = "YARD"
    let MILE = "MILE"
    let LITER = "LITER"
    let MILLILITER = "MILLILITER"
    let FLUID_OUNCE_US = "FLUID_OUNCE_US"
    let FLUID_OUNCE_IMPERIAL = "FLUID_OUNCE_IMPERIAL"
    let CUP_US = "CUP_US"
    let CUP_IMPERIAL = "CUP_IMPERIAL"
    let PINT_US = "PINT_US"
    let PINT_IMPERIAL = "PINT_IMPERIAL"
    let PASCAL = "PASCAL"
    let MILLIMETER_OF_MERCURY = "MILLIMETER_OF_MERCURY"
    let INCHES_OF_MERCURY = "INCHES_OF_MERCURY"
    let CENTIMETER_OF_WATER = "CENTIMETER_OF_WATER"
    let ATMOSPHERE = "ATMOSPHERE"
    let DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL = "DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL"
    let SECOND = "SECOND"
    let MILLISECOND = "MILLISECOND"
    let MILLISECONDS = "MILLISECONDS"
    let MINUTE = "MINUTE"
    let MINUTES = "MINUTES"
    let HOUR = "HOUR"
    let DAY = "DAY"
    let JOULE = "JOULE"
    let KILOCALORIE = "KILOCALORIE"
    let LARGE_CALORIE = "LARGE_CALORIE"
    let SMALL_CALORIE = "SMALL_CALORIE"
    let CALORIES = "CALORIES"
    let DEGREE_CELSIUS = "DEGREE_CELSIUS"
    let DEGREE_FAHRENHEIT = "DEGREE_FAHRENHEIT"
    let KELVIN = "KELVIN"
    let DECIBEL_HEARING_LEVEL = "DECIBEL_HEARING_LEVEL"
    let HERTZ = "HERTZ"
    let SIEMEN = "SIEMEN"
    let VOLT = "VOLT"
    let VOLTS = "VOLTS" // We are sending "VOLTS" as part of our custom implementation for ECG support
    let INTERNATIONAL_UNIT = "INTERNATIONAL_UNIT"
    let COUNT = "COUNT"
    let PERCENT = "PERCENT"
    let PERCENTAGE = "PERCENTAGE"
    let BEATS_PER_MINUTE = "BEATS_PER_MINUTE"
    let RESPIRATIONS_PER_MINUTE = "RESPIRATIONS_PER_MINUTE"
    let MILLIGRAM_PER_DECILITER = "MILLIGRAM_PER_DECILITER"
    let UNKNOWN_UNIT = "UNKNOWN_UNIT"
    let NO_UNIT = "NO_UNIT"
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_health", binaryMessenger: registrar.messenger())
        let instance = SwiftHealthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Set up all data types
        initializeTypes()
        
        /// Handle checkIfHealthDataAvailable
        if call.method.elementsEqual("checkIfHealthDataAvailable") {
            checkIfHealthDataAvailable(call: call, result: result)
        }/// Handle requestAuthorization
        else if call.method.elementsEqual("requestAuthorization") {
            requestAuthorization(call: call, result: result)
        }
        
        /// Handle getData
        else if call.method.elementsEqual("getData") {
            getData(call: call, result: result)
        }
    }
    
    func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(HKHealthStore.isHealthDataAvailable())
    }
    
    func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        let types = (arguments?["types"] as? Array) ?? []
        
        var typesToRequest = Set<HKSampleType>()
        
        for key in types {
            let keyString = "\(key)"
            typesToRequest.insert(dataTypeLookUp(key: keyString))
            
            /*if keyString == "ELECTROCARDIOGRAM" {
             symptomTypesDict.forEach { (key: String, value: HKSampleType) in
             typesToRequest.insert(value)
             }
             }*/
        }
        
        if #available(iOS 11.0, *) {
            healthStore.requestAuthorization(toShare: nil, read: typesToRequest) { (success, error) in
                result(success)
            }
        } else {
            result(false)  // Handle the error here.
        }
    }
    
    func getData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        let dataTypeKey = (arguments?["dataTypeKey"] as? String) ?? "DEFAULT"
        let dataUnitKey = (arguments?["dataUnitKey"] as? String)
        let startDate = (arguments?["startDate"] as? NSNumber) ?? 0
        let endDate = (arguments?["endDate"] as? NSNumber) ?? 0
        let healthStore = HKHealthStore()

        // Convert dates from milliseconds to Date()
        let dateFrom = Date(timeIntervalSince1970: startDate.doubleValue / 1000)
        let dateTo = Date(timeIntervalSince1970: endDate.doubleValue / 1000)

        var dataType = dataTypeLookUp(key: dataTypeKey)
        var unit: HKUnit?
        if let dataUnitKey = dataUnitKey {
            unit = unitDict[dataUnitKey]
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: dateFrom, end: dateTo, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)

        let query = HKSampleQuery(
            sampleType: dataType, predicate: predicate, limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) {
            x, samplesOrNil, error in
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                guard let samplesCategory = samplesOrNil as? [HKCategorySample] else {
                    if #available(iOS 14.0, *) {
                        guard let samplesEcg = samplesOrNil as? [HKElectrocardiogram] else {
                            NSLog("Error getting ECG samples")
                            return
                        }
                        result(
                            samplesEcg.map { sample -> NSDictionary in

                                let voltages = self.getVoltages(sample: sample)
                                let period = 1000 / (sample.samplingFrequency?.doubleValue(for: HKUnit.hertz()))!

                                //let symptoms = self.getAllSymptoms(from: sample)

                                let ecgDictionary: NSMutableDictionary = [
                                    "values": voltages,
                                    "interpretation": sample.classification.rawValue,
                                    "period": period,
                                    //"symptoms": symptoms
                                ]

                                if let averageHeartRate = sample.averageHeartRate?.doubleValue(for: HKUnit.count().unitDivided(by: .minute())) {
                                    ecgDictionary["average_heart_rate"] = averageHeartRate
                                }

                                let sampleDictionary: NSMutableDictionary = [
                                    "uuid": "\(sample.uuid)",
                                    "ecg": ecgDictionary,
                                    "date_from": Int(sample.startDate.timeIntervalSince1970 * 1000),
                                    "date_to": Int(sample.endDate.timeIntervalSince1970 * 1000)
                                ]

                                return sampleDictionary
                            })
                    }
                    return
                }
                return
            }
            result(samples.map { sample -> NSDictionary in
                //let unit = self.unitLookUp(key: dataTypeKey)

                return [
                    "uuid": "\(sample.uuid)",
                    "value": sample.quantity.doubleValue(for: unit!),
                    "date_from": Int(sample.startDate.timeIntervalSince1970 * 1000),
                    "date_to": Int(sample.endDate.timeIntervalSince1970 * 1000),
                    "source_id": sample.sourceRevision.source.bundleIdentifier,
                    "source_name": sample.sourceRevision.source.name
                ]
            })
            return}
        healthStore.execute(query)
    }
    
    @available(iOS 14.0, *)
    func getAllSymptoms(from sample: HKElectrocardiogram) -> [String] {
        
        var presentSymptoms: [String] = []
        
        let symptomsCategoryTypes: [HKCategoryTypeIdentifier] =  [
            .abdominalCramps,
            .acne,
            .appetiteChanges,
            .bladderIncontinence,
            .bloating,
            .breastPain,
            .chestTightnessOrPain,
            .chills,
            .constipation,
            .coughing,
            .diarrhea,
            .dizziness,
            .drySkin,
            .fainting,
            .fatigue,
            .fever,
            .generalizedBodyAche,
            .hairLoss,
            .headache,
            .heartburn,
            .hotFlashes,
            .lossOfSmell,
            .lossOfTaste,
            .lowerBackPain,
            .memoryLapse,
            .moodChanges,
            .nausea,
            .nightSweats,
            .pelvicPain,
            .rapidPoundingOrFlutteringHeartbeat,
            .runnyNose,
            .shortnessOfBreath,
            .sinusCongestion,
            .skippedHeartbeat,
            .sleepChanges,
            .soreThroat,
            .vaginalDryness,
            .vomiting,
            .wheezing,
        ]
        
        let semaphore = DispatchSemaphore(value: 0)
        for i in 0...symptomsCategoryTypes.count-1 {
            checkIfSymptomIsPresent(from: sample, categoryType: symptomsCategoryTypes[i]) {
                (isPresent: Bool) in
                if isPresent{
                    presentSymptoms.append(symptomsCategoryTypes[i].rawValue)
                }
                
                if (i==symptomsCategoryTypes.count-1) {
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return presentSymptoms
    }
    
    @available(iOS 14.0, *)
    func checkIfSymptomIsPresent(from sample: HKElectrocardiogram,
                                 categoryType: HKCategoryTypeIdentifier,
                                 completion: @escaping (Bool)->Void){
        guard sample.symptomsStatus == .present,
              let sampleType = HKSampleType.categoryType(forIdentifier: categoryType) else {
            completion(false)
            return
        }
        let predicate = HKQuery.predicateForObjectsAssociated(electrocardiogram: sample)
        let sampleQuery = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { (query, samples, error) in
                
                if let sample = samples?.first,
                   let categorySample = sample as? HKCategorySample {
                    print("\(sampleType) \(categorySample.sampleType): \(categorySample.value )")
                    completion(true)
                } else {
                    completion(false)
                }
            }
        
        healthStore.execute(sampleQuery)
    }
    
    func getVoltages(sample: HKSample) -> [[String: Double]] {
        let semaphore = DispatchSemaphore(value: 0)
        var results: [[String: Double]] = [[:]]
        
        if #available(iOS 14.0, *) {
            let voltageQuery = HKElectrocardiogramQuery(sample as! HKElectrocardiogram) {
                (query, ecgResult) in
                switch ecgResult {
                case .error(let error):
                    NSLog("\n*** An error occurred \(error.localizedDescription) ***")
                    
                case .measurement(let value):
                    let voltage = [
                        "voltage": value.quantity(for: .appleWatchSimilarToLeadI)!.doubleValue(
                            for: HKUnit.volt()), "timeSinceStart": value.timeSinceSampleStart,
                    ]
                    results.append(voltage)
                    
                case .done:
                    semaphore.signal()
                    NSLog("\nDone")
                }
            }
            self.healthStore.execute(voltageQuery)
        }
        
        semaphore.wait()
        return results
    }
    
    func unitLookUp(key: String) -> HKUnit {
        guard let unit = unitDict[key] else {
            return HKUnit.count()
        }
        return unit
    }
    
    func dataTypeLookUp(key: String) -> HKSampleType {
        guard let dataType_ = dataTypesDict[key] else {
            return HKSampleType.quantityType(forIdentifier: .bodyMass)!
        }
        return dataType_
    }
    
    func initializeTypes() {
        unitDict[ACTIVE_ENERGY_BURNED] = HKUnit.kilocalorie()
        unitDict[BASAL_ENERGY_BURNED] = HKUnit.kilocalorie()
        unitDict[CALORIES] = HKUnit.kilocalorie()
        unitDict[BLOOD_GLUCOSE] = HKUnit.init(from: "mg/dl")
        unitDict[BLOOD_OXYGEN] = HKUnit.percent()
        unitDict[BLOOD_PRESSURE_DIASTOLIC] = HKUnit.millimeterOfMercury()
        unitDict[BLOOD_PRESSURE_SYSTOLIC] = HKUnit.millimeterOfMercury()
        unitDict[BODY_FAT_PERCENTAGE] = HKUnit.percent()
        unitDict[PERCENTAGE] = HKUnit.percent()
        unitDict[BODY_MASS_INDEX] = HKUnit.init(from: "")
        unitDict[BODY_TEMPERATURE] = HKUnit.degreeCelsius()
        unitDict[ELECTRODERMAL_ACTIVITY] = HKUnit.siemen()
        unitDict[SIEMENS] = HKUnit.siemen()
        unitDict[HEART_RATE] = HKUnit.init(from: "count/min")
        unitDict[HEART_RATE_VARIABILITY_SDNN] = HKUnit.secondUnit(with: .milli)
        unitDict[HEIGHT] = HKUnit.meter()
        unitDict[RESTING_HEART_RATE] = HKUnit.init(from: "count/min")
        unitDict[STEPS] = HKUnit.count()
        unitDict[WAIST_CIRCUMFERENCE] = HKUnit.meter()
        unitDict[WALKING_HEART_RATE] = HKUnit.init(from: "count/min")
        unitDict[WEIGHT] = HKUnit.gramUnit(with: .kilo)
        unitDict[DISTANCE_WALKING_RUNNING] = HKUnit.meter()
        unitDict[FLIGHTS_CLIMBED] = HKUnit.count()
        unitDict[WATER] = HKUnit.liter()
        unitDict[MINDFULNESS] = HKUnit.init(from: "")
        unitDict[SLEEP_IN_BED] = HKUnit.init(from: "")
        unitDict[SLEEP_ASLEEP] = HKUnit.init(from: "")
        unitDict[SLEEP_AWAKE] = HKUnit.init(from: "")
        unitDict[GRAM] = HKUnit.gram()
        unitDict[KILOGRAM] = HKUnit.gramUnit(with: .kilo)
        unitDict[KILOGRAMS] = HKUnit.gramUnit(with: .kilo)
        unitDict[OUNCE] = HKUnit.ounce()
        unitDict[POUND] = HKUnit.pound()
        unitDict[STONE] = HKUnit.stone()
        unitDict[METER] = HKUnit.meter()
        unitDict[METERS] = HKUnit.meter()
        unitDict[INCH] = HKUnit.inch()
        unitDict[FOOT] = HKUnit.foot()
        unitDict[YARD] = HKUnit.yard()
        unitDict[MILE] = HKUnit.mile()
        unitDict[LITER] = HKUnit.liter()
        unitDict[MILLILITER] = HKUnit.literUnit(with: .milli)
        unitDict[FLUID_OUNCE_US] = HKUnit.fluidOunceUS()
        unitDict[FLUID_OUNCE_IMPERIAL] = HKUnit.fluidOunceImperial()
        unitDict[CUP_US] = HKUnit.cupUS()
        unitDict[CUP_IMPERIAL] = HKUnit.cupImperial()
        unitDict[PINT_US] = HKUnit.pintUS()
        unitDict[PINT_IMPERIAL] = HKUnit.pintImperial()
        unitDict[PASCAL] = HKUnit.pascal()
        unitDict[MILLIMETER_OF_MERCURY] = HKUnit.millimeterOfMercury()
        unitDict[CENTIMETER_OF_WATER] = HKUnit.centimeterOfWater()
        unitDict[ATMOSPHERE] = HKUnit.atmosphere()
        unitDict[DECIBEL_A_WEIGHTED_SOUND_PRESSURE_LEVEL] = HKUnit.decibelAWeightedSoundPressureLevel()
        unitDict[SECOND] = HKUnit.second()
        unitDict[MILLISECOND] = HKUnit.secondUnit(with: .milli)
        unitDict[MILLISECONDS] = HKUnit.secondUnit(with: .milli)
        unitDict[MINUTE] = HKUnit.minute()
        unitDict[MINUTES] = HKUnit.minute()
        unitDict[HOUR] = HKUnit.hour()
        unitDict[DAY] = HKUnit.day()
        unitDict[JOULE] = HKUnit.joule()
        unitDict[KILOCALORIE] = HKUnit.kilocalorie()
        unitDict[LARGE_CALORIE] = HKUnit.largeCalorie()
        unitDict[SMALL_CALORIE] = HKUnit.smallCalorie()
        unitDict[DEGREE_CELSIUS] = HKUnit.degreeCelsius()
        unitDict[DEGREE_FAHRENHEIT] = HKUnit.degreeFahrenheit()
        unitDict[KELVIN] = HKUnit.kelvin()
        unitDict[DECIBEL_HEARING_LEVEL] = HKUnit.decibelHearingLevel()
        unitDict[HERTZ] = HKUnit.hertz()
        unitDict[SIEMEN] = HKUnit.siemen()
        unitDict[INTERNATIONAL_UNIT] = HKUnit.internationalUnit()
        unitDict[COUNT] = HKUnit.count()
        unitDict[PERCENT] = HKUnit.percent()
        unitDict[BEATS_PER_MINUTE] = HKUnit.init(from: "count/min")
        unitDict[RESPIRATIONS_PER_MINUTE] = HKUnit.init(from: "count/min")
        unitDict[MILLIGRAM_PER_DECILITER] = HKUnit.init(from: "mg/dL")
        unitDict[UNKNOWN_UNIT] = HKUnit.init(from: "")
        unitDict[NO_UNIT] = HKUnit.init(from: "")
        if #available(iOS 14.4, *) {
            unitDict[ELECTROCARDIOGRAM] = HKUnit.volt()
            unitDict[VOLT] = HKUnit.volt()
            unitDict[VOLTS] = HKUnit.volt()
            unitDict[INCHES_OF_MERCURY] = HKUnit.inchesOfMercury()
        }
        
        // Set up iOS 11 specific types (ordinary health data types)
        if #available(iOS 11.0, *) {
            dataTypesDict[ACTIVE_ENERGY_BURNED] = HKSampleType.quantityType(
                forIdentifier: .activeEnergyBurned)!
            dataTypesDict[BASAL_ENERGY_BURNED] = HKSampleType.quantityType(
                forIdentifier: .basalEnergyBurned)!
            dataTypesDict[BLOOD_GLUCOSE] = HKSampleType.quantityType(forIdentifier: .bloodGlucose)!
            dataTypesDict[BLOOD_OXYGEN] = HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!
            dataTypesDict[BLOOD_PRESSURE_DIASTOLIC] = HKSampleType.quantityType(
                forIdentifier: .bloodPressureDiastolic)!
            dataTypesDict[BLOOD_PRESSURE_SYSTOLIC] = HKSampleType.quantityType(
                forIdentifier: .bloodPressureSystolic)!
            dataTypesDict[BODY_FAT_PERCENTAGE] = HKSampleType.quantityType(
                forIdentifier: .bodyFatPercentage)!
            dataTypesDict[BODY_MASS_INDEX] = HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!
            dataTypesDict[BODY_TEMPERATURE] = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
            dataTypesDict[ELECTRODERMAL_ACTIVITY] = HKSampleType.quantityType(
                forIdentifier: .electrodermalActivity)!
            dataTypesDict[HEART_RATE] = HKSampleType.quantityType(forIdentifier: .heartRate)!
            dataTypesDict[HEART_RATE_VARIABILITY_SDNN] = HKSampleType.quantityType(
                forIdentifier: .heartRateVariabilitySDNN)!
            dataTypesDict[HEIGHT] = HKSampleType.quantityType(forIdentifier: .height)!
            dataTypesDict[RESTING_HEART_RATE] = HKSampleType.quantityType(
                forIdentifier: .restingHeartRate)!
            dataTypesDict[STEPS] = HKSampleType.quantityType(forIdentifier: .stepCount)!
            dataTypesDict[WAIST_CIRCUMFERENCE] = HKSampleType.quantityType(
                forIdentifier: .waistCircumference)!
            dataTypesDict[WALKING_HEART_RATE] = HKSampleType.quantityType(
                forIdentifier: .walkingHeartRateAverage)!
            dataTypesDict[WEIGHT] = HKSampleType.quantityType(forIdentifier: .bodyMass)!
            dataTypesDict[DISTANCE_WALKING_RUNNING] = HKSampleType.quantityType(
                forIdentifier: .distanceWalkingRunning)!
            dataTypesDict[FLIGHTS_CLIMBED] = HKSampleType.quantityType(forIdentifier: .flightsClimbed)!
            dataTypesDict[WATER] = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
            dataTypesDict[MINDFULNESS] = HKSampleType.categoryType(forIdentifier: .mindfulSession)!
            dataTypesDict[SLEEP_IN_BED] = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!
            dataTypesDict[SLEEP_ASLEEP] = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!
            dataTypesDict[SLEEP_AWAKE] = HKSampleType.categoryType(forIdentifier: .sleepAnalysis)!
            
            healthDataTypes = Array(dataTypesDict.values)
        }
        // Set up heart rate data types specific to the apple watch, requires iOS 12
        if #available(iOS 12.2, *) {
            dataTypesDict[HIGH_HEART_RATE_EVENT] = HKSampleType.categoryType(
                forIdentifier: .highHeartRateEvent)!
            dataTypesDict[LOW_HEART_RATE_EVENT] = HKSampleType.categoryType(
                forIdentifier: .lowHeartRateEvent)!
            dataTypesDict[IRREGULAR_HEART_RATE_EVENT] = HKSampleType.categoryType(
                forIdentifier: .irregularHeartRhythmEvent)!
            
            heartRateEventTypes = Set([
                HKSampleType.categoryType(forIdentifier: .highHeartRateEvent)!,
                HKSampleType.categoryType(forIdentifier: .lowHeartRateEvent)!,
                HKSampleType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
            ])
        }
        
        if #available(iOS 14.0, *) {
            dataTypesDict[ELECTROCARDIOGRAM] = HKObjectType.electrocardiogramType()
            
            
            // SYMPTOMS
            symptomTypesDict[ABDOMINAL_CRAMPS] = HKSampleType.categoryType(forIdentifier: .abdominalCramps)!
            symptomTypesDict[ACNE] = HKSampleType.categoryType(forIdentifier: .acne)!
            symptomTypesDict[APPETITE_CHANGES] = HKSampleType.categoryType(forIdentifier: .appetiteChanges)!
            symptomTypesDict[BLADDER_INCONTINENCE] = HKSampleType.categoryType(forIdentifier: .bladderIncontinence)!
            symptomTypesDict[BLOATING] = HKSampleType.categoryType(forIdentifier: .bloating)!
            symptomTypesDict[BREAST_PAIN] = HKSampleType.categoryType(forIdentifier: .breastPain)!
            symptomTypesDict[CHEST_TIGHTNESS_OR_PAIN] = HKSampleType.categoryType(forIdentifier: .chestTightnessOrPain)!
            symptomTypesDict[CHILLS] = HKSampleType.categoryType(forIdentifier: .chills)!
            symptomTypesDict[CONSTIPATION] = HKSampleType.categoryType(forIdentifier: .constipation)!
            symptomTypesDict[COUGHING] = HKSampleType.categoryType(forIdentifier: .coughing)!
            symptomTypesDict[DIARRHEA] = HKSampleType.categoryType(forIdentifier: .diarrhea)!
            symptomTypesDict[DIZZINESS] = HKSampleType.categoryType(forIdentifier: .dizziness)!
            symptomTypesDict[DRY_SKIN] = HKSampleType.categoryType(forIdentifier: .drySkin)!
            symptomTypesDict[FAINTING] = HKSampleType.categoryType(forIdentifier: .fainting)!
            symptomTypesDict[FATIGUE] = HKSampleType.categoryType(forIdentifier: .fatigue)!
            symptomTypesDict[FEVER] = HKSampleType.categoryType(forIdentifier: .fever)!
            symptomTypesDict[GENERALIZED_BODY_ACHE] = HKSampleType.categoryType(forIdentifier: .generalizedBodyAche)!
            symptomTypesDict[HAIR_LOSS] = HKSampleType.categoryType(forIdentifier: .hairLoss)!
            symptomTypesDict[HEADACHE] = HKSampleType.categoryType(forIdentifier: .headache)!
            symptomTypesDict[HEARTBURN] = HKSampleType.categoryType(forIdentifier: .heartburn)!
            symptomTypesDict[HOT_FLASHES] = HKSampleType.categoryType(forIdentifier: .hotFlashes)!
            symptomTypesDict[LOSS_OF_SMELL] = HKSampleType.categoryType(forIdentifier: .lossOfSmell)!
            symptomTypesDict[LOSS_OF_TASTE] = HKSampleType.categoryType(forIdentifier: .lossOfTaste)!
            symptomTypesDict[LOWER_BACK_PAIN] = HKSampleType.categoryType(forIdentifier: .lowerBackPain)!
            symptomTypesDict[MEMORY_LAPSE] = HKSampleType.categoryType(forIdentifier: .moodChanges)!
            symptomTypesDict[MOOD_CHANGES] = HKSampleType.categoryType(forIdentifier: .moodChanges)!
            symptomTypesDict[NAUSEA] = HKSampleType.categoryType(forIdentifier: .nausea)!
            symptomTypesDict[NIGHT_SWEATS] = HKSampleType.categoryType(forIdentifier: .nightSweats)!
            symptomTypesDict[PELVIC_PAIN] = HKSampleType.categoryType(forIdentifier: .pelvicPain)!
            symptomTypesDict[RAPID_POUNDING_OR_FLUTTERING_HEARTBEAT] = HKSampleType.categoryType(forIdentifier: .rapidPoundingOrFlutteringHeartbeat)!
            symptomTypesDict[RUNNY_NOSE] = HKSampleType.categoryType(forIdentifier: .runnyNose)!
            symptomTypesDict[SHORTNESS_OF_BREATH] = HKSampleType.categoryType(forIdentifier: .shortnessOfBreath)!
            symptomTypesDict[SINUS_CONGESTION] = HKSampleType.categoryType(forIdentifier: .sinusCongestion)!
            symptomTypesDict[SKIPPED_HEARTBEAT] = HKSampleType.categoryType(forIdentifier: .skippedHeartbeat)!
            symptomTypesDict[SLEEP_CHANGES] = HKSampleType.categoryType(forIdentifier: .sleepChanges)!
            symptomTypesDict[SORE_THROAT] = HKSampleType.categoryType(forIdentifier: .soreThroat)!
            symptomTypesDict[VAGINAL_DRYNESS] = HKSampleType.categoryType(forIdentifier: .vaginalDryness)!
            symptomTypesDict[VOMITING] = HKSampleType.categoryType(forIdentifier: .vomiting)!
            symptomTypesDict[WHEEZING] = HKSampleType.categoryType(forIdentifier: .wheezing)!
            
            ecgTypes = Set([HKObjectType.electrocardiogramType()])
        }
        
        // Concatenate heart events and health data types (both may be empty)
        allDataTypes = Set(heartRateEventTypes + healthDataTypes + ecgTypes)
    }
}
