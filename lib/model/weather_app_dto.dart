import 'package:weather_app/model/clouds_dto.dart';
import 'package:weather_app/model/coord_dto.dart';
import 'package:weather_app/model/main_dto.dart';
import 'package:weather_app/model/sys_dto.dart';
import 'package:weather_app/model/weather_dto.dart';
import 'package:weather_app/model/wind.dart';

class WeatherDTO {
  final Coord? coord;
  final List<Weather>? weather;
  final String? base;
  final Main? main;
  final int? visibility;
  final Wind? wind;
  final Clouds? clouds;
  final int? dt;
  final Sys? sys;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  WeatherDTO(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod});

  factory WeatherDTO.fromJson(Map<String, dynamic> json) {
    List<Weather> weatherValue = <Weather>[];
    if (json['weather'] != null) {
      weatherValue = <Weather>[];
      json['weather'].forEach((v) {
        weatherValue.add(new Weather.fromJson(v));
      });
    }
    return WeatherDTO(
      coord: json['coord'] != null ? new Coord.fromJson(json['coord']) : null,
      weather: weatherValue,
      base: json['base'],
      main: json['main'] != null ? new Main.fromJson(json['main']) : null,
      visibility: json['visibility'],
      wind: json['wind'] != null ? new Wind.fromJson(json['wind']) : null,
      clouds:
          json['clouds'] != null ? new Clouds.fromJson(json['clouds']) : null,
      dt: json['dt'],
      sys: json['sys'] != null ? new Sys.fromJson(json['sys']) : null,
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coord != null) {
      data['coord'] = this.coord!.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    data['base'] = this.base;
    if (this.main != null) {
      data['main'] = this.main!.toJson();
    }
    data['visibility'] = this.visibility;
    if (this.wind != null) {
      data['wind'] = this.wind!.toJson();
    }
    if (this.clouds != null) {
      data['clouds'] = this.clouds!.toJson();
    }
    data['dt'] = this.dt;
    if (this.sys != null) {
      data['sys'] = this.sys!.toJson();
    }
    data['timezone'] = this.timezone;
    data['id'] = this.id;
    data['name'] = this.name;
    data['cod'] = this.cod;
    return data;
  }
}
