import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
}

class _MyAppState extends State<MyApp> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    DateTime startDate = DateTime(2020, 11, 07, 0, 0, 0);
    DateTime endDate = DateTime(2025, 11, 07, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      if(Platform.isAndroid)
        HealthDataType.DISTANCE_DELTA,
      if(Platform.isIOS)
        HealthDataType.DISTANCE_WALKING_RUNNING,
      if(Platform.isIOS)
        HealthDataType.ELECTROCARDIOGRAM,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        steps += x.value?.round() ?? 0;
      });

      print("Steps: $steps");

      /// Update the UI to display the results
      setState(() {
        _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          final List<ECGValue>? ecgValues = p.ecgData?.values;
          return Column(
            children: [
              ListTile(
                title: Text("${p.typeString}: ${p.value ?? '${p.ecgData?.values?.length} entries'}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                trailing: Text('${p.unitString}', style: TextStyle(fontSize: 8),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text('From:',style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${p.dateFrom}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('To:',style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${p.dateTo}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (ecgValues != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text("Period:", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("${p.ecgData?.period}"),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Interpretation: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("${p.ecgData?.interpretation}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Average Heart Rate: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("${p.ecgData?.averageHearthRate}"),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if (p.ecgData?.symptoms != null)
                            Text(
                              "${p.ecgData?.symptoms?.length} Symptoms:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ...?p.ecgData?.symptoms?.map((e) => Text("$e")).toList(),
                          SizedBox(height: 10,),
                        ],
                      ),
                    if (ecgValues != null)
                      ...ecgValues.reversed.take(5).map((entry) {
                        return Text(
                          "voltage: ${entry.voltage ?? ''} ",
                          style: TextStyle(color: Colors.lightBlue),
                        );
                      }),
                  ],
                ),
              ),
              Divider(color: Colors.black,)
            ],
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text('Press the download button to fetch data');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED) return _authorizationNotGranted();

    return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  fetchData();
                },
              )
            ],
          ),
          body: Center(
            child: _content(),
          )),
    );
  }
}
