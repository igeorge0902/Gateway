package com.dalogin;
/**
 * @author George Gaspar
 * @email: igeorge1982@gmail.com
 * @Year: 2015
 */

import jakarta.servlet.ServletContext;
import org.apache.commons.io.IOUtils;
import org.json.JSONObject;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class SQLAccess {
    /**
     *
     */
    public static volatile String hash;
    /**
     *
     */
    public static volatile String token;
    /**
     *
     */
    public static volatile String uuid;
    /**
     *
     */
    public static volatile String time;
    /**
     *
     */
    public static volatile String forgot_psw_token;
    /**
     *
     */
    public static volatile List<String> forgot_psw_confirmationCode;
    /**
     *
     */
    public static volatile String forgotRequestToken;
    /**
     *
     */
    public static volatile String forgotRequestTime;
    /**
     *
     */
    private static volatile Connection connect = null;
    /**
     *
     */
    private static volatile PreparedStatement preparedStatement = null;
    /**
     *
     */
    private volatile static UUID idOne;
    /**
     *
     */
    private static volatile String email;
    /**
     *
     */
    private static volatile List<String> list;
    /**
     *
     */
    private static volatile List<String> list_;
    /**
     *
     */
    private static volatile int isActivated;
    /**
     *
     */
    private static volatile String Response = null;
    /**
     *
     */
    private static volatile ResultSet rs;
    /**
     *
     */
    private static volatile CallableStatement callableStatement = null;
    /**
     *
     */
    private static volatile CallableStatement callableStatement_ = null;

    /**
     *
     * @return
     */
    public synchronized final static UUID uuId() {
        if (idOne == null) {
            SQLAccess.idOne = UUID.randomUUID();
        }
        return idOne;
    }

    /**
     *
     * @param context
     * @return
     * @throws ClassNotFoundException
     * @throws SQLException
     */
    public synchronized static Connection connect(ServletContext context) throws ClassNotFoundException, SQLException {
        if (connect == null) {
            DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
            connect = dbManager.getConnection();
        }
        return connect;
    }

    /**
     * Inserts user and password.
     *
     * @param pass
     * @param user
     * @param email
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static String new_hash(String pass, String user, String email, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        Reader readerP = null;
        Reader readerU = null;
        Reader readerE = null;
        try {
            connect = dbManager.getConnection();
            String sql = "insert into  login.logins values (default, ?, ?, default, ?, default)";
            InputStream ps = IOUtils.toInputStream(pass, "UTF-8");
            readerP = new BufferedReader(new InputStreamReader(ps));
            InputStream us = IOUtils.toInputStream(user, "UTF-8");
            readerU = new BufferedReader(new InputStreamReader(us));
            InputStream es = IOUtils.toInputStream(email, "UTF-8");
            readerE = new BufferedReader(new InputStreamReader(es));
            preparedStatement = connect.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setCharacterStream(1, readerP);
            preparedStatement.setCharacterStream(2, readerU);
            preparedStatement.setCharacterStream(3, readerE);
            preparedStatement.executeUpdate();
            preparedStatement.closeOnCompletion();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
            return SQLAccess.jsonSQLError(ex).toString();
        } finally {
            readerP.close();
            readerU.close();
            readerE.close();
            dbManager.closeConnection();
        }
        return "I";
    }

    /**
     * Resets password.
     *
     * @param pass
     * @param email
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean change_hash(String pass, String email, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        Reader readerP = null;
        Reader readerE = null;
        try {
            connect = dbManager.getConnection();
            InputStream ps = IOUtils.toInputStream(pass, "UTF-8");
            readerP = new BufferedReader(new InputStreamReader(ps));
            InputStream es = IOUtils.toInputStream(email, "UTF-8");
            readerE = new BufferedReader(new InputStreamReader(es));
            callableStatement = connect.prepareCall("{call `update_password`(?, ?)}");
            callableStatement.setCharacterStream(1, readerP);
            callableStatement.setCharacterStream(2, readerE);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
            return false;
        } finally {
            readerP.close();
            readerE.close();
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * The method finishes the registration for the user, creates the session and logs it into the dB.
     *
     * @param voucher_
     * @param user
     * @param pass
     * @param deviceId
     * @param sessionCreated
     * @param sessionID
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean wrapUp_registration(String voucher_, String user, String pass, String deviceId, long sessionCreated, String sessionID, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            connect.setAutoCommit(false);
            InputStream in_ = IOUtils.toInputStream(voucher_, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            InputStream ins = IOUtils.toInputStream(pass, "UTF-8");
            Reader readers = new BufferedReader(new InputStreamReader(ins));
            callableStatement = connect.prepareCall("{call `insert_voucher`(?, ?, ?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.setString(2, user);
            callableStatement.setCharacterStream(3, readers);
            int x = callableStatement.executeUpdate();
            reader_.close();
            readers.close();
            if (x == 1) {
                InputStream in_d = IOUtils.toInputStream(deviceId, "UTF-8");
                Reader reader_d = new BufferedReader(new InputStreamReader(in_d));
                InputStream insd = IOUtils.toInputStream(user, "UTF-8");
                Reader readersd = new BufferedReader(new InputStreamReader(insd));
                callableStatement = connect.prepareCall("{call `insert_device_`(?, ?)}");
                callableStatement.setCharacterStream(1, reader_d);
                callableStatement.setCharacterStream(2, readersd);
                int y = callableStatement.executeUpdate();
                reader_d.close();
                readersd.close();
                if (y == 1) {
                    InputStream in_se = IOUtils.toInputStream(deviceId, "UTF-8");
                    Reader reader_se = new BufferedReader(new InputStreamReader(in_se));
                    InputStream inse = IOUtils.toInputStream(sessionID, "UTF-8");
                    Reader readerse = new BufferedReader(new InputStreamReader(inse));
                    callableStatement = connect.prepareCall("{call `insert_sessionCreated`(?, ?, ?)}");
                    callableStatement.setCharacterStream(1, reader_se);
                    callableStatement.setLong(2, sessionCreated);
                    callableStatement.setCharacterStream(3, readerse);
                    int z = callableStatement.executeUpdate();
                    reader_se.close();
                    readerse.close();
                    if (z == 1) {
                        InputStream inv = IOUtils.toInputStream(voucher_, "UTF-8");
                        Reader readerv = new BufferedReader(new InputStreamReader(inv));
                        callableStatement = connect.prepareCall("{call `copy_token2`(?)}");
                        callableStatement.setCharacterStream(1, readerv);
                        int w = callableStatement.executeUpdate();
                        readerv.close();
                        if (w == 1) {
                            connect.commit();
                            dbManager.closeConnection();
                            return true;
                        }
                    }
                }
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * It does nothing.
     *
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean sessionId(ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            long time = System.currentTimeMillis();
            java.sql.Timestamp timestamp = new java.sql.Timestamp(time);
            String sql = "insert into  login.logins values (default, ?)";
            preparedStatement = connect.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, SQLAccess.uuId().toString());
            preparedStatement.setLong(2, 2);
            preparedStatement.setTimestamp(3, timestamp);
            preparedStatement.executeUpdate();
            ResultSet rs = preparedStatement.getGeneratedKeys();
            while (rs.next()) {
            }
            preparedStatement.closeOnCompletion();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * First checks the voucher state, and depending on the state of the voucher a @return will be set.
     * It returns always true, if the voucher is available.
     *
     * @param voucher_
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean voucher(String voucher_, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(voucher_, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `get_voucher`(?)}");
            callableStatement.setCharacterStream(1, reader);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            while (rs.next()) {
                String voucher = rs.getString(1);
                if (voucher_.equals(voucher)) {
                    InputStream in_ = IOUtils.toInputStream(voucher_, "UTF-8");
                    Reader reader_ = new BufferedReader(new InputStreamReader(in_));
                    callableStatement_ = connect.prepareCall("{call `set_voucher`(?)}");
                    callableStatement_.setCharacterStream(1, reader_);
                    callableStatement_.executeQuery();
                    callableStatement_.closeOnCompletion();
                    reader_.close();
                }
                dbManager.closeConnection();
                return true;
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * Voucher will be tied to registering user at this step of registration process.
     *
     * @param voucher_
     * @param user
     * @param pass
     * @param context
     * @return true on success, otherwise false
     * @throws Exception
     */
    public synchronized static boolean insert_voucher(String voucher_, String user, String pass, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(voucher_, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            InputStream ins = IOUtils.toInputStream(pass, "UTF-8");
            Reader readers = new BufferedReader(new InputStreamReader(ins));
            callableStatement = connect.prepareCall("{call `insert_voucher`(?, ?, ?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.setString(2, user);
            callableStatement.setCharacterStream(3, readers);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
            reader_.close();
            readers.close();
            dbManager.closeConnection();
            return true;
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * Inserts a deviceId for the current user.
     *
     * @param deviceId
     * @param user
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean insert_device(String deviceId, String user, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(deviceId, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            InputStream ins = IOUtils.toInputStream(user, "UTF-8");
            Reader readers = new BufferedReader(new InputStreamReader(ins));
            callableStatement = connect.prepareCall("{call `insert_device_`(?, ?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.setCharacterStream(2, readers);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
            reader_.close();
            readers.close();
            dbManager.closeConnection();
            return true;
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * Inserts session creation time for deviceId.
     * This insert also triggers tokens into the Tokens table for the device (user), that can be used for API calls.
     *
     * @param deviceId
     * @param sessionCreated
     * @param context
     * @return true on success, otherwise false
     * @throws ClassNotFoundException
     * @throws IOException
     * @throws SQLException
     */
    public synchronized static boolean insert_sessionCreated(String deviceId, long sessionCreated, String sessionID, ServletContext context) throws ClassNotFoundException, IOException, SQLException {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            //connect(context);
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(deviceId, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            InputStream in = IOUtils.toInputStream(sessionID, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `insert_sessionCreated`(?, ?, ?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.setLong(2, sessionCreated);
            callableStatement.setCharacterStream(3, reader);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
            reader_.close();
            reader.close();
            dbManager.closeConnection();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
            return false;
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * Copies token2 for registration activation.
     *
     * @param voucher
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean copy_token2(String voucher, ServletContext context) throws Exception {
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(voucher, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `copy_token2`(?)}");
            callableStatement.setCharacterStream(1, reader);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
            reader.close();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
            return false;
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * Resets the voucher to the first enum state, and clears the user. Do not touch other tables.
     *
     * @param voucher
     * @param context
     * @return true
     * @throws Exception
     */
    public synchronized static boolean reset_voucher(String voucher, String user, ServletContext context) throws Exception {
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(voucher, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `reset_voucher`(?, ?)}");
            callableStatement.setCharacterStream(1, reader);
            callableStatement.setString(2, user);
            callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * Deletes user.
     *
     * @param user
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean delete_user(String user, ServletContext context) throws Exception {
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(user, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `delete_user`(?)}");
            callableStatement.setCharacterStream(1, reader);
            callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     *  Updates (finalizes) the voucher state during the last step of registration process.
     *
     * @param voucher_
     * @param context
     * @return true
     * @throws Exception
     */
    public synchronized static boolean register_voucher(String voucher_, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(voucher_, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `get_processing_voucher`(?)}");
            callableStatement.setCharacterStream(1, reader);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            while (rs.next()) {
                String voucher = rs.getString(1);
                //int voucher_is_toBeActivated = rs.getInt(4);
                if (voucher_.equals(voucher)) {
                    InputStream in_ = IOUtils.toInputStream(voucher, "UTF-8");
                    Reader reader_ = new BufferedReader(new InputStreamReader(in_));
                    callableStatement = connect.prepareCall("{call `register_voucher`(?)}");
                    callableStatement.setCharacterStream(1, reader_);
                    callableStatement.executeQuery();
                    callableStatement.closeOnCompletion();
                    reader.close();
                }
                dbManager.closeConnection();
                return true;
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            //always true
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * Checks user password.
     *
     * @param pass
     * @param context
     * @return hash
     * @throws Exception
     */
    public synchronized static String hash(String pass, String user, ServletContext context) throws Exception {
        hash = "";
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(pass, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            InputStream in_ = IOUtils.toInputStream(user, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `get_hash`(?, ?)}");
            callableStatement.setCharacterStream(1, reader);
            callableStatement.setCharacterStream(2, reader_);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            reader_.close();
            if (rs.next() == false) {
                hash = "ResultSet in empty";
            } else {
                do {
                    hash = rs.getString(1);
                } while (rs.next());
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return hash;
    }

    /**
     * Returns a forgotRequestToken for the requester or an error message, if the email is not registered for any user.
     *
     * @param email
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static String forgot_psw_token(String email_, long time, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        forgot_psw_token = "ILT";
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(email_, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `find_email`(?)}");
            callableStatement.setCharacterStream(1, reader);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            while (rs.next()) {
                email = rs.getString(1);
                rs.close();
                if (email.equals(email_)) {
                    InputStream in_ = IOUtils.toInputStream(email, "UTF-8");
                    Reader reader_ = new BufferedReader(new InputStreamReader(in_));
                    callableStatement = connect.prepareCall("{call `forgot_password`(?, ?)}");
                    callableStatement.setCharacterStream(1, reader_);
                    callableStatement.setLong(2, time);
                    rs = callableStatement.executeQuery();
                    while (rs.next()) {
                        forgot_psw_token = rs.getString(1);
                    }
                    callableStatement.closeOnCompletion();
                    reader.close();
                }
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return forgot_psw_token;
    }

    /**
     * Returns the email which requested the password reset.
     *
     * @param email_
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static List<String> forgot_psw_confirmationCode(String email_, ServletContext context) throws Exception {
        forgot_psw_confirmationCode = new ArrayList<String>();
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(email_, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `find_email2`(?)}");
            callableStatement.setCharacterStream(1, reader);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            while (rs.next()) {
                forgotRequestToken = rs.getString(1);
                forgotRequestTime = rs.getString(2);
                forgot_psw_confirmationCode.add(0, forgotRequestToken);
                forgot_psw_confirmationCode.add(1, forgotRequestTime);
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return forgot_psw_confirmationCode;
    }

    /**
     * Checks if the voucher needs activation.
     *
     *
     * @param user
     * @param context
     * @return <code>S <code> if the voucher is required to be activated.
     * @throws Exception
     */
    public synchronized static String isActivated(String user, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in = IOUtils.toInputStream(user, "UTF-8");
            Reader reader = new BufferedReader(new InputStreamReader(in));
            callableStatement = connect.prepareCall("{call `isActivated`(?)}");
            callableStatement.setCharacterStream(1, reader);
            rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader.close();
            while (rs.next()) {
                isActivated = rs.getInt(1);
            }
            if (isActivated != 1) {
                Response = "S";
            } else {
                Response = "";
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return Response;
    }

    /**
     * Get uuid for current user.
     *
     * @param user
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static String uuid(String user, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(user, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `get_uuid`(?)}");
            callableStatement.setCharacterStream(1, reader_);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader_.close();
            while (rs.next()) {
                uuid = rs.getString(1);
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return uuid;
    }

    /**
     * Get token1 for current device.
     *
     * @param deviceId
     * @param context
     * @return token
     * @throws Exception
     */
    public synchronized static String token(String deviceId, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(deviceId, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `get_token`(?)}");
            callableStatement.setCharacterStream(1, reader_);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader_.close();
            while (rs.next()) {
                token = rs.getString(1);
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return token;
    }

    /**
     * Get token2 for current device.
     *
     * @param deviceId
     * @param context
     * @return token
     * @throws Exception
     */
    public synchronized static List<String> token2(String deviceId, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        list_ = new ArrayList<String>();
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(deviceId, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `get_token2`(?)}");
            callableStatement.setCharacterStream(1, reader_);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader_.close();
            while (rs.next()) {
                token = rs.getString(1);
                time = rs.getString(2);
                list_.add(token);
                list_.add(time);
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return list_;
    }

    /**
     * Get activation token and email for user.
     *
     * @param user
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static List<String> activation_token(String user, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        list = new ArrayList<String>();
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(user, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `get_activation_vocher`(?)}");
            callableStatement.setCharacterStream(1, reader_);
            ResultSet rs = callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader_.close();
            while (rs.next()) {
                token = rs.getString(1);
                email = rs.getString(2);
                list.add(token);
                list.add(email);
            }
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return list;
    }

    /**
     * Get activation token and email for user.
     *
     * @param user
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean activate_voucher(String activationToken, String user, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(activationToken, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            InputStream ins = IOUtils.toInputStream(user, "UTF-8");
            Reader readers = new BufferedReader(new InputStreamReader(ins));
            callableStatement = connect.prepareCall("{call `activate_voucher`(?, ?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.setCharacterStream(2, readers);
            callableStatement.executeUpdate();
            callableStatement.closeOnCompletion();
            reader_.close();
            readers.close();
            return true;
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
        } finally {
            dbManager.closeConnection();
        }
        return false;
    }

    /**
     * Logs out the device by sessionID.
     *
     *
     * @param sessionID
     * @param context
     * @return
     * @throws Exception
     */
    public synchronized static boolean logout(String sessionID, ServletContext context) throws Exception {
        // Setup the connection with the DB
        DBConnectionManager dbManager = (DBConnectionManager) context.getAttribute("DBManager");
        try {
            connect = dbManager.getConnection();
            InputStream in_ = IOUtils.toInputStream(sessionID, "UTF-8");
            Reader reader_ = new BufferedReader(new InputStreamReader(in_));
            callableStatement = connect.prepareCall("{call `logout_device`(?)}");
            callableStatement.setCharacterStream(1, reader_);
            callableStatement.executeQuery();
            callableStatement.closeOnCompletion();
            reader_.close();
        } catch (SQLException ex) {
            SQLAccess.printSQLException(ex);
            throw new Exception(ex);
            //return false;
        } finally {
            dbManager.closeConnection();
        }
        return true;
    }

    /**
     * Puts SQL errors into a json.
     *
     * @param ex
     * @return json
     */
    private static JSONObject jsonSQLError(SQLException ex) {
        JSONObject json = new JSONObject();
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                if (ignoreSQLException(((SQLException) e).getSQLState()) == false) {
                    json.put("SQLState", ((SQLException) e).getSQLState());
                    json.put("Error Code", ((SQLException) e).getErrorCode());
                    json.put("Message", ((SQLException) e).getMessage());
                }
            }
        }
        return json;
    }

    /**
     * Prints SQL errors in catalina.out.
     *
     * @param ex
     */
    public static void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                if (ignoreSQLException(((SQLException) e).getSQLState()) == false) {
                    e.printStackTrace(System.err);
                    System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                    System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                    System.err.println("Message: " + e.getMessage());
                    Throwable t = ex.getCause();
                    while (t != null) {
                        System.out.println("Cause: " + t);
                        t = t.getCause();
                    }
                }
            }
        }
    }

    /**
     * SQL error state ignore method.
     *
     * @param sqlState
     * @return
     */
    public static boolean ignoreSQLException(String sqlState) {
        if (sqlState == null) {
            System.out.println("The SQL state is not defined!");
            return false;
        }
		    /*
		    // 70100: Unique key validation eror
		    if (sqlState.equalsIgnoreCase("70100"))
		      return true;
		    // 23000: Unique key validation eror
		    if (sqlState.equalsIgnoreCase("23000"))
		      return true;
		      */
        // 42Y55: Table already exists in schema
        if (sqlState.equalsIgnoreCase("42Y55"))
            return true;
        return false;
    }
}
