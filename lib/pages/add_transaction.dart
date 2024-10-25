import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/controllers/dbhelper.dart';

class  addTransaction extends StatefulWidget{
  @override
  State<addTransaction> createState() => _addTransactionState();
}

class _addTransactionState extends State<addTransaction> {
  //
  int? amount;
  String note="Some Expense";
  String type="Income";

  DateTime selectedDate=DateTime.now();

  List<String> months = ["Jan", "Feb", "March", "April", "May", "June", "July", "Aug","Sept", "Oct", "Nov", "Dec" ];

  Future<void> _selectedDate(BuildContext context)async {
  final DateTime? picked= await showDatePicker(context: context, firstDate: DateTime(2020,12), 
      lastDate: DateTime(2100,01),);
  if(picked !=null && picked!=selectedDate){
    setState(() {
      selectedDate=picked;
    });
  }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      
      body:ListView(
        padding: const EdgeInsets.all(12.0,),

        children: [
          SizedBox(
            height: 20.0,
          ),
          Text('Add Transactioin',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w700),),
          SizedBox(
            height: 20.0,
          ),
          Row(

        children: [
          Container(
              decoration: BoxDecoration(
                color:  Colors.deepPurple,
                borderRadius: BorderRadius.circular(16.0)
              ),
              child: Icon(Icons.attach_money,
              color: Colors.white,
                size: 24.0,
              )
          ),
          SizedBox(
            width: 16.0,
          ),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '0',
                border: InputBorder.none,
              ),
              onChanged: (val){
                try {
                  amount=int.parse(val);
                }catch(e){}
              },
              style: TextStyle(fontSize: 24.0),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
          SizedBox(
            height: 20.0,
          ),

          Row(

            children: [
              Container(
                  decoration: BoxDecoration(
                      color:  Colors.deepPurple,
                      borderRadius: BorderRadius.circular(16.0)
                  ),
                  child: Icon(Icons.description,
                    color: Colors.white,
                    size: 24.0,
                  )
              ),
              SizedBox(
                width: 16.0,
              ),

              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Note on Transaction',
                    border: InputBorder.none,
                  ),
                  onChanged: (val){
                    note=val;
                  },
                  style: TextStyle(fontSize: 24.0),


                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
             children: [
               Container(
                   decoration: BoxDecoration(
                       color:  Colors.deepPurple,
                       borderRadius: BorderRadius.circular(16.0)
                   ),
                   child: Icon(Icons.moving_sharp,
                     color: Colors.white,
                     size: 24.0,
                   )
               ),
               SizedBox(
                 width: 16.0,
               ),

               ChoiceChip(
                 label: Text(
                   "Income",
               style: TextStyle(fontSize: 18,
               color: type=="Income"?Colors.white:Colors.black),
               ),
                   selectedColor:  Colors.deepPurple,
                   selected: type=="Income"?true:false,
                   onSelected: (val){
                      if(val){
                        setState(() {
                          type="Income";
                        });
                      }
                   },
               ),

               SizedBox(
                 width: 16.0,
               ),

               ChoiceChip(
                 label: Text(
                   "Expense",
                   style: TextStyle(fontSize: 18,
                       color: type=="Expense"?Colors.white:Colors.black),
                 ),
                 selectedColor:  Colors.deepPurple,
                 selected: type=="Expense"?true:false,
                 onSelected: (val){
                   if(val){
                     setState(() {
                       type="Expense";
                     });
                   }
                 },
               ),

             ],
           ),
          SizedBox(
            height: 20.0,
          ),


          TextButton(onPressed: (){
            _selectedDate(context);
          }
              , child:   Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:  Colors.deepPurple,
                        borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: Icon(Icons.date_range,
                      color: Colors.white,
                      size: 24.0,
                    ),

                              ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  "${selectedDate.day} ${months[selectedDate.month-1]}",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),
                )
                ],
              ),


          ),


          SizedBox(
            height: 20.0,
          ),

          SizedBox(
            width: 50.0,
            child: ElevatedButton(onPressed: () async {
              if(amount!=null && note.isNotEmpty) {
                DbHelper dbhelper=DbHelper();
                await dbhelper.addData(amount!, selectedDate, note, type);
                Navigator.of(context).pop();
              }else{
                print('not all values provided!');
              }

            },
                child: Text("Add",
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),

                ),

            ),
          ),





]

    )
              );

  }
}