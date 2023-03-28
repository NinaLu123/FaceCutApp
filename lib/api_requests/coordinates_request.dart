/*
 * Written at HashTag Labs Pvt Ltd. (abhishar@hashtaglabs.biz/+919810723836)
 * Project lead by Abhishek and Ashwani
 */

import 'dart:convert';
import 'package:backgroundremove/Model/PeopleCoordinates.dart';
import 'package:backgroundremove/Model/Record.dart';
import 'package:http/http.dart' as http;

import '../app_constants.dart';

Future<int?> coordinatesRequest(List<Record> peoples) async {

  // Change API Url in app_constants class
final client = new http.Client();
var arr = [];
    for(var i = 0; i < peoples.length; i++){

int? idToPrint;
//var personJson = jsonEncode(peoples[i]);
var personJson = {
  "Gender":peoples[i].gender,
  "Age":peoples[i].profile
}; 

try {
    
  String urlPost = AppConstants.apiURLPersonPost;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization" : "Bearer e5dbc4f40da5b04ba1ca5f423bd9574f"
  };
    var personResponse = await client.post(Uri.parse(urlPost), headers: headers, body: jsonEncode(personJson));

    print(personResponse.body);
    if (personResponse.statusCode >= 200) {
      //responseJson = json.decode(response.body) as Map<String, dynamic>;
      Map data = jsonDecode(personResponse.body);
      var id = data['id'];
      arr.add(id);

    } else {
      throw Exception('Failed to load data from API');
    }
  } catch (e) {
    throw Exception('Failed to load data from API');
  }
        
  var jsonTest = 
  {
	  "Company": "1672697574442x894686264458031200",
	  "ImageType":"1",
	  "User": "1672346507862x344053156333508740",
    "people": arr
};
  String url = AppConstants.apiURL;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization" : "Bearer e5dbc4f40da5b04ba1ca5f423bd9574f"
  };

  try {
    final response = await client.post(Uri.parse(url), headers: headers, body: jsonEncode(jsonTest));

    Map<String, dynamic> responseJson = {};
    if (response.statusCode >= 200) {
      Map data = jsonDecode(response.body);

      // Get the id 
      try {
        var urlGetDrawing = Uri.parse(url + "/" + data["id"]);
        final getDrawingResponse = await client.get(urlGetDrawing, headers: headers);

            if (getDrawingResponse.statusCode >= 200) {
                Map data = jsonDecode(getDrawingResponse.body);
                
                idToPrint = data["response"]["Id"];
            }
      }
      catch(e){
        throw Exception(e);
      }
    } else {
      throw Exception('Failed to load data from API');
    }
  } catch (e) {
    throw Exception(e);
     }

     return idToPrint;
}

List<PeopleCoordinate> getData(List<Record> people) {
  List<PeopleCoordinate> list = [];
  for(int i = 0 ; i < people.length ; i++){
    list.add(PeopleCoordinate(gender: people[i].gender, age: people[i].profile, x: 100*(i+1), y: 100*(i+1)));
  }
  return list;
}}