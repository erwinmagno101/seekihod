import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/models/EventModel.dart';
import 'package:seekihod/models/NewsModel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/SpotModel.dart';
import 'main_view.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  List<EventModel> eventsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Experience',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: myThemes.getFontwithOpacity(context, .6)),
              ),
              const Text(
                "Current Events",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 250,
                child: StreamBuilder<List<EventModel>>(
                    stream: readEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        eventsList = snapshot.data!;

                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: eventsList.length,
                            itemBuilder: (context, index) {
                              EventModel currentEventModel = eventsList[index];
                              return Card(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Center(
                                    child: Text(
                                      currentEventModel.title,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Text("No Data");
                      }
                    }),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Check The Date!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 300,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    child: SfCalendar(
                      view: CalendarView.month,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Upcoming",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.of(context).size.width / .7,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: ((context, index) {
                    return Container(
                      height: 250,
                      child: Card(),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<SpotModel>> readSpots() => FirebaseFirestore.instance
      .collection('Spots')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => SpotModel.fromJson(doc.data())).toList());

  Stream<List<EventModel>> readEvents() => FirebaseFirestore.instance
      .collection('Event')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList());
}
