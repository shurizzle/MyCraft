// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) braces deadcode 

package net.minecraft.src;

import java.net.HttpURLConnection;
import java.net.URL;
import net.minecraft.client.Minecraft;

// Referenced classes of package net.minecraft.src:
//            Session

public class ThreadCheckHasPaid extends Thread
{

    public ThreadCheckHasPaid(Minecraft minecraft)
    {
        mc = minecraft;
    }

    public void run()
    {
        try
        {
            HttpURLConnection httpurlconnection = (HttpURLConnection)(new URL((new StringBuilder()).append(mc.gameSettings.has_paid_url).append("?name=").append(mc.session.username).append("&session=").append(mc.session.sessionId).toString())).openConnection();
            httpurlconnection.connect();
            if(httpurlconnection.getResponseCode() == 400 && this == null)
            {
                Minecraft.hasPaidCheckTime = System.currentTimeMillis();
            }
            httpurlconnection.disconnect();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
    }

    final Minecraft mc; /* synthetic field */
}
