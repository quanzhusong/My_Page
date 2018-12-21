<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%  
    // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.
    if (session.getAttribute("signedUser") == null) {
        response.sendRedirect("logout.jsp");
    }
%>

<%
    Date now = new Date();
    SimpleDateFormat sf = new SimpleDateFormat("yyyy.MM.dd");
    String today = sf.format(now);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>추가</title>
<style>
    table{
        border-collapse: collapse;
	    margin-bottom: 5px;
    }
    td, tr{
        border: 1px solid gray;
	    padding: 5px;
    }
    .addbtn{
        position:fixed; 
        top:10px; 
        right:20px;
    }
</style>
<script src="http://code.jquery.com/jquery-3.1.1.js"></script>

<script type="text/javascript">
/*
var localeDate  =  new Date().toLocaleDateString(); 
var localeTime  =  new Date().toLocaleTimeString(); 
document.getElementById ( 'time' ).innerHTML = localeDate;

var date = xmlDoc.getElementsByTagName("pubDate")[0].firstChild.data;
      document.getElementById("time").innerHTML = date;
*/
</script>
</head>

<body>
<section class="section">
        <form method="POST" action="money.jsp"> 
            <table width="100%">
                <tr><td align="center">내용추가</td></tr>
                <tr><td>ID:<input type="text" name="M_ID" value='<%    
                    String id = (String)session.getAttribute("signedUser");
                    out.println(id);
                    %>' readonly>  No:<input readonly type="text" name="M_No" style="width:30px;" value='<%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    try{
                        Context initContext = new InitialContext();
                        Context envContext = (Context)initContext.lookup("java:/comp/env");
                        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
                        conn = ds.getConnection();

                        String sql = "select M_NO from Mon where M_NO=(select max(M_NO) from Mon)"; 
                        pstmt = conn.prepareStatement(sql);
                        ResultSet rs = pstmt.executeQuery();
                        while(rs.next()) {
                            out.println(Integer.parseInt(rs.getString(1))+1);
                        }
                        rs.close();
                        pstmt.close();
                        conn.close();
                    }
                    catch(Exception e) {
                        System.out.println(e);
                    }
                %>'>
                &nbsp; 날짜: <input type="text" id="text" name="M_Date" value="<%= today %>" style="width:80px;" readonly>
                </td></tr>
                <tr><td>사용금액: <input type="number" name="M_Money" placeholder="금액을 입력하시오." maxlength="7">원</td></tr>
                <tr><td><textarea name="M_Text" style="width:99%;height:100px;" placeholder="내용을 입력아시오."></textarea></td></tr>
                <tr><td>
                <input type='submit' value='확인'>  
                </form>
                <a href="money.jsp"><input type='button' value='취소'></a>
                </td></tr>
            </table>
        
</section>
</body>