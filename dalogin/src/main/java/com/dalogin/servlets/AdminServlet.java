package com.dalogin.servlets;
/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com
 * @Year: 2015
 */

import com.dalogin.SQLAccess;
import com.dalogin.client.ServiceClient;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.ws.rs.core.Response;
import org.apache.log4j.Logger;
import org.json.JSONObject;

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
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(urlPatterns = "/admin", name = "AdminServlet")
public class AdminServlet extends HttpServlet implements Serializable {
    private static final long serialVersionUID = 5570497466931245289L;
    protected volatile static HttpSession session = null;
    protected volatile static String sessionId = null;
    protected volatile static String sessionId_ = null;
    private volatile static String user = null;
    private volatile static String token_;
    private volatile static String Response = null;
    private volatile static String deviceId;
    private volatile static List<String> token2;
    private static Logger log = Logger.getLogger(Logger.class.getName());
    private static volatile ConcurrentHashMap<String, HttpSession> activeUsers;
    private static volatile Cookie[] cookies;

    public void init() throws ServletException {
        // Do required initialization
    }

    /**
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    public synchronized void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
        // Return current session
        session = request.getSession(false);
        cookies = request.getCookies();
        // Get JSESSION url parameter. By now it is just a logging..
        sessionId = request.getParameter("JSESSIONID");
        if (sessionId == null) {
            sessionId = session.getId();
        }
        log.info("SessionId from request parameter: " + sessionId);
        try {
            performTask(request, response);
        } catch (CertificateException | KeyStoreException | NoSuchAlgorithmException | KeyManagementException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    private synchronized void performTask(HttpServletRequest request, HttpServletResponse response) throws ServletException,
            IOException, CertificateException, KeyStoreException, NoSuchAlgorithmException, KeyManagementException {
        HashMap<String, String> error = new HashMap<>();
        //session = request.getSession();
        ServletContext context = session.getServletContext();
        //log.info("Session ID check: "+ session.getId());
        try {
            // Get deviceId from session
            deviceId = (String) session.getAttribute("deviceId");
            // Get user from session
            user = (String) session.getAttribute("user");
            // Get token1 from dB. token1 will be used to make a user related API call
            token_ = SQLAccess.token(deviceId, context);
            // Get voucher activation method
            Response = SQLAccess.isActivated(user, context);
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            response.setStatus(502);
            // put some value pairs into the JSON object .
            error.put("SQLAccess", "failed");
            error.put("Success", "false");
        }
        if (deviceId == null || user == null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            response.setStatus(502);
            // put some value pairs into the JSON object .
            error.put("deviceId", deviceId);
            error.put("user", user);
        }
        // else if voucher needs activation
        if (Response == "S") {
            try {
                token2 = SQLAccess.token2(deviceId, context);
            } catch (Exception e) {
                response.setContentType("application/json");
                response.setCharacterEncoding("utf-8");
                response.setStatus(502);
                log.info(e.getMessage());
                PrintWriter out = response.getWriter();
                //create Json Object
                JSONObject json = new JSONObject();
                // put some value pairs into the JSON object .
                error.put("Error Message:", "User does not bear valid paramteres.");
                json.put("Error Details", error);
                // finally output the json string
                out.print(json.toString());
                out.flush();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            response.setHeader("Response", "S");
            response.setStatus(300);
            response.addHeader("X-Token", token2.get(0));
            //create Json Object
            JSONObject json = new JSONObject();
            // put some value pairs into the JSON object .
            error.put("Activation", "false");
            error.put("Success", "false");
            error.put("User", user);
            error.put("deviceId", deviceId);
            json.put("Error Details", error);
            log.info(request.getContentType());
            token2 = new ArrayList<String>();
            try {
                token2 = SQLAccess.token2((String) session.getAttribute("deviceId"), context);
            } catch (Exception e) {
                throw new ServletException(e.getCause().toString());
            }
            Map<String, String> attributes = new HashMap<>();
            attributes.put("user", user);
            attributes.put("token2", token2.get(0));
            attributes.put("Error Details", json.toString());
            attributes.put("TIME_", String.valueOf(session.getCreationTime()));
            String webApiContext = context.getInitParameter("webApiContext");
            String serviceUrl = "https://milo.crabdance.com";
            ServiceClient client = new ServiceClient(serviceUrl + webApiContext, request, attributes);
            Response apiResponse = client.callGetData(user.trim().toString(), token_.trim().toString());
            String responseBody = apiResponse.readEntity(String.class);
            client.close();
            PrintWriter out = response.getWriter();
            // finally output the json string
            out.print(responseBody.toString());
            out.flush();
        }
        // Get user entity using API GET method, with user and token as request params
        else if (token_ != null && session != null && deviceId != null && user != null /*&& request.isRequestedSessionIdValid()*/) {
            token2 = new ArrayList<String>();
            try {
                token2 = SQLAccess.token2((String) session.getAttribute("deviceId"), context);
            } catch (Exception e) {
                throw new ServletException(e.getCause().toString());
            }
            Map<String, String> attributes = new HashMap<>();
            attributes.put("user", user);
            attributes.put("token2", token2.get(0));
            attributes.put("TIME_", String.valueOf(session.getCreationTime()));
            String webApiContext = context.getInitParameter("webApiContext");
            String serviceUrl = "https://milo.crabdance.com";
            ServiceClient client = new ServiceClient(serviceUrl + webApiContext, request, attributes);
            Response apiResponse = client.callGetData(user.trim().toString(), token_.trim().toString());
            String responseBody = apiResponse.readEntity(String.class);
            client.close();
            PrintWriter out = response.getWriter();
            // finally output the json string
            out.print(responseBody.toString());
            out.flush();
        } else {
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            response.setStatus(502);
            PrintWriter out = response.getWriter();
            //create Json Object
            JSONObject json = new JSONObject();
            // put some value pairs into the JSON object .
            error.put("Error Message:", "User does not bear valid paramteres.");
            json.put("Error Details", error);
            // finally output the json string
            out.print(json.toString());
            out.flush();
        }
    }

    @SuppressWarnings("unchecked")
    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOExcetion
     */
    public synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the response message's MIME type
        response.setContentType("text/html;charset=UTF-8");
        // Return current session
        session = request.getSession(false);
        cookies = request.getCookies();
        // Get JSESSION url parameter. By now it is just a logging..
        sessionId = request.getParameter("JSESSIONID");
        if (sessionId == null) {
            sessionId = session.getId();
        }
        log.info("SessionId from request parameter: " + sessionId);
        try {
            performTask(request, response);
        } catch (CertificateException | KeyStoreException | NoSuchAlgorithmException | KeyManagementException e) {
            throw new RuntimeException(e);
        }
    }

    public void destroy() {
        // do nothing.
    }
}