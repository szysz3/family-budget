import 'package:family_budget/data/data_access.dart';
import 'package:family_budget/data/model/expense_categories.dart';
import 'package:family_budget/data/model/icon_model.dart';
import 'package:family_budget/util/view_util.dart';
import 'package:family_budget/widget/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddExpensePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpensePage> {
  final List<IconModel> _icons = [
    IconModel("assets/${ExpenseCategories.food}.svg", ExpenseCategories.food),
    IconModel("assets/${ExpenseCategories.transport}.svg",
        ExpenseCategories.transport),
    IconModel("assets/${ExpenseCategories.party}.svg", ExpenseCategories.party),
    IconModel("assets/${ExpenseCategories.bills}.svg", ExpenseCategories.bills),
    IconModel("assets/${ExpenseCategories.house}.svg", ExpenseCategories.house),
    IconModel("assets/${ExpenseCategories.other}.svg", ExpenseCategories.other)
  ];

  List<IconModel> _selectedIcons = [];
  final _descTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  bool _isRequestInProgress = false;

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
                Theme.of(context).colorScheme.primaryVariant
              ])),
          child: Builder(builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.all(24),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: _getCategoryGridView(context),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: _getDescTextField(context),
                  ),
                  Container(
                      width: 250,
                      padding: EdgeInsets.all(48),
                      child: _getAmountTextField(context)),
                  Container(
                    margin: EdgeInsets.only(top: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getBottomButtons(context),
                    ),
                  )
                ],
              ),
            );
          })),
    ));
  }

  List<Widget> _getBottomButtons(BuildContext context) {
    return [
      Container(
        margin: EdgeInsets.only(right: 32),
        child: RawMaterialButton(
          elevation: 8,
          padding: EdgeInsets.all(1),
          shape: CircleBorder(),
          fillColor: Colors.transparent,
          child: SvgPicture.asset("assets/cancel.svg", height: 32),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 32),
        child: RawMaterialButton(
          elevation: 8,
          padding: EdgeInsets.all(2),
          shape: CircleBorder(),
          fillColor: Colors.transparent,
          child: SvgPicture.asset(
            "assets/money.svg",
            height: 52,
          ),
          onPressed: () => {_saveExpense(context)},
        ),
      )
    ];
  }

  _saveExpense(BuildContext context) async {
    if (_isRequestInProgress) {
      return;
    }

    var parsedAmount = double.tryParse(_amountTextController.text);
    if (parsedAmount == null || _selectedIcons.first == null) {
      return;
    }

    try {
      _isRequestInProgress = true;
      await DataAccess()
          .addExpense(parsedAmount, _selectedIcons.first.category,
              _descTextController.text)
          .timeout(const Duration(days: 0, hours: 0, minutes: 0, seconds: 5));
    } on Exception catch (_) {
      _handleSaveExpenseError(context);
      _isRequestInProgress = false;
      return;
    }

    _isRequestInProgress = false;
    Navigator.pop(context);
  }

  _handleSaveExpenseError(BuildContext context) {
    ViewUtil.showErrorSnackbar("Expense not saved. Try again.", context);
  }

  Widget _getAmountTextField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _amountTextController,
      style: Theme.of(context).textTheme.headline4,
      decoration: InputDecoration(hintText: "0.00 PLN"),
      textAlign: TextAlign.center,
    );
  }

  Widget _getDescTextField(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _descTextController,
              decoration: InputDecoration.collapsed(hintText: "description"),
            )));
  }

  Widget _getCategoryGridView(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        primary: true,
        children: _icons.map((icon) {
          return GestureDetector(
              onTap: () {
                _selectedIcons.clear();
                setState(() {
                  _selectedIcons.add(icon);
                });
              },
              child: IconWidget(icon.path, _selectedIcons.contains(icon)));
        }).toList());
  }
}
