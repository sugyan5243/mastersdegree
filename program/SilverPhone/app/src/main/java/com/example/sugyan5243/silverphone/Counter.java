package com.example.sugyan5243.silverphone;

import android.os.AsyncTask;
import android.view.MotionEvent;

public class Counter extends AsyncTask<Void, Void, Void> {
    private static final int INTERVAL = 1;    //0.2秒
    private MainView view;

    public Counter(MainView view){
        this.view = view;
    }

    @Override
    protected Void doInBackground(Void... params){
        while(true){
            if(isCancelled()){
                return null;
            }
            try{
                Thread.sleep(INTERVAL);
            }catch(InterruptedException e){
                return null;
            }
            publishProgress(null);
        }
    }

    @Override
    protected void onProgressUpdate(Void... values){
        view.actions();
    }

}
