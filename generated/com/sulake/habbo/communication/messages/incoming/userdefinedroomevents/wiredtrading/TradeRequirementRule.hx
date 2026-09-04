package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 import com.sulake.core.communication.messages.IMessageDataWrapper;
  class TradeRequirementRule { static inline final MAX_NODES=256;var _nodes:Vector<TradeRequirementNode>;public function new(nodes:Vector<TradeRequirementNode>){_nodes=nodes;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementRule{var count=WiredMessageDataValidator.readCount(data,4,MAX_NODES,"TradeRequirementRule nodes");var nodes=new Vector<TradeRequirementNode>();for(i in 0...count)nodes.push(TradeRequirementNode.readFromMessage(data));return new TradeRequirementRule(nodes);}public var nodes(get,never):Vector<TradeRequirementNode>;
function  get_nodes():Vector<TradeRequirementNode>{return _nodes;}public function addToComposer(out:Array<ASAny>){out.push(_nodes.length);for (n in _nodes)n.addToComposer(out);}public function deepCopy():TradeRequirementRule{var nodes=new Vector<TradeRequirementNode>();for (n in _nodes)nodes.push(n.deepCopy());return new TradeRequirementRule(nodes);}
 }

