import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/model/weather_app_dto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Future<WeatherDTO>? _weatherDTO;

  Future<WeatherDTO> getData() async{
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=36.11345866990727&lon=127.49390955017667&appid=9c43f7e9fc11b65aba72ea77888d1765');
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    WeatherDTO weatherDTO = WeatherDTO.fromJson(json.decode(response.body));
    return weatherDTO;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _weatherDTO = getData();
  }

  _refresh(){
    setState(() {
      _weatherDTO = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var dateFormat = 'yyyy년 MM월 dd일';
    var timeFormat = 'HH시 mm분';
    String date = DateFormat(dateFormat).format(now);
    String time = DateFormat(timeFormat).format(now);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('오늘의 날씨', style: TextStyle(color: Colors.black),),
        ),
        body: FutureBuilder<WeatherDTO>(
          future: _weatherDTO,
          builder: (context, snapshot){
            if(snapshot.hasData){
              var celsius = (snapshot.data!.main!.temp! - 32)*0.055;
              var celsiusFeelsLike = (snapshot.data!.main!.feelsLike! - 32)*0.055;
              var celsiusTempMin = (snapshot.data!.main!.tempMin! - 32)*0.055;
              var celsiusTempMax = (snapshot.data!.main!.tempMax! - 32)*0.055;

              var weatherIcon = snapshot.data!.weather![0].icon;

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(date, style: const TextStyle(fontSize: 28),),
                    const SizedBox(height: 8,),
                    Text(time, style: const TextStyle(fontSize: 28),),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                FaIcon(FontAwesomeIcons.locationDot, size: 18),
                                Padding(padding: EdgeInsets.all(3)),
                                Text('금산읍', style: TextStyle(fontSize: 15),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${celsius.floor()}°', style: TextStyle(fontSize: 30),),
                                Padding(padding: EdgeInsets.all(5)),
                                Text('체감 ${celsiusFeelsLike.floor()}°', style: TextStyle(fontSize: 15),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Text('${celsiusTempMax.floor()}° / ${celsiusTempMin.floor()}°', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        const SizedBox(width: 50,),
                        Image.network('https://openweathermap.org/img/wn/$weatherIcon@2x.png'),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const FaIcon(FontAwesomeIcons.droplet),
                            const SizedBox(height: 5,),
                            const Text('습도'),
                            const SizedBox(height: 5,),
                            Text('${snapshot.data!.main!.humidity} %'),
                          ],
                        ),
                        Column(
                          children: [
                            const FaIcon(FontAwesomeIcons.wind),
                            const SizedBox(height: 5,),
                            const Text('바람'),
                            const SizedBox(height: 5,),
                            Text('${snapshot.data!.wind!.speed} m/s'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _refresh,
          child: const Icon(Icons.refresh),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
