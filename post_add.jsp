<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%  
    // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.
    if (session.getAttribute("signedUser") == null) {
        response.sendRedirect("logout.jsp");
    }
%>
<html>
<head>
<title>계획추가</title>

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

</head>

<body>
<section class="section">
        <form method="POST" action="post.jsp"> 
            <table width="100%">
                <tr><td align="center">계획추가</td></tr>
                <tr><td>ID:<input type="text" name="U_ID" value='<%    
                    String id = (String)session.getAttribute("signedUser");
                    out.println(id);
                    %>' readonly>  No:<input readonly type="text" name="P_No" value='<%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
	                try{
                        Context initContext = new InitialContext();
                        Context envContext = (Context)initContext.lookup("java:/comp/env");
                        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
                        conn = ds.getConnection();
    
	                	String sql = "select P_No from Plan where P_No=(select max(P_No) from Plan)";  //마지막 P_No를 구하기.
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
                    %>'></td></tr>
                <tr><td><textarea name="P_Text" style="width:99%;height:100px;" placeholder="내용을 입력아시오."></textarea></td></tr>
                <tr><td>
                    <input type='submit' value='확인'> 
                </form>
                    <a href="post.jsp"><input type='button' value='취소'></a>
                </td></tr>
            </table>
        
</section>

</body>