import 'package:family_budget/data/data_access.dart';
import 'package:family_budget/data/model/expense_categories.dart';
import 'package:family_budget/data/model/settings_categories.dart';
import 'package:family_budget/data/model/settings_model.dart';
import 'package:family_budget/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, TextEditingController> _textEditingControllers;
  var _isRequestInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.surface
              ])),
          child: Builder(builder: (context) => _getPageContent(context))),
    ));
  }

  Widget _getPageContent(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done &&
            !snap.hasError &&
            snap.hasData) {
          return _showSettingsPage(context, snap.data);
        } else {
          return _showLoadingIndicator();
        }
      },
      future: DataAccess().getSettings(),
    );
  }

  Widget _showSettingsPage(BuildContext context, SettingsModel settingsModel) {
    _initEditingControllers(settingsModel);
    return Container(
      margin: EdgeInsets.all(12),
      child: ListView(
        children: <Widget>[
          _getIncomeElement(),
          _getFixedExpenses(),
          _getBudget(),
          _getWidgetRow(context)
        ],
      ),
    );
  }

  Widget _showLoadingIndicator() {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            )
          ],
        )
      ],
    )));
  }

  _initEditingControllers(SettingsModel settingsModel) {
    var settingsMap = settingsModel.toMap();
    _textEditingControllers = settingsMap.map((key, value) {
      var textEditingController = TextEditingController();
      textEditingController.text = value.toStringAsFixed(2);
      return MapEntry<String, TextEditingController>(
          key, textEditingController);
    });
  }

  Widget _getWidgetRow(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_getCancelButton(), _getAcceptButton(context)],
          )
        ],
      ),
      margin: EdgeInsets.only(top: 8, bottom: 8),
    );
  }

  Widget _getAcceptButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: RawMaterialButton(
          elevation: 8,
          padding: EdgeInsets.all(2),
          shape: CircleBorder(),
          fillColor: Colors.transparent,
          child: SvgPicture.asset("assets/checked.svg", height: 42),
          onPressed: () async {
            _onAcceptButtonPressed(context);
          },
        ));
  }

  _onAcceptButtonPressed(BuildContext context) async {
    if (_isRequestInProgress) {
      return;
    }

    Map<String, String> settingsItems =
        _textEditingControllers.map((key, value) {
      return MapEntry<String, String>(key, value.text);
    });

    try {
      _isRequestInProgress = true;
      await DataAccess()
          .saveOrUpdateSettings(SettingsModel.fromMap(settingsItems))
          .timeout(const Duration(days: 0, hours: 0, minutes: 0, seconds: 5));
    } on Exception catch (_) {
      _handleSaveSettingsError(context);
      _isRequestInProgress = false;
      return;
    }

    _isRequestInProgress = false;
    Navigator.pop(context);
  }

  _handleSaveSettingsError(BuildContext context) {
    ViewUtil.showErrorSnackbar("Settings not saved. Try again.", context);
  }

  Widget _getCancelButton() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: RawMaterialButton(
          elevation: 8,
          shape: CircleBorder(),
          fillColor: Colors.transparent,
          child: SvgPicture.asset("assets/cancel.svg", height: 32),
          onPressed: () async {
            Navigator.pop(context);
          },
        ));
  }

  Widget _getIncomeElement() {
    return Column(
      children: <Widget>[
        Text(
          "INCOME",
          style: Theme.of(context).textTheme.headline6,
        ),
        Container(
          margin: EdgeInsets.only(top: 12, bottom: 32),
          width: 250,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _textEditingControllers[SettingsCategories.income],
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(hintText: "0.00 PLN"),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _getFixedExpenses() {
    return Column(
      children: <Widget>[
        Text(
          "FIXED EXPENSES",
          style: Theme.of(context).textTheme.headline6,
        ),
        Container(
            margin: EdgeInsets.only(top: 12, bottom: 32),
            child: Column(
              children: <Widget>[
                _getRow("${SettingsCategories.loans}:", false,
                    _textEditingControllers[SettingsCategories.loans]),
                _getRow("${SettingsCategories.subscriptions}:", false,
                    _textEditingControllers[SettingsCategories.subscriptions]),
                _getRow("${SettingsCategories.rent}:", false,
                    _textEditingControllers[SettingsCategories.rent]),
              ],
            ))
      ],
    );
  }

  Widget _getBudget() {
    return Column(
      children: <Widget>[
        Text(
          "BUDGET",
          style: Theme.of(context).textTheme.headline6,
        ),
        Container(
          margin: EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            children: <Widget>[
              _getRow("${ExpenseCategories.transport}:", true,
                  _textEditingControllers[ExpenseCategories.transport],
                  imageName: "${ExpenseCategories.transport}.svg"),
              _getRow("${ExpenseCategories.food}:", true,
                  _textEditingControllers[ExpenseCategories.food],
                  imageName: "${ExpenseCategories.food}.svg"),
              _getRow("${ExpenseCategories.party}:", true,
                  _textEditingControllers[ExpenseCategories.party],
                  imageName: "${ExpenseCategories.party}.svg"),
              _getRow("${ExpenseCategories.bills}", true,
                  _textEditingControllers[ExpenseCategories.bills],
                  imageName: "${ExpenseCategories.bills}.svg"),
              _getRow("${ExpenseCategories.house}:", true,
                  _textEditingControllers[ExpenseCategories.house],
                  imageName: "${ExpenseCategories.house}.svg"),
              _getRow("${ExpenseCategories.other}:", true,
                  _textEditingControllers[ExpenseCategories.other],
                  imageName: "${ExpenseCategories.other}.svg"),
            ],
          ),
        )
      ],
    );
  }

  Widget _getRow(String title, bool showIcon, TextEditingController controller,
      {String imageName = ""}) {
    var widgets = List<Widget>();
    if (showIcon) {
      widgets.add(Padding(
          padding: EdgeInsets.only(right: 12),
          child: SvgPicture.asset("assets/$imageName", height: 24)));
    }

    widgets.add(
      SizedBox(
        width: showIcon ? 84 : 120,
        child: Text(title),
      ),
    );

    widgets.add(Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration.collapsed(hintText: "0.00 PLN"),
          ),
        ),
      ),
    ));

    return Padding(
        padding: EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Row(
          children: widgets,
        ));
  }
}
