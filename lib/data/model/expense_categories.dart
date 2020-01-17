class ExpenseCategories {
  static String food = "food";
  static String transport = "transport";
  static String party = "party";
  static String bills = "bills";
  static String house = "house";
  static String other = "other";

  static List<String> getCategoryList() {
    return [food, transport, party, bills, house, other];
  }
}
