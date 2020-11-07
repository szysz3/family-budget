import 'package:family_budget/chart/expense_by_category_chart.dart';
import 'package:family_budget/chart/expenses_to_days_chart.dart';
import 'package:family_budget/chart/total_expenses_chart.dart';
import 'package:family_budget/chart/weekly_expenses_chart.dart';
import 'package:family_budget/page/settings_page.dart';
import 'package:family_budget/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../util/auth.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.signInResult}) : super(key: key);

  final SignInResult signInResult;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _getDrawerHeader(widget.signInResult),
              _getSettingsElement(),
              Divider(),
              Builder(builder: (context) => _getLogoutElement(context))
            ],
          ),
        ),
        floatingActionButton: _getExpenseButton(context),
        body: Builder(builder: (context) => _getPageContent(context)));
  }

  Widget _getSettingsElement() {
    return ListTile(
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      onTap: () {
        _showSettingsPage(context);
      },
      leading: SvgPicture.asset(
        "assets/geometry.svg",
        height: 24,
      ),
    );
  }

  _showSettingsPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Widget _getLogoutElement(BuildContext context) {
    return ListTile(
      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.subtitle2,
      ),
      onTap: () {
        _onLogoutPressed(context);
      },
      leading: SvgPicture.asset("assets/exit.svg", height: 24),
    );
  }

  _onLogoutPressed(BuildContext context) {
    _showOrHideDrawerMenu(context);
    ViewUtil.showErrorSnackbar("Not implemented yet!", context);
  }

  Widget _getDrawerHeader(SignInResult signInResult) {
    return DrawerHeader(
      child: Center(
          child: Column(
        children: <Widget>[
          _getUserAvatar(signInResult.imageUrl),
          _getUserName(signInResult.name),
          _getUserEmail(signInResult.email)
        ],
      )),
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: [Colors.blueGrey[600], Colors.blueGrey[300]]))
    );
  }

  Widget _getUserEmail(String userEmail) {
    return Container(
      child: Text(
        userEmail,
        style: Theme.of(context).textTheme.caption,
      ),
      margin: EdgeInsets.only(top: 4),
    );
  }

  Widget _getUserName(String userName) {
    return Container(
      child: Text(
        userName,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  Widget _getUserAvatar(String avatarUrl) {
    return CircleAvatar(
      radius: 39,
      // backgroundColor: Colors.blueGrey[700],
      child: CircleAvatar(
        radius: 38,
        // backgroundColor: Colors.blueGrey[400],
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }

  Widget _getHamburgerMenu(BuildContext context) {
    return RawMaterialButton(
      shape: CircleBorder(),
      // fillColor: Colors.blueGrey[50],
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset("assets/hamburger.svg", height: 32),
      onPressed: () async {
        _showOrHideDrawerMenu(context);
      },
    );
  }

  _showOrHideDrawerMenu(BuildContext context) async {
    ScaffoldState scaffold = Scaffold.of(context);
    if (scaffold.isDrawerOpen) {
      Navigator.pop(context);
    } else {
      scaffold.openDrawer();
    }
  }

  Widget _getExpenseButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddExpensePage()));
      },
      child: SvgPicture.asset("assets/money.svg"),
    );
  }

  Widget _getPageContent(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [Colors.blueGrey[200], Colors.blueGrey[100]])),
        child: Container(
      margin: EdgeInsets.only(top: 48, bottom: 24),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _getHamburgerMenu(context),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: _getChartSwiper(context),
                  height: 348,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _getChartSwiper(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return _wrapWidgetWithPadding(
                _wrapChartWithCard(WeeklyExpensesChart()));
          case 1:
            return _wrapWidgetWithPadding(
                _wrapChartWithCard(ExpensesToDaysChart()));
          case 2:
            return _wrapWidgetWithPadding(
                _wrapChartWithCard(ExpenseByCategoryChart()));
          case 3:
            return _wrapWidgetWithPadding(
                _wrapChartWithCard(TotalExpensesChart(), topMargin: 24));
          default:
            throw Exception("Unknown chart type!");
        }
      },
      itemCount: 4,
    );
  }

  Widget _wrapWidgetWithPadding(Widget widget) {
    return Padding(child: widget, padding: EdgeInsets.all(12));
  }

  Widget _wrapChartWithCard(Widget chart, {double topMargin = 48}) {
    return Card(
        margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 24),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding:
              EdgeInsets.only(left: 24, right: 24, top: topMargin, bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[chart],
          ),
        ));
  }
}
