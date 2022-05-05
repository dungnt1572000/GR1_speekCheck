
import 'package:doan1/constant/accessTokenTest.dart';
import 'package:doan1/searching/sear_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../src/searching_service/api_search_client.dart';

class SearchingBar extends StatelessWidget {
  const SearchingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _presentLocationController = TextEditingController();
    TextEditingController _wannagoLocationController = TextEditingController();
    _presentLocationController.text = 'Your Location';
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        bool openCloseWannaGo = ref.watch(openCloseupListWannaGoProvider);
        bool openCloseCurrentLo = ref.watch(openCloseupListCurrentStartProvider);
        var searchingObject = ref.watch(SearchingObjectProvider);
        return Form(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(

                controller: _presentLocationController,
                decoration: const InputDecoration(
                  border: InputBorder.none,

                ),
                onTap: (){
                  ref.read(openCloseupListWannaGoProvider.state).update((state) => false);
                },
                onChanged: (String str){
                  Future.delayed(const Duration(milliseconds: 500),(){
                    if(str.isEmpty){
                      ref.read(openCloseupListCurrentStartProvider.state).update((state) => false);
                    }else{
                      ref.read(openCloseupListCurrentStartProvider.state).update((state) => true);
                      ref.read(SearchingObjectProvider.notifier).getSearchingObject(str);
                    }
                  });
                },
              ),
              openCloseCurrentLo?Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 350,
                  child: ListView.builder(
                    itemCount: searchingObject.features.length,
                    itemBuilder: (context, index) {
                      return  ListTile(
                        onTap: (){
                          ref.read(openCloseupListCurrentStartProvider.state).update((state) => false);
                          _presentLocationController.text = searchingObject.features[index].text!;
                        },
                        title:  Text(searchingObject.features[index].text??'Unknow'),
                        subtitle: Text(searchingObject.features[index].placeName??'Unknown',

                        ),
                      );

                    },),
                ),
              ):const SizedBox(),
              // openCloseup?Expanded(child: ListView.builder(
              //   itemCount: searchingObject.features.length,
              //   itemBuilder: (context, index) {
              //     var checkType = searchingObject.features[index];
              //       if(checkType is PlaceObject){
              //         return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
              //       }else if(checkType is PositionObject){
              //         return ListTile(title: Text(checkType.text),subtitle: Text(checkType.placeName),);
              //       }else{
              //         return  ListTile(title: const Text('NaN'),);
              //       }
              // },)):const SizedBox(),
              TextFormField(
                controller: _wannagoLocationController,
                onTap: (){
                  ref.read(openCloseupListCurrentStartProvider.state).update((state) => false);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search some where',
                    suffixIcon: IconButton(onPressed: (){
                      print('Hello word');

                      ref.read(SearchingObjectProvider.notifier).getSearchingObject(_wannagoLocationController.text);

                    }, icon: const Icon(Icons.search))
                ),
                onChanged: (String str){
                  Future.delayed(const Duration(milliseconds: 500),(){
                    if(str.isEmpty){
                      ref.read(openCloseupListWannaGoProvider.state).update((state) => false);
                    }else{
                      ref.read(openCloseupListWannaGoProvider.state).update((state) => true);
                    }
                  });
                },
              ),
              openCloseWannaGo?Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 350,
                  child: ListView.builder(
                    itemCount: searchingObject.features.length,
                    itemBuilder: (context, index) {
                        return  ListTile(
                          onTap: (){
                            ref.read(openCloseupListWannaGoProvider.state).update((state) => false);
                            _wannagoLocationController.text = searchingObject.features[index].text!;
                          },
                          title:  Text(searchingObject.features[index].text??'Unknow'),
                                    subtitle: Text(searchingObject.features[index].placeName??'Unknown',
                                    ),
                        );

                    },),
                ),
              ):const SizedBox(),
            ],
          ),
        ));
      },
    );
  }
}
