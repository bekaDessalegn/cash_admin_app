import 'package:cash_admin_app/features/orders/data/datasources/remote/orders_datasource.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';

class OrdersRepository {
  OrdersDataSource ordersDataSource;
  OrdersRepository(this.ordersDataSource);

  Future getOrders(int skipNumber) async{
    try{
      final orders = await ordersDataSource.getOrders(skipNumber);
      return orders;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> filterPendingOrders(int skipNumber) async{
    try{
      final orders = await ordersDataSource.filterPendingOrders(skipNumber);
      return orders;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> filterAcceptedOrders(int skipNumber) async{
    try{
      final orders = await ordersDataSource.filterAcceptedOrders(skipNumber);
      return orders;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> filterRejectedOrders(int skipNumber) async{
    try{
      final orders = await ordersDataSource.filterRejectedOrders(skipNumber);
      return orders;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> searchOrders(String fullName, String companyName) async{
    try{
      final orders = await ordersDataSource.searchOrders(fullName, companyName);
      return orders;
    } catch(e){
      throw Exception();
    }
  }

  Future getSingleOrder(String orderId) async{
    try{
      final order = await ordersDataSource.getSingleOrder(orderId);
      return order;
    } catch(e){
      throw Exception();
    }
  }

  Future acceptOrder(String orderId) async{
    try{
      await ordersDataSource.acceptOrder(orderId);
    } catch(e){
      throw Exception();
    }
  }

  Future rejectOrder(String orderId) async{
    try{
      await ordersDataSource.rejectOrder(orderId);
    } catch(e){
      throw Exception();
    }
  }

  Future deleteOrder(String orderId) async {
    try{
      await ordersDataSource.deleteOrder(orderId);
    } catch(e){
      throw Exception();
    }
  }
}