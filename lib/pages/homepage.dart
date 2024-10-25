import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/controllers/dbhelper.dart';
import 'package:money_manager/pages/add_transaction.dart';
import 'package:money_manager/pages/widgets/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_modal.dart';

class  HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper=DbHelper();
  int totalBalance=0;
  late SharedPreferences preferences;
  late Box box;
  DateTime today=DateTime.now();
  int totalIncome=0;
  int totalExpanse=0;
  List<FlSpot> dataSet=[];
//change1

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];



  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataSet = [];
    List tempdataSet = [];

    for (TransactionModel item in entireData) {
      if (item.date.month == today.month && item.type == "Expense") {
        tempdataSet.add(item);
      }
    }
    //
    // Sorting the list as per the date
    tempdataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    //
    for (var i = 0; i < tempdataSet.length; i++) {
      dataSet.add(
        FlSpot(
          tempdataSet[i].date.day.toDouble(),
          tempdataSet[i].amount.toDouble(),
        ),
      );
    }
    return dataSet;
  }
  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpanse = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpanse += data.amount;
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => addTransaction(),)).whenComplete((){
            setState(() {

            });
          }
          );
        },backgroundColor:  Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),),
        child: Icon(

        Icons.add,
        color: Colors.white,
        size: 20.0,
      ),
      ),
      body:FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context,snapshot){

          if(snapshot.hasError){
            return Center(child: Text('Unexpected Error'),);
          }
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return Center(
                child: Text('No Values found'),
              );

            }
             getTotalBalance(snapshot.data!);
            getPlotPoints(snapshot.data!);
            return ListView(

              children: [
                Padding(padding:
                    EdgeInsets.all(8.0),



                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                            borderRadius: BorderRadius.circular(12.0),

                        ),

                        

                        child: CircleAvatar(
                          maxRadius: 32.0,
                          child: Icon(Icons.face,
                            size: 32.0,),
                        )),

                    SizedBox(
                      width: 8.0,
                    ),
                    Text('Welcome ${preferences.getString('name')}',
                      style: TextStyle(fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple),
                    ),
                    ],

                    ),



                  ],
                )
          ),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.blueAccent,
                      ]
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    )
                    ),

                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26.0,
                          color: Colors.white),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          'Rs $totalBalance',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26.0,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardIncome(totalIncome.toString(),
                            ),
                            CardExpense(totalExpanse.toString(),)
                          ],
                        ),
                        )
                        
                      ],
                    ),
                  ),
                ),




                Padding(padding: EdgeInsets.all(12.0),
                child: Text("Expenses",
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                ),),
                ),

                dataSet.length <2 ? Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),

          boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 6,
          )
          ]

          ),
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.all(12.0),

          child: Text('No enogh values to render Chart!',
          style: TextStyle(
          fontSize: 20.0,
          color: Colors.black87,),
          )

          ) :Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8.0),

                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.1),
                       spreadRadius: 5,
                       blurRadius: 6,
                     )
                   ]

                 ),
                 padding: EdgeInsets.all(12.0),
                 margin: EdgeInsets.all(12.0),
                 height: 400,
                 child: LineChart(
                   LineChartData(
                    borderData: FlBorderData(show: false),
                     lineBarsData: [
                       LineChartBarData(
                         spots:getPlotPoints(snapshot.data!),
                         isCurved: false,
                         color: Colors.deepPurple,
                         barWidth: 2.5,
                       )
                     ]
                   )
                 ),
               ),


                Padding(padding: EdgeInsets.all(12.0),
                  child: Text("Recent Transactions",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),),
                ),



                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    TransactionModel dataAtIndex;
                    try{
                      dataAtIndex=snapshot.data![index];
                    }catch(e){
                      return Container();
                    }
                    if(dataAtIndex.type=="Income"){
                      return incomeTile(dataAtIndex.amount, dataAtIndex.note,dataAtIndex.date,index);
                    }else{
                      return expenseTile(dataAtIndex.amount, dataAtIndex.note,dataAtIndex.date,index);
                    }


                  },),
                SizedBox(
                  height: 60,
                ),
              ],
            );
          }else{
            return Center(child: Text('Unexpected Error'),);
          }
        },
        ),

    );
  }
  Widget CardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0)
          ),
          padding: EdgeInsets.all(6.0),

          child: Icon(Icons.arrow_downward,
          size: 28.0,
              color: Colors.green[700],),
          margin: EdgeInsets.only(
            right: 8.0
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
               "Income",
               style: TextStyle(fontSize: 14.0,color: Colors.white70),
             ),
            Text(
              value,
              style: TextStyle(fontSize: 20.0,color: Colors.white70),
            )
          ],
        )

      ],
    );
  }
  Widget CardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20.0)
          ),
          padding: EdgeInsets.all(6.0),

          child: Icon(Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],),
          margin: EdgeInsets.only(
              right: 8.0
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(fontSize: 14.0,color: Colors.white70),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 20.0,color: Colors.white70),
            )
          ],
        )

      ],
    );
  }
  Widget expenseTile(int values,String note,DateTime date,int index){
    
    return InkWell(

      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_up_outlined,
                    size: 28.0,
                    color: Colors.red[700],),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text('Expense',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month-1]}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      //fontSize: 24.0,
                      //fontWeight: FontWeight.w700),
                    ),
                  ),
                )
      
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "- $values",
                  style: TextStyle(fontSize: 24.0,
                  fontWeight: FontWeight.w700),
                ),
                Text(
                  "$note",
                  style: TextStyle(
                    color: Colors.grey[800],
                    //fontSize: 24.0,
                    //fontWeight: FontWeight.w700),
                  ),
                )
      
              ],
            ),
      
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int values,String note,DateTime date,int index){

    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.green[700],),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text('Income',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month-1]}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      //fontSize: 24.0,
                      //fontWeight: FontWeight.w700),
                    ),
                  ),
                )

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $values",
                  style: TextStyle(fontSize: 24.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "$note",
                  style: TextStyle(
                    color: Colors.grey[800],
                      //fontSize: 24.0,
                      //fontWeight: FontWeight.w700),
                ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}