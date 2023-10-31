import 'package:flutter/material.dart';
import 'package:flutter_app/layout/shop_app/ShopLayout.dart';
import 'package:flutter_app/layout/shop_app/states.dart';
import 'package:flutter_app/models/shop_app/shop_categories_model.dart';
import 'package:flutter_app/models/shop_app/shop_layout_model.dart';
import 'package:flutter_app/models/shop_app/shop_login_model.dart';
import 'package:flutter_app/models/shop_app/shop_register_model.dart';
import 'package:flutter_app/modules/shop_app/category/category.dart';
import 'package:flutter_app/modules/shop_app/favorites/favorites.dart';
import 'package:flutter_app/modules/shop_app/products/products.dart';
import 'package:flutter_app/modules/shop_app/settings/settings.dart';
import 'package:flutter_app/shared/network/endpoints.dart';
import 'package:flutter_app/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  List<Widget> shopScreens = [
    const ShopProductScreen(),
    const ShopCategoryScreen(),
    const ShopFavoriteScreen(),
    ShopSettingScreen(),
  ];

  int currentIndex = 0;

  void changeIndex(int index){
    currentIndex = index;

    emit(ShopChangeBottomNavBarState());
  }

  ShopLayoutModel? shopLayoutModel;
  void shopHomeData(){
   emit(ShopHomeLoadingState());

   DioHelper.getData(
     url: HOME,
   ).then((value){
     shopLayoutModel = ShopLayoutModel.fromJson(value.data);

     emit(ShopHomeSuccessState());
   }).catchError((error){
      emit(ShopHomeErrorState());
   });
  }

  ShopLoginModel? shopProfileModel;
  void getUserProfile(){
    emit(ShopProfileLoadingState());

    DioHelper.getData(
      url: PROFILE,
    ).then((value){
      shopProfileModel = ShopLoginModel.fromJson(value.data);

      emit(ShopProfileSuccessState());
    }).catchError((error){
      emit(ShopProfileErrorState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories(){
    emit(ShopCategoriesLoadingState());

    DioHelper.getData(
      url: CATEGORIES,
    ).then((value){
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopCategoriesSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopCategoriesErrorState());
    });
  }
}