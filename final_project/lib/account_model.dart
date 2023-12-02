import 'package:sqflite/sqflite.dart';

import 'account.dart';
import 'db_utils.dart';
class AccountModel{
  Future<int> insertAccount(Account account) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllAccounts() async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    final List maps = await db.query('accounts');
    List result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
        Account.fromMap(maps[i])
      );
    }
    return result;
  }

  Future<Account?> getAccountByEmail(String? email) async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return Account.fromMap(maps.first);
    } else {
      return null;
    }
  }

  void savePicture(Account account) async {
    var db = await DBUtils.init();
    await db.insert("profilepic", account.toMap());
  }

  Future<int> updateAccount(Account account) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.update(
      'accounts',
      account.toMap(),
      where: 'email = ?',
      whereArgs: [account.email],
    );
  }

  Future<int> deleteAccountById(String email) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.delete(
      'accounts',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<int> deleteAllAccounts() async {
  // This needs to be present in any queries, updates, etc.
  // you do with your database
  final db = await DBUtils.init();
  print("Local Storage Cleared!");
  return db.delete('accounts');
}

}