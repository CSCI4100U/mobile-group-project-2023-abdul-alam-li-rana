import 'dart:typed_data';

import 'package:final_project/Functionality/account.dart';
import 'package:final_project/Functionality/db_utils.dart';
import 'package:sqflite/sqflite.dart';

class AccountModel {
  Future<int> insertAccount(Account account) async {
    final db = await DBUtils.init();
    return db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(
      maps.length,
          (i) => Account.fromMap(maps[i]),
    );
  }

  Future<Account?> getAccountByEmail(String? email) async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'email = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty ? Account.fromMap(maps.first) : null;
  }

  void savePicture(Account account) async {
    var db = await DBUtils.init();
    await db.insert("profilepic", account.toMap());
  }

  Future<int> updateAccount(Account account) async {
    final db = await DBUtils.init();
    return db.update(
      'accounts',
      account.toMap(),
      where: 'email = ?',
      whereArgs: [account.email],
    );
  }

  Future<int> deleteAccountById(String email) async {
    final db = await DBUtils.init();
    return db.delete(
      'accounts',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<int> deleteAllAccounts() async {
    final db = await DBUtils.init();
    print("Local Storage Cleared!");
    return db.delete('accounts');
  }

  Future<int> updateProfilePicture(String email, Uint8List profilePicture) async {
    final db = await DBUtils.init();
    return db.update(
      'accounts',
      {'profilePicture': profilePicture},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
