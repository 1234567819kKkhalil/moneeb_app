part of media_utils;

const String regularStackName = "regularStack";

@lazySingleton
class VideoControllersManager {
  //PlayerStack
  //By default there is a [regularStack] for regular controllers like in timeline, ..etc
  //But in reels, we add a new stack for every reels page
  final Map<String, List<IVideoViewModel>> _playersStack = {
    regularStackName : [],
  };

  //Get total players that have a video controller
  int get totalActivePlayersLength => _playersStack.values.fold(0, (total, list) => total + list.where((e) => e.isHaveInitializedController,).length);

  //Max video controller the memory can handle
  bool get isExceededMaxVideoPlayersLimit {
    return false;
   /* final int length = totalActivePlayersLength;

    print("TOTAL LENNN: $length");
    switch(DeviceSpecsUtils.instance.getMemoryCategory()){
      case DeviceCategory.poor:
        if(length >= 2){
          return true;
        }
      case DeviceCategory.veryLow:
        if(length >= 3){
          return true;
        }

      case DeviceCategory.low:
        if(length >= 4){
          return true;
        }

      case DeviceCategory.medium:
        if(length > 6){
          return true;
        }

      case DeviceCategory.high:
        if(length > 9){
          return true;
        }

      case DeviceCategory.veryHigh:
      case null:
      if(length > 12){
        return true;
      }
    }

    return false;*/
  }

  T registerViewModel<T extends IVideoViewModel>({
    required bool increaseListenersCount,
    required T videoModel
  }){
    T? videoVideoPlayer = _playersStack[videoModel.stackId]?.firstWhereOrNull((e) => e.attachment.id == videoModel.attachment.id && e is T) as T?;

    //register the video model
    if(videoVideoPlayer == null){
      videoVideoPlayer = videoModel;

      //set new stack if not exists
      if(_playersStack[videoModel.stackId] == null){
        _playersStack[videoModel.stackId] = [];
      }

      _playersStack[videoModel.stackId]?.add(videoModel);

      log(_playersStack.entries.map((e) => e.toString(),).toString());
    }

    if(increaseListenersCount){
      videoVideoPlayer.increaseListenersCount();
    }

    return videoVideoPlayer;
  }

  bool disposeModelIfCan({
    required String attachmentId,
    required String? stackId,
    bool forceDispose = false,
    bool disposeStateController = false,
  }){
    bool isRemoved = false;

    test(IVideoViewModel element){
      if(element.attachment.id == attachmentId){
        isRemoved = element.disposeIfCan(
          forceDispose: forceDispose,
            removeFromStackOnDispose: disposeStateController
        );
        return isRemoved;
      }

      return false;
    }

    if(stackId == null){
      String? keyToBeRemove;

      _playersStack.forEach((key, value) {
        value.removeWhere(test);

        if(value.isEmpty){
          keyToBeRemove = key;
        }
      },);

      if(keyToBeRemove != null){
        _playersStack.remove(keyToBeRemove);
      }
    }else{
      _playersStack[stackId]?.removeWhere(test);

      if(_playersStack[stackId]?.isEmpty ?? true){
        _playersStack.remove(stackId);
      }
    }

    print("VIDEO VIEW DISPOSED");

    return isRemoved;
  }

  void freeControllerPlaceIfNeeded({required String? ignoreAttachmentId,String? byPassStack}){
    if(!isExceededMaxVideoPlayersLimit) return;

    //IVideoViewModel? randomActiveModel;

    for(var entry in _playersStack.entries){
      if(entry.key == byPassStack) {
        continue;
      }

      //Iterate on stack items
      for(var item in entry.value){
        if(item.isHaveInitializedController && item.attachment.id != ignoreAttachmentId){
          /*if(item is ReelVideoViewModel && item.isActive){
            randomActiveModel ??= item;
          } else {*/
            item.disposeIfCan(
              forceDispose: true,
              removeFromStackOnDispose: false,
            );

            return;
         // }
        }
      }
    }

  /*  if(randomActiveModel != null){
      randomActiveModel.disposeIfCan(
        forceDispose: true,
        disposeStateController: false,
      );
    }*/
  }

  IVideoViewModel? findViewModel(String attachmentId) {
    for(var stack in _playersStack.values){
      var item = stack.firstWhereOrNull((element) => element.attachment.id == attachmentId);
      if(item != null){
        return item;
      }
    }

    return null;
  }

  void removeModelFromStack({
    required String attachmentId,
    required String? stackId,
  }){
    if(stackId == null){
      String? keyToBeRemove;

      _playersStack.forEach((key, value) {
        value.removeWhere((element) => element.attachment.id == attachmentId,);

        if(value.isEmpty){
          keyToBeRemove = key;
        }
      },);

      if(keyToBeRemove != null){
        _playersStack.remove(keyToBeRemove);
      }
    }else{
      _playersStack[stackId]?.removeWhere((element) => element.attachment.id == attachmentId,);
      if(_playersStack[stackId]?.isEmpty ?? true){
        _playersStack.remove(stackId);
      }
    }

    log("VIDEO VIEW REMOVED FROM STACK");
  }

  void pauseAllStack(String stackName, {String? exceptAttachmentId}) {
    if(_playersStack.containsKey(stackName)){
      for(var player in _playersStack[stackName]!){
        if(player.attachment.id == exceptAttachmentId){
          continue;
        }

        player.pause();
      }
    }
  }

  void disposeAllStackElements(String stackId){
    _playersStack[stackId]?.removeWhere((element) {
      final isDisposed = element.disposeIfCan(forceDispose: true, removeFromStackOnDispose: true);
      return isDisposed;
    },);
  }
}