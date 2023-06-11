import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:josequal/models/image_model.dart';
import 'package:josequal/services/database/DatabaseHelper.dart';
import '../../services/pexels_image_getter.dart';
import 'ImagesStates.dart';

class ImagesCubit extends Cubit<Map<String, dynamic>> {
  ImagesCubit() : super({'state': ImagesLoadingState, 'data': []});

  Future<void> getCuratedImages() async {
    emit({'state': ImagesLoadingState(), 'data': []});

    try {
      http.Response response = await http.get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=30'),
          headers: {
            HttpHeaders.authorizationHeader:
                '3KwrzI30zX1YTlNCzBclTm2dxuN8Hm2fioHZu3JXf5pG0hOjlQnDKm6V'
          });
      emit({
        'state': ImagesSuccessState(),
        'data': PexelsManager().cleanResponse(json.decode(response.body))
      });
    } catch (e) {
      print(e.toString());
      emit({'state': ImagesErrorState(), 'data': {}});
    }
  }

  Future<void> getSearchImages({required String searchTerm}) async {
    emit({'state': ImagesLoadingState(), 'data': []});

    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$searchTerm&per_page=30'),
          headers: {
            HttpHeaders.authorizationHeader:
                '3KwrzI30zX1YTlNCzBclTm2dxuN8Hm2fioHZu3JXf5pG0hOjlQnDKm6V'
          });
      emit({
        'state': ImagesSuccessState(),
        'data': PexelsManager().cleanResponse(json.decode(response.body))
      });
    } catch (e) {
      print(e.toString());
      emit({'state': ImagesErrorState(), 'data': {}});
    }
  }

  Future<void> getFavourites() async {
    List<ImageModel> images = [];

    try {
      List<Map<String, dynamic>> list = await DatabaseHelper.getImages();
      for (Map<String, dynamic> row in list) {
        images.add(ImageModel.fromDataBase(row));
      }
      emit({'state': ImagesSuccessState(), 'data': images});
    } catch (e) {
      emit({'state': ImagesErrorState(), 'data': []});
      debugPrint(e.toString());
    }
  }
}
