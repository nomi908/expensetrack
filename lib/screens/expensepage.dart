import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:expense_track/providers/profile_provider.dart';
import 'package:expense_track/screens/transactionpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Expensepage extends StatelessWidget {
  const Expensepage({super.key});

  @override
  Widget build(BuildContext context) {
    final futureprovider = Provider.of<ExpensePageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Welcome ${provider.userData?['firstName']}!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<ProfileProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: provider.profileImageUrl != null
                      ? NetworkImage(provider.profileImageUrl!)
                      : provider.image != null
                          ? FileImage(provider.image!)
                          : null,
                  child:
                      provider.image == null && provider.profileImageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                ),
              );
            },
          ),
        ],
      ),
      body:  FutureBuilder(
        future: futureprovider.getallTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Consumer<ExpensePageProvider>(
              builder: (context, provider, _) {
                print('data: ${provider.alltransaction.length}');
                print('dataamont: ${provider.totalAmount}');
                print(('income: ${provider.incomeTransaction}'));
                print(('expense: ${provider.expenseTransaction}'));
                return Column(
                  children: [
                    Material(
                  elevation: 4, // Set the elevation level here
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        height: 220,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )),
                        child: Column(
                          children: [
                            Text(
                              'Total Balance',
                              style:
                              TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${provider.totalAmount.toStringAsFixed(2)}',
                              style:
                              TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //income conatiner
                                Container(
                                    padding: EdgeInsets.all(8),
                                    height: 80,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/icome_ic.png'),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                  child: Text(
                                                    'Income',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )),
                                              Container(child: Text(
                                                '${provider.incomeTransaction
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                //expense container
                                Container(
                                    padding: EdgeInsets.all(8),
                                    height: 80,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/icons/expense_ic.png'),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                  child: Text(
                                                    'Expense',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )),
                                              Container(child:
                                              Text(
                                                '${provider.expenseTransaction
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transaction',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)
                            => Transactionpage()));
                          }, child: Text(
                              'View all ')),
                        ],
                      ),
                    ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: provider.alltransaction.length,
                              itemBuilder: (context, index) {
                                final transaction = provider
                                    .alltransaction[index];
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                                  elevation: 10,
                                  child: ListTile(
                                    leading: Image.asset(
                                        transaction['transactionType'] == 'Income'
                                            ? 'assets/icons/icome_ic.png'
                                            : 'assets/icons/expense_ic.png'),
                                    title: Text(
                                      transaction['transactionType'] == 'Income'
                                          ? 'Income'
                                          : 'Expense',
                                      style: TextStyle(
                                          color: transaction['transactionType'] ==
                                              'Income' ? Colors.green : Colors
                                              .red),),
                                    subtitle: Text(transaction['amount'].toString(),
                                      style: TextStyle(
                                          color: transaction['transactionType'] ==
                                              'Income' ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold, fontSize: 20
                                      ),),
                                    trailing: Text(
                                      (transaction['dateTime'] as Timestamp).toDate().toString().split(' ')[0],  // Extracts only the date
                                    ),
                                  ),
                                );
                              }
                          ))
                    ],
                  );
                }
            );

          }),
      );
  }
}
