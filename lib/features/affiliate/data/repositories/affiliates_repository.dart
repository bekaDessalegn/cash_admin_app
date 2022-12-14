import 'package:cash_admin_app/features/affiliate/data/datasources/affiliates_datasource.dart';
import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/children.dart';
import 'package:cash_admin_app/features/affiliate/data/models/parent_affiliate.dart';

class AffiliatesRepository {
  AffiliatesDataSource affiliatesDataSource;
  AffiliatesRepository(this.affiliatesDataSource);

  Future<List<Affiliates>> getAffiliates(int skipNumber) async {
    try{
      final affiliates = await affiliatesDataSource.getAffiliates(skipNumber);
      return affiliates;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Affiliates>> searchAffiliates(String affiliateName) async{
    try{
      final affiliates = await affiliatesDataSource.searchAffiliates(affiliateName);
      return affiliates;
    } catch(e){
      throw Exception();
    }
  }

  Future<Affiliates> getAffiliate(String userId) async {
    try{
      final affiliate = await affiliatesDataSource.getAffiliate(userId);
      return affiliate;
    } catch(e){
      throw Exception();
    }
  }

  Future<ParentAffiliate> getParentAffiliate(String parentId) async {
    try{
      final affiliate = await affiliatesDataSource.getParentAffiliate(parentId);
      return affiliate;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Children>> getChildren(String userId) async {
    try{
      final children = await affiliatesDataSource.getChildren(userId);
      return children;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Affiliates>> getAffiliatesFromLowToHigh(int skipNumber) async {
    try{
      final affiliates = await affiliatesDataSource.getAffiliateEarningsFromLowToHigh(skipNumber);
      return affiliates;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Affiliates>> getAffiliatesFromHighToLow(int skipNumber) async {
    try{
      final affiliates = await affiliatesDataSource.getAffiliateEarningsFromHighToLow(skipNumber);
      return affiliates;
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Affiliates>> getMostParentAffiliate(int skipNumber) async {
    try{
      final affiliates = await affiliatesDataSource.getMostParentAffiliate(skipNumber);
      return affiliates;
    } catch(e){
      throw Exception();
    }
  }
}