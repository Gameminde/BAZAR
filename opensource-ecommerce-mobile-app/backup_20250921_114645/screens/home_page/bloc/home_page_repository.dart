/*
 *   Webkul Software.
 *   @package Mobikul Application Code.
 *   @Category Mobikul
 *   @author Webkul <support@webkul.com>
 *   @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *   @license https://store.webkul.com/license.html
 *   @link https://store.webkul.com/license.html
 */

import 'package:bazar_marketplace_app/screens/home_page/utils/index.dart';

import '../../../data_model/add_to_wishlist_model/add_wishlist_model.dart';
import '../../cart_screen/cart_model/cart_data_model.dart';
import '../../cms_screen/data_model/cms_model.dart';
import '../data_model/theme_customization.dart';
import '../../../services/bazar_api_service.dart';

abstract class HomePageRepository {
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity);
  Future<AddWishListModel?> addItemToWishlist(String? wishListProductId);
  Future<BaseModel?> callLogoutApi();
  Future<BaseModel?> callAddToCompareListApi(String? productId);
  Future<ThemeCustomDataModel?> getThemeCustomizationData();
  Future<CartModel?> cartCountApi();
  Future<CmsData?> callCmsData(String id);
  Future<AddToCartModel?> removeItemFromWishlist(String? wishListProductId);
  Future<AccountInfoModel?> callAccountDetailsApi();
  Future<NewProductsModel?> getAllProducts({
    List<Map<String, dynamic>>? filters,
  });
  Future<GetDrawerCategoriesData?> getHomeCategoriesList({
    List<Map<String, dynamic>>? filters,
  });
  Future<BaseModel?> subscribeNewsletter(String email);
}

class HomePageRepositoryImp implements HomePageRepository {
  final BazarApiService _apiService = BazarApiService();

  @override
  Future<GetDrawerCategoriesData?> getHomeCategoriesList({
    List<Map<String, dynamic>>? filters,
  }) async {
    GetDrawerCategoriesData? getDrawerCategoriesData;
    try {
      // Migration vers REST API
      final response = await _apiService.getCategories();

      if (response['success'] == true) {
        // Adapter la réponse REST vers le modèle existant
        final categories = response['data']['categories'] as List<dynamic>;

        // Créer une structure compatible avec GetDrawerCategoriesData
        getDrawerCategoriesData = GetDrawerCategoriesData.fromJson({
          'success': true,
          'data': categories
              .map(
                (category) => {
                  'id': category['id'],
                  'name': category['name'],
                  'description': category['description'],
                  'image':
                      'https://via.placeholder.com/150x150/4A7C59/FFFFFF?text=${category['name']}',
                },
              )
              .toList(),
        });
      }
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return getDrawerCategoriesData;
  }

  @override
  Future<AddToCartModel?> callAddToCartAPi(int productId, int quantity) async {
    AddToCartModel? addToCartModel;
    try {
      // Migration vers REST API
      final response = await _apiService.addToCart(
        productId.toString(),
        quantity,
      );

      if (response['success'] == true) {
        // Adapter la réponse REST vers le modèle existant
        addToCartModel = AddToCartModel.fromJson({
          'success': true,
          'message': response['message'],
          'data': {'cart_item': response['data']},
        });
      }
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return addToCartModel;
  }

  @override
  Future<AddWishListModel?> addItemToWishlist(var wishListProductId) async {
    AddWishListModel? addWishListModel;
    try {
      // Migration vers REST API
      final response = await _apiService.addToWishlist(
        wishListProductId.toString(),
      );

      if (response['success'] == true) {
        // Adapter la réponse REST vers le modèle existant
        addWishListModel = AddWishListModel.fromJson({
          'success': true,
          'message': response['message'],
          'data': response['data'],
        });
      }
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return addWishListModel;
  }

  ///Log Out Api
  @override
  Future<BaseModel?> callLogoutApi() async {
    BaseModel? response;
    try {
      response = await ApiClient().customerLogout();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return response;
  }

  @override
  Future<BaseModel?> callAddToCompareListApi(String? productId) async {
    BaseModel? baseModel;
    try {
      baseModel = await ApiClient().addToCompare(productId);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }

    return baseModel;
  }

  @override
  Future<ThemeCustomDataModel?> getThemeCustomizationData() async {
    ThemeCustomDataModel? homeSlidersData;
    try {
      homeSlidersData = await ApiClient().getThemeCustomizationData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return homeSlidersData;
  }

  @override
  Future<CartModel?> cartCountApi() async {
    CartModel? cartDetails;
    try {
      cartDetails = await ApiClient().getCartCount();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cartDetails;
  }

  @override
  Future<AddToCartModel?> removeItemFromWishlist(
    String? wishListProductId,
  ) async {
    AddToCartModel? removeFromWishlist;
    try {
      removeFromWishlist = await ApiClient().removeFromWishlist(
        wishListProductId,
      );
    } catch (error, stacktrace) {
      debugPrint("Error -->${error.toString()}");
      debugPrint("StackTrace -->${stacktrace.toString()}");
    }
    return removeFromWishlist;
  }

  @override
  Future<AccountInfoModel?> callAccountDetailsApi() async {
    AccountInfoModel? accountInfoDetails;
    try {
      accountInfoDetails = await ApiClient().getCustomerData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return accountInfoDetails;
  }

  //todo
  @override
  Future<NewProductsModel?> getAllProducts({
    List<Map<String, dynamic>>? filters,
  }) async {
    NewProductsModel? newProductsData;
    try {
      newProductsData = await ApiClient().getAllProducts(filters: filters);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return newProductsData;
  }

  @override
  Future<CmsData?> callCmsData(String id) async {
    CmsData? cmsData;
    try {
      cmsData = await ApiClient().getCmsPagesData();
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return cmsData;
  }

  @override
  Future<BaseModel?> subscribeNewsletter(String email) async {
    BaseModel? model;
    try {
      model = await ApiClient().subscribeNewsletter(email);
    } catch (error, stacktrace) {
      debugPrint("Error --> $error");
      debugPrint("StackTrace --> $stacktrace");
    }
    return model;
  }
}
