import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:expense_track/screens/updatatransactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class Transactionpage extends StatelessWidget {
//   const Transactionpage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All Transactions'),
//       ),
//       body: FutureBuilder(
//         future: Provider.of<ExpensePageProvider>(context, listen: false).getallTransaction(),
//         builder: (context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         return Consumer<ExpensePageProvider>(
//           builder: (context, provider, _){
//             return ListView.builder(
//               itemCount: provider.alltransaction.length,
//               itemBuilder: (context, index){
//                 return Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 6,
//                   child: ListTile(
//                     onTap: (){
//
//                       DateTime selectedDateTime;
//                       if(provider.alltransaction[index]['dateTime'] is Timestamp){
//                       selectedDateTime = (provider.alltransaction[index]['dateTime'] as Timestamp).toDate();
//                       }else{
//                         selectedDateTime = DateTime.parse(provider.alltransaction[index]['dateTime']);
//                       }
//                       print("Navigating to UpdateTransaction");
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTransaction(
//                         amount: provider.alltransaction[index]['amount'].toString(),
//                         category: provider.alltransaction[index]['category'],
//                         description: provider.alltransaction[index]['description'],
//                         transactionType: provider.alltransaction[index]['transactionType'],
//                         docId: provider.alltransaction[index]['transactionId'],
//                         dateTime: selectedDateTime,
//                       )));
//                     },
//                     title: Text(provider.alltransaction[index]['category'], maxLines: 1,
//                       overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold),),
//                     subtitle: Text(provider.alltransaction[index]['description'],
//                      maxLines: 2, overflow: TextOverflow.ellipsis,),
//                     trailing: Text((provider.alltransaction[index]['transactionType'] == 'Income' ? '+' : '-') +
//                         provider.alltransaction[index]['amount'].toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
//                     color: provider.alltransaction[index]['transactionType'] == 'Income'
//                     ? Colors.green : Colors.red),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//         },
//       ),
//     );
//   }
// }

class Transactionpage extends StatefulWidget {
  const Transactionpage({super.key});

  @override
  _TransactionpageState createState() => _TransactionpageState();
}

class _TransactionpageState extends State<Transactionpage> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked.start != null && picked.end != null) {
                setState(() {
                  startDate = picked.start;
                  endDate = picked.end;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ExpensePageProvider>(context, listen: false).getallTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<ExpensePageProvider>(
            builder: (context, provider, _) {
              // Filter transactions based on the selected date range
              final transactions = startDate != null && endDate != null
                  ? provider.getFilteredTransactions(startDate!, endDate!)
                  : provider.alltransaction;

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  // Same ListTile implementation as before
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 6,
                    child: ListTile(
                      onTap: () {
                        // Navigate to UpdateTransaction as before

                        DateTime selectedDateTime;
                      if(provider.alltransaction[index]['dateTime'] is Timestamp){
                      selectedDateTime = (provider.alltransaction[index]['dateTime'] as Timestamp).toDate();
                      }else{
                        selectedDateTime = DateTime.parse(provider.alltransaction[index]['dateTime']);
                      }
                      print("Navigating to UpdateTransaction");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTransaction(
                        amount: provider.alltransaction[index]['amount'].toString(),
                        category: provider.alltransaction[index]['category'],
                        description: provider.alltransaction[index]['description'],
                        transactionType: provider.alltransaction[index]['transactionType'],
                        docId: provider.alltransaction[index]['transactionId'],
                        dateTime: selectedDateTime,
                      )));
                      },
                      title: Text(transactions[index]['category'],
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(transactions[index]['description'],
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text((transactions[index]['transactionType'] == 'Income' ? '+' : '-') +
                          transactions[index]['amount'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,
                              color: transactions[index]['transactionType'] == 'Income'
                                  ? Colors.green : Colors.red)),

                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
