import 'package:flutter/material.dart';
import 'package:todolist/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;

  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) async {
    final T item = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return item;
  }

  @override
  Future<void> delete(T data) async {
    localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
