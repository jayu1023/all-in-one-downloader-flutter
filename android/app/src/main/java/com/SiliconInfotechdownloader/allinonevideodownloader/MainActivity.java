package com.SiliconInfotechdownloader.allinonevideodownloader;

import android.net.Uri;
import android.os.AsyncTask;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.concurrent.ExecutionException;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "heartbeat.fritz.ai/native".toString();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("facebookLink")) {

                        String link = getFacebookLink(Uri.parse(call.argument("hello").toString()));

                        if (link != null) {
                            result.success(link);
                        } else {
                            result.success("");
                        }
                        // new Handler().postDelayed(new Runnable() {
                        // @Override
                        // public void run() {
                        // result.success("hello");

                        // }
                        // }, 2000);
                        // boolean deviceStatus = getDeviceStatus();

                        // String myMessage = Boolean.toString(deviceStatus);

                    } else if (call.method.equals("testinglink")
                    )

                    {
                        String link = getTestingLink(Uri.parse(call.argument("hello").toString()));
//                        System.out.println(link);
                        if(link!=null)
                        {
                        result.success(link);

                        }else{
                            result.success("");
                        }

                    }else if (call.method.equals("shareChatLink"))
                    {
                        try{
  System.out.println("calling method");

                        String link =getShareChatLink(Uri.parse(call.argument("hello").toString()));

                        System.out.println("hehvfvyf->>>"+link);
                        if(link!=null)
                        {
                        result.success(link);

                        }else{
                            result.success("");
                        }
                        }catch (IllegalArgumentException e)
                        {
                                result.success(e.toString());
                        }
                      
                    }

                });
    }

String getShareChatLink(Uri x){
    String result="";
    String type,previewlink;
    try{bgClass bgtask=new bgClass();
            Document dc=bgtask.execute(x.toString()).get();
            
                      result=dc.select("meta[property=\"og:image\"]").last().attr("content");
                        type=dc.select("meta[property=\"da:type\"]").last().attr("content");
                        previewlink=dc.select("meta[property=\"da:branch_io\"]").last().attr("content");
            if(result.contains("cdn-cf.sharechat.com")){
                String[] temp;
                String[] name;
                String name2,duplicateResult;

                temp=result.split("/");
                duplicateResult=temp[0]+"//"+temp[2]+"/";
                name=temp[temp.length-1].split("_");
                name2=duplicateResult+name[0]+"_"+name[1]+"_"+name[2];
                System.out.println("type is:--"+type);
                if(type.contains("video")){
                          result=


                    name2+".mp4"+"&"+previewlink;
                }else{
                    result=name2+".jpg"+"&"+previewlink;
                }
      
            }
        System.out.println("=>>>>>>link is here"+result);
            return result;
    }catch (Exception e)
    {
        return e.toString();
    }

}
    String getTestingLink(Uri x)
    {
        String result="";
        try
        {
            bgClass bgtask=new bgClass();
            Document dc=bgtask.execute("https://www.roposo.com/story/aaa70fbf-595a-4587-a7f5-6576494a4732").get();
//            result=dc.select("meta[property=\"og:video:source_url\"]").last().attr("content");
//            result=dc.select("body").toString();
           Elements elements= dc.getElementsByTag("body").get(0).getElementById("appHolder").getAllElements().last().getAllElements();
//           Log.v("TAG",elements.get(0).toString());
           System.out.println("##$%$#%$%$%^#$%^$%^"+elements.outerHtml());
            return elements.get(0).toString();
        }catch (Exception e)
        {
            return e.getMessage();
        }
    }
    ///
    /// [getFacebookLink]get Facebook Link
    ///
  String getFacebookLink(Uri x) {
        String result="";
        try {
            bgClass bgtask=new bgClass();
            Document dc=bgtask.execute(x.toString()).get();
            result=dc.select("meta[property=\"og:video\"]").last().attr("content");
            return result;
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return result;
    }

    final class bgClass extends AsyncTask<String, Void, Document> {
        Document fbdoc;
        String error = "";

        @Override
        protected Document doInBackground(String... strings) {
            try {
                fbdoc = Jsoup.connect(strings[0]).get();
//                videoUrl=  fbdoc.select("meta[property=\"og:video\"]").last().attr("content");

            } catch (IOException e) {

                error = e.getMessage().toString();
                e.printStackTrace();
            }
            return fbdoc;
        }
    }
}
