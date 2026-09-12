package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
 import com.sulake.core.communication.messages.IMessageDataWrapper; import com.sulake.core.communication.util.Byte;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
  class TradeRequirementNode { public static inline final TYPE_COIN=0;public static inline final TYPE_FURNI=1;var _type:Int = 0;var _amount:Int = 0;var _itemType:ChestItemType;
  public function new(type:Int,amount:Int,itemType:ChestItemType=null){this._type=type;this._amount=amount;this._itemType=type==TYPE_FURNI?itemType:null;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementNode{WiredMessageDataValidator.requireBytes(data,5,"TradeRequirementNode");var type=data.readByte();var amount=data.readInteger();return new TradeRequirementNode(type,amount,type==TYPE_FURNI?ChestItemType.readFromMessage(data):null);}
  public var type(get,never):Int;
public function  get_type():Int{return _type;}public var amount(get,never):Int;
public function  get_amount():Int{return _amount;}public var itemType(get,never):ChestItemType;
public function  get_itemType():ChestItemType{return _itemType;}public function addToComposer(out:Array<ASAny>){ASCompat.ASArray.pushMultiple(out, new Byte(_type),_amount);if(_type==TYPE_FURNI)_itemType.addToComposer(out);}public function deepCopy():TradeRequirementNode{return new TradeRequirementNode(_type,_amount,_itemType);}
 }

