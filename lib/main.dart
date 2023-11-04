// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:t_shirt/widget/textwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T Shirt Size',
      theme: ThemeData(
        fontFamily: 'WorkSans',
        primarySwatch: Colors.blue,
      ),
      home: TShirtSizePredictorScreen(),
    );
  }
}

class TShirtSizePredictorScreen extends StatefulWidget {
  @override
  _TShirtSizePredictorScreenState createState() =>
      _TShirtSizePredictorScreenState();
}

class _TShirtSizePredictorScreenState extends State<TShirtSizePredictorScreen> {
  List<String> nearestLabels = [];
  List<DataWithDistance> datawithdistances = [];
  List<DataPoint> data = [
    DataPoint(158, 58, 'M'),
    DataPoint(158, 59, 'M'),
    DataPoint(158, 63, 'M'),
    DataPoint(160, 59, 'M'),
    DataPoint(160, 60, 'M'),
    DataPoint(163, 60, 'M'),
    DataPoint(163, 61, 'M'),
    DataPoint(160, 64, 'L'),
    DataPoint(163, 64, 'L'),
    DataPoint(165, 61, 'L'),
    DataPoint(165, 62, 'L'),
    DataPoint(165, 65, 'L'),
    DataPoint(168, 62, 'L'),
    DataPoint(168, 63, 'L'),
    DataPoint(168, 66, 'L'),
    DataPoint(170, 63, 'L'),
    DataPoint(170, 64, 'L'),
    DataPoint(170, 68, 'L'),
  ];

// 552.727294921875
// 1591.6883544921875

  double euclideanDistance(DataPoint p1, DataPoint p2) {
    double diffHeight = p1.height - p2.height;
    double diffWeight = p1.weight - p2.weight;
    return sqrt(diffHeight * diffHeight + diffWeight * diffWeight);
  }

  String predictTShirtSize(double height, double weight, int k) {
    List<DistanceLabelPair> distances = [];

    DataPoint target = DataPoint(height, weight, '');

    for (DataPoint point in data) {
      double distance = euclideanDistance(target, point);
      distances.add(DistanceLabelPair(distance, point.size));
      datawithdistances.add(
          DataWithDistance(point.height, point.weight, distance, point.size));
    }

    distances.sort((a, b) => a.distance.compareTo(b.distance));
    datawithdistances.sort((a, b) => a.distance.compareTo(b.distance));

    // List<String> nearestLabels = [];

    for (int i = 0; i < k; i++) {
      nearestLabels.add(distances[i].label);
    }
    for (String label in nearestLabels) {
      print('Nearest Label:$nearestLabels[i] = $label');
    }
    String tshirtsize;
    tshirtsize = mostCommon(nearestLabels);
    print('Selected  :  ${tshirtsize}');
    return tshirtsize;
  }

  String mostCommon(List<String> list) {
    return list
        .fold<Map<String, int>>({}, (map, element) {
          map[element] = map.containsKey(element) ? map[element]! + 1 : 1;
          return map;
        })
        .entries
        .reduce((prev, curr) => curr.value > prev.value ? curr : prev)
        .key;
  }

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController kvalueController = TextEditingController();
  String predictedSize = '';

  bool pred = false;
  void predictTShirtSizeHandler() {
    double height = double.tryParse(heightController.text) ?? 161.0;
    double weight = double.tryParse(weightController.text) ?? 61.0;
    int k = int.tryParse(kvalueController.text) ?? 3;
    nearestLabels.clear();
    datawithdistances.clear();
    if (height > 200 || height < 50 || weight > 200 || weight < 20) {
      predictedSize = "Invalid";
    } else {
      predictedSize = predictTShirtSize(height, weight, k);
    }
    setState(() {
      pred = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    print(heightScreen);

    print(width);
    return Scaffold(
      appBar: AppBar(title: Text('KNN T-Shirt Size')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          height: heightScreen,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: width > 700 ? width / 2 : width * 0.93,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Expanded(
                        child: Column(children: [
                          TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: kvalueController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Value of K',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ]),
                      )),
                  if (width > 700)
                    Container(
                        width: width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: Colors.white),
                        child: Center(
                            child: Text(
                          'Predicted Size: $predictedSize',
                          style: TextStyle(
                              fontSize: width / 30, color: Colors.black),
                        ))),
                ],
              ),
              Center(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  width: width / 2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                      onTap: predictTShirtSizeHandler,
                      child: Center(
                        child: Text(
                          "Predict",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (width <= 700)
                Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    width: width / 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: Center(
                        child: Text(
                      'Predicted Size: $predictedSize',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 33, color: Colors.black),
                    ))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextWidget(
                    text: "Ranking ",
                    size: 16,
                  ),
                  TextWidget(
                    text: "Height ",
                    size: 16,
                  ),
                  TextWidget(
                    text: "Weight ",
                    size: 16,
                  ),
                  TextWidget(
                    text: "Distance ",
                    size: 16,
                  ),
                  TextWidget(
                    text: "Size ",
                    size: 16,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              if (pred)
                Expanded(
                    child: ListView.builder(
                        itemCount: nearestLabels.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 5, top: 5, bottom: 5),
                                  child: Row(
                                    //        crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "     ${index + 1}",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${datawithdistances[index].height} ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${datawithdistances[index].weight} ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        "${datawithdistances[index].distance.toStringAsFixed(2)} ",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      TextWidget(
                                        text:
                                            "${datawithdistances[index].size} ",
                                        size: 14,
                                      ),
                                    ],
                                  )),
                              Divider(
                                color: Colors.grey,
                                height: 1,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                              ),
                            ],
                          );
                        })),
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  double height;
  double weight;
  String size;

  DataPoint(this.height, this.weight, this.size);
}

class DistanceLabelPair {
  double distance;
  String label;
  DistanceLabelPair(this.distance, this.label);
}

class DataWithDistance {
  double height;
  double weight;
  double distance;
  String size;
  DataWithDistance(this.height, this.weight, this.distance, this.size);
}
