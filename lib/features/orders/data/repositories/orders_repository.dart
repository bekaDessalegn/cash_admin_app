import 'package:cash_admin_app/features/orders/data/datasources/orders_datasource.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';

class OrdersRepository {
  OrdersDataSource ordersDataSource;
  OrdersRepository(this.ordersDataSource);

  Future<List<Orders>> getOrders(int skipNumber) async{
    try{
      print("On the way to get orders");
      final orders = await ordersDataSource.getOrders(skipNumber);
      return orders;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<List<Orders>> searchOrders(String fullName, String companyName) async{
    try{
      print("On the way to search orders");
      final orders = await ordersDataSource.searchOrders(fullName, companyName);
      return orders;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<Orders> getSingleOrder(String orderId) async{
    try{
      print("On the way to get single order");
      final order = await ordersDataSource.getSingleOrder(orderId);
      return order;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future acceptOrder(String orderId) async{
    try{
      print("On the way to accept order");
      await ordersDataSource.acceptOrder(orderId);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future rejectOrder(String orderId) async{
    try{
      print("On the way to reject order");
      await ordersDataSource.rejectOrder(orderId);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future deleteOrder(String orderId) async {
    try{
      print("On the way to delete order");
      await ordersDataSource.deleteOrder(orderId);
    } catch(e){
      print(e);
      throw Exception();
    }
  }
}