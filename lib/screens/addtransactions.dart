import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:expense_track/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Addtransactions extends StatelessWidget {
  final String? amount;
  final String? category;
  final String? description;
  final DateTime? dateTime;
  final String? transactionType;
  final bool isUpdate;
  final String? docId;

  Addtransactions({super.key, this.amount, this.category,
    this.description, this.dateTime, this.transactionType, this.isUpdate = false, this.docId});
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(isUpdate == true){

      _amountController.text = amount!;
      _categoryController.text = category!;
      _descriptionController.text = description!;
      context.read<TransactionProvider>().setSelecteddateTime(dateTime!);
      context.read<TransactionProvider>().setTransactionType(transactionType!);
      context.read<TransactionProvider>().setCurrentDocId(docId!);

      print(" all Amount: ${amount}");
      print("all Category: ${category}");
      print("all Description: ${description}");


    }else{
      context.read<TransactionProvider>().resetinputs();
    }


    return Scaffold(
        appBar: AppBar(title: Text(isUpdate == true ? 'Update Transaction' : 'Add Transaction')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 30),
            child: Consumer<TransactionProvider>(builder: (context, provider, _) {
              return Column(
                children: [
                  _textwidget("Enter Amount", context, (value) {
                    provider.setAmount(value);
                  }, 1,
                      TextInputType.number, _amountController),
                  const SizedBox(height: 15),
                  _textwidget("Enter Category e.g shopping", context, (value) {
                    provider.setCategory(value);

                  },
                      1, TextInputType.text, _categoryController),
                  const SizedBox(height: 15),

                  _textwidget("Enter Description", context, (value) {
                    provider.setDescription(value);
                  }, 4,
                      TextInputType.text,
                      _descriptionController

                  ),
                  const SizedBox(height: 15),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Radio(
                        value: 'Income',
                        groupValue: context.watch<TransactionProvider>().transactionType,
                        onChanged: (value) {
                          if(value !=null){
                            context.read<TransactionProvider>().setTransactionType(value);
                          }
                        }),
                    Text('Income'),
                    SizedBox(width: 20),
                    Radio(
                        value: 'Expense',
                        groupValue: context.watch<TransactionProvider>().transactionType,
                        onChanged: (value) {
                          if(value !=null){
                            context.read<TransactionProvider>().setTransactionType(value);
                          }
                        }),
                    Text('Expense'),
                  ]),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    // Padding inside the container
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      // Border properties
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    child: InkWell(
                      onTap: () async{
                        await provider.openDatePicker(context);
                    },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            provider.selecteddateTime != null
                            ? '${provider.selecteddateTime!.day}/'
                                '${provider.selecteddateTime!.month}/${provider.selecteddateTime!.year} '
                                '${provider.selecteddateTime!.hour}:${provider.selecteddateTime!.minute}'
                            : 'Select Date & Time',
                            style: TextStyle(
                              fontSize: 16.0, // Font size
                              color: Colors.black, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  //add transaction button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: provider.isLoadingState ? Center(child: CircularProgressIndicator()) :
                    ElevatedButton(
                          onPressed: () async {

                            if (provider.amount.isEmpty ||
                                provider.category.isEmpty ||
                                provider.description.isEmpty ||
                                provider.selecteddateTime == null) {
                              print(" all Amount: ${provider.amount}");
                              print("all Category: ${provider.category}");
                              print("all Description: ${provider.description}");
                              print(" all DateTime: ${provider.selecteddateTime}");

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      'Please fill all the fields'),));
                            } else {
                              Map<String, dynamic> transactiondata = {
                                'amount': provider.amount,
                                'category': provider.category,
                                'description': provider.description,
                                'dateTime': provider.selecteddateTime
                              };
                              // await provider.addTransaction(transactiondata);


                              if (isUpdate == true) {
                              await provider.updateTransaction(transactiondata);
                                // await provider.updateTransaction(transactiondata);
                                print(" all update Amount: ${provider.amount}");
                                print("all update Category: ${provider.category}");
                                print("all update Description: ${provider.description}");
                                print(" all update DateTime: ${provider.selecteddateTime}");

                              }else {
                                await provider.addTransaction(transactiondata);
                              }


                              context.read<ExpensePageProvider>().getallTransaction();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Transaction Successful')
                              )
                             );
                            }
                          },

                          child: Text(
                            isUpdate == true ? 'Update Transaction' : 'Add Transaction',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                        )
                  ),
                ],
              );
            }),
          ),
        ),
      );
  }
}

Widget _textwidget(String lableText, BuildContext context,
    Function(String) onChanged, maxlines, textInputType, TextEditingController? controller) {
  return TextField(
    maxLines: maxlines,
    keyboardType: textInputType,
    controller: controller,
    decoration: InputDecoration(
        label: Text(lableText),
        hintText: lableText,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.purple, width: 2.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        )),
    onChanged: onChanged,
  );
}
