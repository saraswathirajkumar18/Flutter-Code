import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  goNext(context)
  {
Navigator.push(
  context,
  MaterialPageRoute(builder: (context)=>NewPage(city:_controller.text)),
);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body:Container(
        decoration:BoxDecoration(
          image:DecorationImage(
            image:AssetImage('assets/images/sky.jpg'),
             fit: BoxFit.cover,

          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                padding: const EdgeInsets.only(bottom:20.0),
                child: Column(
                  children: [
                     Image.asset(
                  'assets/images/rain.png', // Path to your logo image
                  width: 70,         // Width of the logo
                  height: 70,        // Height of the logo
                ),
                    Padding(padding:EdgeInsets.all(20.0)),
                    Text(
                      'Weather App',
                       style: TextStyle(
                      color:Colors.white,
                      fontSize: 42,
                      fontFamily: 'Roboto', // Specify the font family
                      fontWeight: FontWeight.bold, // Optional: Use bold if applicable
                      
                    ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0.0),
                child: Row(
                  
                  children:[ 
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                        controller:_controller,
                        decoration: InputDecoration(
                          border:OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: 'Enter Location',
                         focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Color when focused
                ), 
                        enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Color when enabled
                ),
                        ),
                                         
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily:'Roboto',
                        
                        
                        ),
                                             ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: IconButton(
                      onPressed:()=>goNext(context),
                    icon:Icon(Icons.search),
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),   
    );
  }
}
class NewPage extends StatefulWidget {
 final String city;
 NewPage(
  {
    required this.city
  }
  );

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
 final String apiKey='71a2cf78c5d70c6b9e691725e41be3f3';
 double? latitude;
 double? longitude;
 List<String> weatherInfo = [];
 @override
 void initState()
 {
super.initState();
fetchData(widget.city).then((_) {
      setState(() {}); // Update UI
    });
 }
 Future<void> fetchData(String location) async
 {
final geoUrl='https://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=$apiKey';
print("url is $geoUrl ");
try{
final geoResponse=await http.get(Uri.parse(geoUrl));
final geobody=geoResponse.body;

final json;
if (geoResponse.statusCode == 200) {
json=jsonDecode(geobody);
if (json.isNotEmpty) {
latitude=json[0]['lat'];
longitude=json[0]['lon'];
print("latitude is $latitude and lontitude is $longitude");
}
else{
   print('No data found for the specified location.');
// Return null if no data is found
}
}
 else{
  print('Failed to load data: ${geoResponse.statusCode}');
 }
}
catch (e) {
    print('Error: $e');
    
  }
  //! confirm that lat and long are not null because lat and lon are required
  fetchWeatherDetails(latitude!, longitude!);
 }
Future<void> fetchWeatherDetails(double lat, double lon) async {
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'; // Use &units=imperial for Fahrenheit,metrics for celsius
    final weatherResponse = await http.get(Uri.parse(weatherUrl));
    if (weatherResponse.statusCode == 200) {
      final weatherJson = jsonDecode(weatherResponse.body);
      setState(() {
       weatherInfo.clear(); // Clear previous data
        
          // Add weather information to the list
           //weatherInfo.add('Location: ${item['name']}');
         weatherInfo.add('Temperature: ${weatherJson['main']['temp']} °C');
            weatherInfo.add('Humidity: ${weatherJson['main']['humidity']} %');
            weatherInfo.add('Condition: ${weatherJson['weather'][0]['description']}');
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title:Text('Weather API Result',style:TextStyle(fontSize:23,color:Colors.white),),
        backgroundColor:Color.fromARGB(255, 30, 133, 174),
        //const Color.fromARGB(255, 39, 137, 197),
      ),
     //mainAxisAlignment:MainAxisAlignment.center,
    body:
    Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Container(
       
        child: Center(
          child: ListView.builder(
            itemCount: weatherInfo.length,
            itemBuilder: (context, index) {
              return Card(
               color: Color.fromARGB(255, 240, 112, 52),
                margin:EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(weatherInfo[index],
                    style:TextStyle(fontSize:18,color:Colors.white),
                    ),
                  ),
                  //leading: Icon(Icons.wb_sunny),
                ),
              );
            },
          ),
        ),
      ),
    ),
    
    );
  }
}