import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/model/weather_app_dto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_dto.dart';

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
          title: Text('오늘의 날씨', style: TextStyle(color: Colors.black),),
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

              FaIcon icon() {
                var weatherName = snapshot.data!.weather![0].main;
                print(snapshot.data!.weather![0].main);
                if(weatherName == 'Clouds'){
                  return FaIcon(FontAwesomeIcons.cloud, size: 50,);
                } else if(weatherName == 'Rain'){
                  return FaIcon(FontAwesomeIcons.cloudRain, size: 50,);
                }
                return FaIcon(FontAwesomeIcons.sun, size: 50,);
              }

              return Container(
                padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(date, style: TextStyle(fontSize: 28),),
                    SizedBox(height: 8,),
                    Text(time, style: TextStyle(fontSize: 28),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.locationDot, size: 18),
                                Padding(padding: EdgeInsets.all(3)),
                                Text('금산읍', style: TextStyle(fontSize: 15),)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${celsius.floor()}°', style: TextStyle(fontSize: 30),),
                                Padding(padding: EdgeInsets.all(5)),
                                Text('체감 ${celsiusFeelsLike.floor()}°', style: TextStyle(fontSize: 15),)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('${celsiusTempMax.floor()}° / ${celsiusTempMin.floor()}°', style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        SizedBox(width: 50,),
                        // icon(),
                        Image.network('https://openweathermap.org/img/wn/$weatherIcon@2x.png'),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            FaIcon(FontAwesomeIcons.droplet),
                            SizedBox(height: 5,),
                            Text('습도'),
                            SizedBox(height: 5,),
                            Text('${snapshot.data!.main!.humidity} %'),
                          ],
                        ),
                        Column(
                          children: [
                            FaIcon(FontAwesomeIcons.wind),
                            SizedBox(height: 5,),
                            Text('바람'),
                            SizedBox(height: 5,),
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
      ),
    );
  }
}
