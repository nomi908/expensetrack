import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:expense_track/screens/expensepage.dart';
import 'package:expense_track/screens/homescreen.dart';
import 'package:expense_track/screens/transactionpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class UpdateTransaction extends StatefulWidget {
  final String? amount;
  final String? category;
  final String? description;
  final DateTime? dateTime;
  final String? transactionType;
  final String? docId;

  UpdateTransaction({
    super.key,
    this.amount,
    this.description,
    this.docId,
    this.category,
    this.dateTime,
    this.transactionType,
  });

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    print('init state called');

    // Initialize text controllers with existing values
    // Initialize controllers
    _amountController = TextEditingController(text: widget.amount ?? '');
    _categoryController = TextEditingController(text: widget.category ?? '');
    _descriptionController = TextEditingController(text: widget.description ?? '');

    // Log values being setInitState called with values:
    print("InitState called with values: "
        "amount: ${widget.amount}, "
        "category: ${widget.category}, "
        "description: ${widget.description}, "
        "dateTime: ${widget.dateTime}, "
        "transactionType: ${widget.transactionType}");

    // Set initial values in the provider
    context.read<TransactionProvider>().setAmount(widget.amount ?? '');
    context.read<TransactionProvider>().setCategory(widget.category ?? '');
    context.read<TransactionProvider>().setDescription(widget.description ?? '');
    context.read<TransactionProvider>().setSelecteddateTime(widget.dateTime ?? DateTime.now());
    context.read<TransactionProvider>().setTransactionType(widget.transactionType ?? 'Income');
    context.read<TransactionProvider>().setCurrentDocId(widget.docId ?? '');


    // print('amount: ${widget.amount}, '
    //     'category: ${widget.category},'
    //     ' description: ${widget.description}, '
    //     'dateTime: ${widget.dateTime}, '
    //     'transactionType: ${widget.transactionType}, '
    //     'docId: ${widget.docId}');
  }


  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Transaction')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 30),
          child: Consumer<TransactionProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _textWidget("Enter Amount", context, (value) {
                      provider.setAmount(value);
                    }, 1, TextInputType.number, _amountController),
                    const SizedBox(height: 15),
                    _textWidget("Enter Category e.g shopping", context, (value) {
                      provider.setCategory(value);
                    }, 1, TextInputType.text, _categoryController),
                    const SizedBox(height: 15),
                    _textWidget("Enter Description", context, (value) {
                      provider.setDescription(value);
                    }, 4, TextInputType.text, _descriptionController),
                    const SizedBox(height: 15),
                    // Radio buttons for transaction type
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Radio(
                        value: 'Income',
                        groupValue: provider.transactionType,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setTransactionType(value);
                          }
                        },
                      ),
                      Text('Income'),
                      SizedBox(width: 20),
                      Radio(
                        value: 'Expense',
                        groupValue: provider.transactionType,
                        onChanged: (value) {
                          if (value != null) {
                            provider.setTransactionType(value);
                          }
                        },
                      ),
                      Text('Expense'),
                    ]),
                    const SizedBox(height: 15),
                    // Date picker
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await provider.openDatePicker(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 10),
                            Text(
                              provider.selecteddateTime != null
                                  ? '${provider.selecteddateTime!.day}/'
                                  '${provider.selecteddateTime!.month}/${provider.selecteddateTime!.year} '
                                  '${provider.selecteddateTime!.hour}:${provider.selecteddateTime!.minute}'
                                  : 'Select Date & Time',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Update transaction button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: provider.isLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: () async {
                          if (provider.amount.isEmpty ||
                              provider.category.isEmpty ||
                              provider.description.isEmpty ||
                              provider.selecteddateTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all the fields')),
                            );
                          } else {
                            Map<String, dynamic> transactionData = {
                              'amount': provider.amount,
                              'category': provider.category,
                              'description': provider.description,
                              'dateTime': provider.selecteddateTime,
                            };
                            await provider.updateTransaction(transactionData);
                            context.read<ExpensePageProvider>().getallTransaction();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Transaction Successful')),
                            );
                          }
                        },
                        child: Text('Update Transaction', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Show the confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text('Delete Transaction'),
                                content: Text('Are you sure you want to delete this transaction?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(); // Close the dialog
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Close the dialog first
                                      Navigator.of(dialogContext).pop(); // Close the dialog

                                      // Get the transaction ID
                                      String transactionId = provider.currentDocId;
                                      print('Current transaction ID: $transactionId');

                                      // Try to delete the transaction
                                      try {
                                        // Delete the transaction
                                        await provider.deleteTransaction(transactionId);
                                        await context.read<ExpensePageProvider>().getallTransaction(); // Refresh the list

                                        // Show a success message
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Transaction deleted successfully')),
                                          );
                                        }

                                        // Navigate to ExpensePage
                                        if (mounted) {
                                          Navigator.pop(context);

                                        }

                                      } catch (e) {
                                        // Show an error message if something goes wrong
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error deleting transaction: $e')),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Delete Transaction'),
                      ),

                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Widget for text fields
Widget _textWidget(String labelText, BuildContext context,
    Function(String) onChanged, int maxLines, TextInputType textInputType, TextEditingController controller) {
  return TextField(
    maxLines: maxLines,
    keyboardType: textInputType,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: labelText,
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.purple, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
    ),
    onChanged: onChanged,
  );
}
