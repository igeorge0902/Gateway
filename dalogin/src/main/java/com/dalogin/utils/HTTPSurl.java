package com.dalogin.utils;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
 
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.json.JSONObject;

import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;
 
public class HTTPSurl {
    public static void main(String[] args) throws Exception {
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] {new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
                public void checkClientTrusted(X509Certificate[] certs, String authType) {
                }
                public void checkServerTrusted(X509Certificate[] certs, String authType) {
                }
            }
        };
 
        // Install the all-trusting trust manager
        SSLContext sc = SSLContext.getInstance("SSL");
        sc.init(null, trustAllCerts, new java.security.SecureRandom());
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
 
        // Create all-trusting host name verifier
        HostnameVerifier allHostsValid = new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        };
 
        // Install the all-trusting host verifier
        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
 
        URL url = new URL("https://milo.crabdance.com/mbook-1/rest/user/GI/84089298-436f-11e9-8bce-550d43290499");
    	HttpURLConnection con = (HttpURLConnection) url.openConnection();
    	con.setRequestMethod("GET");
    	con.setRequestProperty("Content-Type", "application/json");
    	con.setRequestProperty("Ciphertext", "0.6418053727986341"); 
    	
    	con.setConnectTimeout(50000);
    	con.setReadTimeout(50000);
        
        if (con.getResponseCode() == 404) {
        	Reader reader = new InputStreamReader(con.getErrorStream());
            while (true) {
                int ch = reader.read();
                if (ch==-1) {
                    break;
                }
                System.out.print((char)ch);
            }
        }
        
        if (con.getResponseCode() == 412) {
        	Reader reader = new InputStreamReader(con.getErrorStream());
            while (true) {
                int ch = reader.read();
                if (ch==-1) {
                    break;
                }
                
                System.out.print((char)ch);

            }

        }
        
        if (con.getResponseCode() == 200) {
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
            System.out.print(response.toString());

        }
    }
}