package com.example.sugyan5243.silverphone;

import android.content.Context;
import android.graphics.Canvas;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;

import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Paint;
import android.view.WindowManager;

import static android.content.Context.WINDOW_SERVICE;


public class MainView extends View{
    Paint paint = new Paint();
    int pointX = 200;
    int pointY = 400;
    public int ac = 0;
    Counter cnter;
    MainActivity ma = null;
    String fonts = "";
    String tarako1 = "";
    String tarako2 = "";
    String tarako3 = "";
    String tarako4 = "";
    String tarako5 = "";
    String action = "NONE";
    int sazae1 = 0;
    int sazae2 = 0;
    int sazae3 = 0;
    int sazae4 = 0;
    int sazae5 = 0;


    //画像読み込み
    Resources res = this.getContext().getResources();
    Bitmap point = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.bluecircle),100,100,false);

    Bitmap up = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.up),100,100,false);
    Bitmap down = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.down),100,100,false);
    Bitmap left = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.left),100,100,false);
    Bitmap right = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.right),100,100,false);
    Bitmap touch = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.touch),100,100,false);

    Bitmap modokiBegin = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.buttonbegin),200,100,false);
    Bitmap modokiRead = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.buttonread),200,100,false);
    Bitmap modokiEnd = Bitmap.createScaledBitmap(BitmapFactory.decodeResource(res, R.drawable.buttonend),200,100,false);

    //ディスプレイのサイズ読み込み
    WindowManager wm = (WindowManager)getContext().getSystemService(WINDOW_SERVICE);
    // ディスプレイのインスタンス生成
    Display disp = wm.getDefaultDisplay();
    int width = disp.getWidth();
    int height = disp.getHeight();

    public MainView(MainActivity activity){
        super(activity);
        this.ma = activity;
    }

    //描画処理
    @Override
    public void onDraw(Canvas c){
        c.drawBitmap(up, 500, 1100, paint);
        c.drawBitmap(down, 500, 1400, paint);
        c.drawBitmap(left, 500-200, 1250, paint);
        c.drawBitmap(right, 500+200, 1250, paint);
        c.drawBitmap(touch, 500, 1250, paint);


//        pointX += testnum;
        //テスト的な移動
//        if(pointX < 0 || 480 < pointX ) testnum *= -1;
        c.drawText(fonts,0,500,paint);

        //文字
        paint.setTextSize(70);
        c.drawText(action,50,150,paint);
        paint.setTextSize(50);
        c.drawText("X: " + pointX + "Y: " + pointY,30,300,paint);
        c.drawText(tarako1 + " "+ tarako2 + " " + tarako3 + " " + tarako4+ " " +tarako5,0,400,paint);

        c.drawBitmap(modokiBegin,400,100,paint);
        c.drawBitmap(modokiRead,600,100,paint);
        c.drawBitmap(modokiEnd,800,100,paint);
        c.drawBitmap(point, pointX, pointY, paint);

        //ループ処理(onDrawを実行)
        invalidate();
    }

    public void actions(){
        action="";
        switch(ac){
            case 1:
                action = "UP";
                pointY--;
                break;
            case 2:
                action = "DOWN";
                pointY++;
                break;
            case 3:
                action = "LEFT";
                pointX--;
                break;
            case 4:
                action = "RIGHT";
                pointX++;
                break;
            case 5:
                action = "TOUCH";
                break;
            default:
                action = "NONE";
                break;
        }
        Log.v("Now", action);
    }

    //数字調査
    public boolean isNumber(String num) {
        try {
            Integer.parseInt(num);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    //タッチ処理
    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        int cx = (int)ev.getX();
        int cy = (int)ev.getY();
        String action = "";
        cnter = new Counter(this);

        switch(ev.getAction() & MotionEvent.ACTION_MASK) {
            case MotionEvent.ACTION_DOWN:
                if(cy > 1000) {

                    //上下左右&丸ボタンについて
                    if ((width / 2 <= cx && cx <= width / 2 + 100) && (1100 <= cy && cy <= 1200)) {
                        ac = 1;
                    } else if ((width / 2 <= cx && cx <= width / 2 + 100) && (1400 <= cy && cy <= 1400 + 100)) {
                        ac = 2;
                    } else if ((width / 2 - 200 <= cx && cx <= width / 2 - 100) && (1250 <= cy && cy <= 1250 + 100)) {
                        ac = 3;
                    } else if ((width / 2 + 200 <= cx && cx <= width / 2 + 300) && (1250 <= cy && cy <= 1250 + 100)) {
                        ac = 4;
                    } else if ((width / 2 <= cx && cx <= width / 2 + 100) && (1250 <= cy && cy <= 1250 + 100)) {
                        ac = 5;
                    }
                    action = "DOWN";
                    cnter.execute();
                }else{

                    //FTDriverのボタンについて
                    if((400 <= cx && cx < 600)&&(100 <= cy && cy <= 200)){
                        ma.onBeginClick(this);
                    }else if((600 <= cx && cx < 800)&&(100 <= cy && cy <= 200)){
                        fonts = ma.onReadClick(this);

                        //Arduinoから取得した値を処理
                        String[] fonts_bara = fonts.split(",", 0);


                        for(int i = 0; i < fonts_bara.length; i++){
                            if(isNumber(fonts_bara[i])){
                                if(Integer.parseInt(fonts_bara[i]) > 100){
                                    ac = i+1;
                                    cnter.execute();
                                }
                            }
                        }


                    }else if((800 <= cx && cx < 1000)&&(100 <= cy && cy <= 200)){
                        ma.onEndClick(this);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                ac = 10000;
                action = "UP";
                cnter.cancel(true);
                break;
            default:
                action = "NONE";
                break;
        }
        Log.v("Touch", action + " x=" + cx + ", y=" + cy + "ac="+ac);
       // invalidate();
        return true;
    }
}
