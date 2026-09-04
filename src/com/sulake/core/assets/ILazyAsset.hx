package com.sulake.core.assets;

interface ILazyAsset extends IAsset {
    public function prepareLazyContent():Void;
}
