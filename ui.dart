import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:astrologyapi/model/astro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ui extends StatefulWidget {
    @override
    _uiState createState() => _uiState();
}



class _uiState extends State<ui> {

    DateTime now = DateTime.utc(2021, 3, 16);
    var formatter = new DateFormat('yyyy-MM-dd');
    austro astro_model_obj;

    Future<austro>loadui(DateTime d)async {
    //intl package used to format date
        String formattedDate = formatter.format(d);
        print(formattedDate);
        var res = await http.get(Uri.encodeFull("https://api.nasa.gov/planetary/apod?api_key=aWPhODExHc5j48m59viPzCysv1jkoaN7ID2dchPw&date="+formattedDate), headers: {"Accept": "application/json"});
        print(res.body);
        if (res.statusCode == 200) {
              print("------success---------");
              var data = json.decode(res.body);
              print(data);
              astro_model_obj = austro.fromJson(data);

              setState(() {
                    title=astro_model_obj.title;
                    explanation=astro_model_obj.explanation;
                    dates=astro_model_obj.date;
                    image=astro_model_obj.hdurl;
              });
              print("------------");
        }
        else {
        }
        return astro_model_obj;
    }

    String title;
    String explanation;
    String dates;
    String image;


    Future<void> _selectDate(BuildContext context) async {
        final DateTime picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
            if (picked != null && picked != now)
                setState(() {
                    now = picked;
                });
    }
    Future<austro>obj_astro;
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      obj_astro=loadui(now);
    }
    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future:obj_astro ,
            builder: (context,snapshot){
                if(snapshot.hasData){
                    return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          title: Center(
                            child: Text(
                                    "Astrology Pic Of The Day",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    ),
                          )
                        ),
                        body: SingleChildScrollView(
                          child: Container(
                                padding: EdgeInsets.all(12),
                                    child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                  SizedBox(height: 60,),
                                                  Container(
                                                      padding: EdgeInsets.only(left: 20,right: 20),
                                                      width: double.infinity,
                                                      child: Center(child: Text(title,
                                                              textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 20,fontWeight: FontWeight.w500,
                                                                        color: Colors.black87
                                                                    ),)),
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets.only(left: 20,right: 20),
                                                      width: double.infinity,
                                                      child:Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                              Text(dates,textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 12,fontWeight: FontWeight.w300,
                                                                      color: Colors.red
                                                                  ))
                                                            ],
                                    )),
          
                                                  Container(
                                                    height: 200,
                                                    margin: EdgeInsets.only(top: 10),
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: Image.network(image),
                                                    ),
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets.only(left: 20,right: 20),
                                                      margin: EdgeInsets.only(top: 10),
                                                      width: double.infinity,
                                                      child: Center(child: Text(explanation,
                                                          textAlign: TextAlign.justify,
                                                          style: TextStyle(
                                                              height: 1.6,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.black87
                                                          ),)),
                                                  ),
                                                  GestureDetector(
                                                      onTap: (){
                                                          _selectDate(context).then((value) => loadui(now));
                                                      },
                                                    child: Container(
                                                        height: 60,
                                                        margin: EdgeInsets.only(top: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(20),
                                                            ),
                                                            color: Colors.black
                                                        ),
                                                        width: double.infinity,
                                                              child: Center(child: Text("Choose a date",
                                                                    textAlign: TextAlign.justify,
                                                                    style: TextStyle(
                                                                        height: 1.6,
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Colors.white
                                                                ),)),
                                                        ),
                                                ),
                                             ],
                                      ),
                          ),
                      ));
        } else{
              return Scaffold(
                        body: Container(
                            child: Center(child: CircularProgressIndicator()),
                        ),
        );

        }


        });
        }
        }
