import 'package:expense_track/screens/addtransactions.dart';
import 'package:expense_track/screens/expensepage.dart';
import 'package:expense_track/screens/profilepage.dart';
import 'package:expense_track/screens/statisticspage.dart';
import 'package:expense_track/screens/transactionpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bottom_nav_provider.dart';

class MyHomePage extends StatelessWidget {
  // const MyHomePage({super.key});
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    Expensepage(),
    Transactionpage(),
    Statisticspage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          Provider.of<BottomNavProvider>(context, listen: false).updateIndex(index);
        },
        children: _screens,
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => Addtransactions()));
      //
      // }, child: Icon(Icons.add, color: Colors.white,),
      //   backgroundColor: Colors.purple,),
      //
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Consumer<BottomNavProvider>(
          builder: (context, provider, _){

            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(icon: Icon(Icons.home, color: provider.currentIndex == 0 ? Colors.purple : Colors.grey,),
                    onPressed: (){
                      _pageController.jumpToPage(0);
                      provider.updateIndex(0);},),

                  IconButton(icon: Icon(Icons.sync_alt,
                    color: provider.currentIndex == 1 ? Colors.purple : Colors.grey,
                  ),onPressed: (){
                    _pageController.jumpToPage(1);
                    provider.updateIndex(1);
                  },),
                  // SizedBox(width: 40,),
                  FloatingActionButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Addtransactions()));

                  }, child: Icon(Icons.add, color: Colors.white,),
                    backgroundColor: Colors.purple,),
                  IconButton(icon: Icon(Icons.pie_chart,
                    color: provider.currentIndex == 2 ? Colors.purple : Colors.grey,
                  ),onPressed: (){
                    _pageController.jumpToPage(2);
                    provider.updateIndex(2);
                  },),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.person,
                        color: provider.currentIndex == 3 ? Colors.purple : Colors.grey,

                      ),onPressed: (){
                        _pageController.jumpToPage(3);
                        provider.updateIndex(3);
                      },
                      ),

                    ],
                  )


                ]
            );
          },
        ),
      ),
    );
  }
}