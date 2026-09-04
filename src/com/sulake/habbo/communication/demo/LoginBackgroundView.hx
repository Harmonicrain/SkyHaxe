package com.sulake.habbo.communication.demo;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;

/**
 * HTML5 counterpart of HabboAir's login-background layer.
 *
 * The artwork and placement rules remain owned by the clean client: the background covers the
 * stage, the foreground keeps its authored size when possible and sits at bottom-right with the
 * same 82px vertical offset. Keeping this wrapper separate marks the platform boundary while the
 * two source images continue to flow directly from habbo-client-clean at build time.
 */
class LoginBackgroundView extends Sprite {
    public static inline var FOREGROUND_OFFSET_Y:Int = 82;

    final backgroundBitmap:Bitmap;
    final foregroundBitmap:Bitmap;

    public function new(background:BitmapData, foreground:BitmapData) {
        super();
        mouseEnabled = false;
        mouseChildren = false;
        backgroundBitmap = new Bitmap(background, PixelSnapping.AUTO, true);
        backgroundBitmap.name = "login_background";
        foregroundBitmap = new Bitmap(foreground, PixelSnapping.AUTO, true);
        foregroundBitmap.name = "login_foreground";
        addChild(backgroundBitmap);
        addChild(foregroundBitmap);
    }

    public function resizeTo(stageWidth:Float, stageHeight:Float):Void {
        var background = backgroundBitmap.bitmapData;
        var coverScale = Math.max(stageWidth / background.width, stageHeight / background.height);
        backgroundBitmap.width = background.width * coverScale;
        backgroundBitmap.height = background.height * coverScale;
        backgroundBitmap.x = Math.round((stageWidth - backgroundBitmap.width) / 2);
        backgroundBitmap.y = Math.round((stageHeight - backgroundBitmap.height) / 2);

        var foreground = foregroundBitmap.bitmapData;
        var foregroundScale = Math.min(1, Math.min(stageWidth / foreground.width,
            stageHeight / foreground.height));
        foregroundBitmap.width = Math.round(foreground.width * foregroundScale);
        foregroundBitmap.height = Math.round(foreground.height * foregroundScale);
        foregroundBitmap.x = Math.round(stageWidth - foregroundBitmap.width);
        foregroundBitmap.y = Math.round(stageHeight - foregroundBitmap.height
            + FOREGROUND_OFFSET_Y);
    }

    public function describe():Dynamic {
        return {
            background: {
                width: backgroundBitmap.bitmapData.width,
                height: backgroundBitmap.bitmapData.height,
                x: backgroundBitmap.x,
                y: backgroundBitmap.y,
                displayWidth: backgroundBitmap.width,
                displayHeight: backgroundBitmap.height
            },
            foreground: {
                width: foregroundBitmap.bitmapData.width,
                height: foregroundBitmap.bitmapData.height,
                x: foregroundBitmap.x,
                y: foregroundBitmap.y,
                displayWidth: foregroundBitmap.width,
                displayHeight: foregroundBitmap.height
            }
        };
    }
}
