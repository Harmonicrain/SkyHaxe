package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetOpenPetPackageMessage;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionPetPackageEvent;
    import com.sulake.habbo.ui.widget.events._Str_3085;
    import flash.display.BitmapData;
    import flash.events.Event;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetFigureData;

     class PetPackageFurniWidgetHandler implements IRoomWidgetHandler implements  IGetImageListener 
    {
        var _isDisposed:Bool = false;
        var _container:IRoomWidgetHandlerContainer = null;
        var _objectId:Int = -1;


        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.FURNI_PET_PACKAGE_WIDGET;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetOpenPetPackageMessage.RWOPPM_OPEN_PET_PACKAGE];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetOpenPetPackageMessage = null;
            switch (k.type)
            {
                case RoomWidgetOpenPetPackageMessage.RWOPPM_OPEN_PET_PACKAGE:
                    _local_2 = Std.downcast(k , RoomWidgetOpenPetPackageMessage);
                    if (((!(this._container == null)) && (!(this._container.roomSession == null))))
                    {
                        this._container.roomSession.sendOpenPetPackageMessage(_local_2.objectId, _local_2.name);
                    }
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            return [RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_REQUESTED, RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_RESULT];
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionPetPackageEvent = null;
            var _local_3:_Str_3085 = null;
            var _local_4:BitmapData = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:String = null;
            if (k == null)
            {
                return;
            }
            if ((((!(this._container == null)) && (!(this._container.events == null))) && (!(k == null))))
            {
                switch (k.type)
                {
                    case RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_REQUESTED:
                        _local_2 = Std.downcast(k , RoomSessionPetPackageEvent);
                        this._objectId = _local_2.objectId;
                        _local_4 = this.getPetImage(_local_2.figureData);
                        _local_5 = ((_local_2.figureData == null) ? -1 : _local_2.figureData.typeId);
                        _local_3 = new _Str_3085(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_REQUESTED, this._objectId, _local_4, -1, null, _local_5);
                        this._container.events.dispatchEvent(_local_3);
                        return;
                    case RoomSessionPetPackageEvent.RSOPPE_OPEN_PET_PACKAGE_RESULT:
                        _local_2 = Std.downcast(k , RoomSessionPetPackageEvent);
                        this._objectId = _local_2.objectId;
                        _local_6 = _local_2.nameValidationStatus;
                        _local_7 = _local_2.nameValidationInfo;
                        _local_3 = new _Str_3085(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_RESULT, this._objectId, null, _local_6, _local_7, -1);
                        this._container.events.dispatchEvent(_local_3);
                        return;
                }
            }
        }

        public function update()
        {
        }

        public function dispose()
        {
            this._isDisposed = true;
            this._container = null;
            this._objectId = -1;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3= new _Str_3085(_Str_3085.RWOPPUE_OPEN_PET_PACKAGE_UPDATE_PET_IMAGE, this._objectId, _arg_2, -1, null, -1);
            this._container.events.dispatchEvent(_local_3);
        }

        public function imageFailed(k:Int)
        {
        }

        function getPetImage(k:PetFigureData):BitmapData
        {
            var _local_2:UInt = 0;
            var _local_3:UInt = 0;
            var _local_4:ImageResult = null;
            if (k != null)
            {
                _local_2 = ASCompat.parseInt(k.color, 16);
                _local_3 = 0;
                _local_4 = this._container.roomEngine.getPetImage(k.typeId, k.paletteId, ASCompat.toInt(_local_2), new Vector3d(90), 64, this, true, _local_3);
                if (_local_4 != null)
                {
                    return _local_4.data;
                }
            }
            return null;
        }
public function new(){}
    }

