import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statisticspage extends StatelessWidget {
  const Statisticspage({super.key});

  @override
  Widget build(BuildContext context) {
    final income = context.read<ExpensePageProvider>().incomeTransaction;
    final expense = context.read<ExpensePageProvider>().expenseTransaction;
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                  SizedBox(width: 8), // Add some spacing
                  Text('Total Income: ${income.toStringAsFixed(2)}'),
                ],
              ),
              SizedBox(height: 8), // Add some spacing between rows
              // Total Expense Row
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 8), // Add some spacing
                  Text('Total Expense: ${expense.toStringAsFixed(2)}'),
                ],
              ),
        
              Container(
                height: 200,
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 100),
                padding: EdgeInsets.all(8),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        title: '${income.toStringAsFixed(2)}',
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 60,
                        value: income,
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        title: '${expense.toStringAsFixed(2)}',
                        titleStyle: TextStyle(color: Colors.white),
                        radius: 60,
                        value: expense,
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 80,
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),



    );
  }
}
