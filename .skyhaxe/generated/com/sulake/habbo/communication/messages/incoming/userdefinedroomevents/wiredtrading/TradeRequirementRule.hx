package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 import com.sulake.core.communication.messages.IMessageDataWrapper;
  class TradeRequirementRule { static inline final MAX_NODES=256;var _nodes:Vector<TradeRequirementNode>;public function new(nodes:Vector<TradeRequirementNode>){_nodes=nodes;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementRule{var i = 0;var count=WiredMessageDataValidator.readCount(data,4,MAX_NODES,"TradeRequirementRule nodes");var nodes=new Vector<TradeRequirementNode>();for(_tmp_ in 0...count){i=_tmp_;
nodes.push(TradeRequirementNode.readFromMessage(data));
};return new TradeRequirementRule(nodes);}public var nodes(get,never):Vector<TradeRequirementNode>;
public function  get_nodes():Vector<TradeRequirementNode>{return _nodes;}public function addToComposer(out:Array<ASAny>){var n:TradeRequirementNode  = null;out.push(_nodes.length);final _iter_ = _nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_){n = _tmp_;
n.addToComposer(out);
};}public function deepCopy():TradeRequirementRule{var n:TradeRequirementNode  = null;var nodes=new Vector<TradeRequirementNode>();final _iter_ = _nodes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_){n = _tmp_;
nodes.push(n.deepCopy());
};return new TradeRequirementRule(nodes);}
 }

