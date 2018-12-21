<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>

<%
    String id = request.getParameter("ID");
    String pw = request.getParameter("pw");
    String pw2 = request.getParameter("pw2");
    String fpw = request.getParameter("Find_PW");
    String ans = request.getParameter("Answer");
    String redirectUrl = "worngpage.jsp"; // 인증 실패시 재요청 될 url 
    Connection conn = null;
    PreparedStatement pstmt = null;
	try{
        Context initContext = new InitialContext();
        Context envContext = (Context)initContext.lookup("java:/comp/env");
        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
        conn = ds.getConnection();

        String sql = "select ID from user where ID = '" +id+ "';" ;
        pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery(); 
        if( id!=null && id!="" && id!=" " ){
            boolean tru = false;
            while(rs.next()) { 
                tru = rs.getString(1).equals(id);
            }
            if(tru == false){
                sql = "insert into User values( ?,?,?,? )";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1,id);
                pstmt.setString(2,pw);
                pstmt.setString(3,fpw);
                pstmt.setString(4,ans);
                pstmt.executeUpdate();     
                
                session.setAttribute("signedUser", id); // 인증되었음 세션에 남김
                redirectUrl = "My_Page.jsp";
out.print("<script>alert('가입성공');</script>"); //테스트
            }
            else{
out.print("<script>alert('중복된 id');</script>"); //테스트
            }
        }
        else{
out.print("<script>alert('잘못된 id');</script>"); //테스트
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
<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script type="text/javascript"></script>