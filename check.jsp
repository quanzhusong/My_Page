<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%
    String id = request.getParameter("ID");
    String pw = request.getParameter("pw");
    String redirectUrl = "Login.jsp"; // 인증 실패시 재요청 될 url 

    Connection conn = null;
    PreparedStatement pstmt = null;
	try{
        Context initContext = new InitialContext();
        Context envContext = (Context)initContext.lookup("java:/comp/env");
        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
        conn = ds.getConnection();
        String sql = "select ID from user where ID = ? and pw = ?";    //보안  String sql = "select ID, pw from user where ID = ?"; 
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("ID"));
        pstmt.setString(2,request.getParameter("pw"));       
        ResultSet rs = pstmt.executeQuery();     
        while(rs.next()) { 
            // if(XX == xx)는 주소가 같아야 할 경우 true, .equals는 값만 비교.
            // 그런데 if(rs.getString(1).equals(id)) 이론적으론 되야되는데 이상하게 오류.
            boolean tru = rs.getString(1).equals(id); 
            if (tru == true){
                session.setAttribute("signedUser", id); // 인증되었음 세션에 남김
                redirectUrl = "My_Page.jsp"; // 인증 성공 시 재요청 url
            }
        }
        
		rs.close();
		pstmt.close();
		conn.close();
	}
	catch(Exception e) {
		System.out.println(e);
    }
    response.sendRedirect(redirectUrl); //id가 존재하면 mypage로, 존재하지 않으면 다시 로그인 페이지로 이동.
%>