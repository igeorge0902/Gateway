package com.dalogin.servlets;

import com.dalogin.SQLAccess;
import com.dalogin.client.ServiceClient;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.ws.rs.core.Response;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/GetAllPurchases", name = "GetAllPurchases")
public class GetAllPurchases extends HttpServlet implements Serializable {
    private static final long serialVersionUID = 2152364900906190486L;
    protected volatile static HttpSession session = null;
    protected volatile static String sessionId = null;
    private static Logger log = Logger.getLogger(Logger.class.getName());
    private static volatile Cookie[] cookies;
    private static volatile List<String> token2;
    private static volatile String uuid;

    public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
        // Return current session
        session = request.getSession();
        cookies = request.getCookies();
        // Get JSESSION url parameter. By now it is just a logging..
        sessionId = request.getParameter("JSESSIONID");
        if (sessionId == null) {
            sessionId = session.getId();
        }
        ServletContext context = request.getServletContext();
        String webApi2Context = context.getInitParameter("webApi2Context");
        String webApi2ContextUrl = context.getInitParameter("webApi2ContextUrl");
        ServletContext otherContext = getServletContext().getContext(webApi2Context);
        token2 = new ArrayList<String>();
        try {
            token2 = SQLAccess.token2((String) session.getAttribute("deviceId"), context);
            uuid = SQLAccess.uuid((String) session.getAttribute("user"), context);
        } catch (Exception e) {
            throw new ServletException(e.getCause().toString());
        }
        Map<String, String> attributes = new HashMap<>();
        attributes.put("uuid", uuid);
        attributes.put("token2", token2.get(0));
        attributes.put("TIME_", String.valueOf(session.getCreationTime()));
        String serviceUrl = "https://milo.crabdance.com";
        ServiceClient client = null;
        try {
            client = new ServiceClient(serviceUrl + "/mbooks-1", request, attributes);
        } catch (CertificateException | KeyStoreException | NoSuchAlgorithmException | KeyManagementException e) {
            throw new RuntimeException(e);
        }
        Response apiResponse = client.callGetPurchases();
        String responseBody = apiResponse.readEntity(String.class);
        client.close();
        PrintWriter out = response.getWriter();
        // finally output the json string
        out.print(responseBody.toString());
        out.flush();
    }
}
