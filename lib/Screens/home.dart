import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_stock_tracking_app/Models/globalQuoteModel.dart';
import 'package:simple_stock_tracking_app/Screens/globalQuoteDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_stock_tracking_app/Screens/styles/custom_input_border.dart';
import 'package:simple_stock_tracking_app/Services/globalQuoteService.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int listItemCount = 2;
  String dropdownValue = 'One';
  List<String> globalQuotesList = [];
  SharedPreferences prefs;
  GlobalQuoteService globalQuoteService = GlobalQuoteService();
  String currentSymbol;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(4, 131, 184, .1),
      100: Color.fromRGBO(4, 131, 184, .2),
      200: Color.fromRGBO(4, 131, 184, .3),
      300: Color.fromRGBO(4, 131, 184, .4),
      400: Color.fromRGBO(4, 131, 184, .5),
      500: Color.fromRGBO(4, 131, 184, .6),
      600: Color.fromRGBO(4, 131, 184, .7),
      700: Color.fromRGBO(4, 131, 184, .8),
      800: Color.fromRGBO(4, 131, 184, .9),
      900: Color.fromRGBO(4, 131, 184, 1),
    };

    return MaterialApp(
      theme: ThemeData(
        primaryColor: MaterialColor(0xff231F20, color),
        primarySwatch: Theme.of(context).primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "My Stocks",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: new Image.asset('Assets/Plus_sign_icon_4x.png'),
                onPressed: () {
                  _showMaterialDialog();
                },
              ),
            )
          ],
        ),
        extendBodyBehindAppBar: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot){

            if(!snapshot.hasData)
              return Center();

            prefs=snapshot.data;
            if (prefs.getString("Symbols") != null && prefs.getString("Symbols").isNotEmpty) {
              globalQuotesList = prefs.getString("Symbols").split(",");
            }
            return ListView.separated(
              padding: EdgeInsets.only(top: 50),
              shrinkWrap: true,
              itemCount: globalQuotesList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey,
                  thickness: 0.20,
                  indent: 12,
                  endIndent: 12,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  background: Container(color: Colors.black38),
                  onDismissed: (DismissDirection direction) {
                    setState(() {
                      globalQuotesList.removeAt(index);
                      saveSymbolsLocally();
                    });
                  },
                  child: GlobalQuoteDisplay(globalQuotesList[index]),
                  key: UniqueKey(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  saveSymbolsLocally() {
    String symbols = globalQuotesList.join(",");
    prefs.setString("Symbols", symbols);
  }

  _showMaterialDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                "New Stock Symbol",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey[800],
              content: DropdownSearch<GlobalQuoteModel>(
                popupItemBuilder: _globalQuoteResult,
                label: "FIND",
                dropDownButton:
                    Visibility(child: Icon(Icons.search), visible: false),
                popupShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                searchBoxController: TextEditingController(),
                searchBoxDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.indigo),
                  contentPadding: EdgeInsets.all(6),
                  labelText: "Search a Symbol",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(style: BorderStyle.none)
                  ),
                ),
                mode: Mode.DIALOG,
                popupBackgroundColor: Colors.grey[800],
                popupBarrierColor: Colors.transparent,
                isFilteredOnline: true,
                showClearButton: true,
                showSearchBox: true,
                itemAsString: (globalQuote) => globalQuote.symbolName,
                dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.only(left: 10),
                    isDense: true,
                    labelStyle: TextStyle(color: Colors.indigo),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    )),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                onFind: (String filter) {
                  return globalQuoteService.findGlobalQuotes(filter);
                },
                onChanged: (GlobalQuoteModel data) =>
                    currentSymbol = data.symbolName,
              ),
              actions: [
                OutlineButton(
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (globalQuotesList.length < 5) {
                      if (!globalQuotesList.contains(currentSymbol)) {
                        setState(() {
                          globalQuotesList.add(currentSymbol);
                          saveSymbolsLocally();
                        });
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ]),
        );
      },
    );
  }
}

Widget _globalQuoteResult(
    BuildContext context, GlobalQuoteModel item, bool isSelected) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          item?.symbolName ?? "",
          style: TextStyle(color: Colors.white),
        ),
      ),
      Divider(
        color: Colors.grey,
        thickness: 0.20,
        indent: 12,
        endIndent: 12,
      )
    ],
  );
}
