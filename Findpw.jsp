<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% request.setCharacterEncoding("utf-8"); %>
<%
    String id = null;
    id = request.getParameter("FindID");
    Connection conn = null;
    PreparedStatement pstmt = null;
	try{
        Context initContext = new InitialContext();
        Context envContext = (Context)initContext.lookup("java:/comp/env");
        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
        conn = ds.getConnection();
        String sql = "select ID, pw from user where ID = ? and Find_PW = ? and Answer = ?"; 
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("FindID"));
        pstmt.setString(2,request.getParameter("answfindpw"));
        pstmt.setString(3,request.getParameter("find")); 
        ResultSet rs = pstmt.executeQuery(); 
        boolean tru = false;  
        while(rs.next()) { 
            tru = rs.getString(1).equals(id); 
            if (tru==true){
              out.print("<script>alert('당신의 비밀번호는: "+rs.getString(2)+" 입니다.');</script>");
              //out.print("당신의 비밀번호는: "+rs.getString(2));
            }
        }
        if(id != null && tru == false){
          out.print("<script>alert('Worng id or Answer! 다시입력하시오.');</script>");
        }
        
		rs.close();
		pstmt.close();
		conn.close();
	}
	catch(Exception e) {
		System.out.println(e);
  }

%>
<html>
<head>
<meta http-eqiv="Content-type" content="text/html; charset=UTF-8" />
<title>비밀번호 찾기</title>
<!-- <link rel="stylesheet" type="text/css" href="****.css"> -->
</head>

<body>
    <section>
        <form action="Findpw.jsp" method="post">
          <table align=center display=table-cell><tr><td><img src = "img/logo.png" style="transform:scale(1.2)" height="100px"></td></tr></table>
          <h1 align=center>비밀번호 찾기</h1> 
          <table align=center>
            <tr>
                <td width="180px"><input name="FindID" type="text" id="FindID" required="required" autocomplete="off" placeholder="ID를 입력하세요." maxlength="10"></td>
            </tr>
          </table>
          <br>
          <table align=center display=table-cell>
            <tr>
              <td>
                  <select name="answfindpw" style='width:180px;'>
                    <option selected>-비밀번호 찾기 질문-</option>
                    <option value="1">나의 email 주소</option>
                    <option value="2">낵 좋아하는 명언</option>
                    <option value="3">가장 좋아하는 가수는?</option>
                    <option value="4">가장 인상 깊게 본 영화는?</option>
                  </select>
              </td>
            </tr>
            <tr>
              <td>
                <input name="find" type="text" placeholder="응답하기" required="required">
              </td>
            </tr>

            <table align=center display=table-cell>
              <tr>
                <td>
                  <input type="submit" value="확인">
        </form>
                  <a href="Login.jsp"><input type="button" value="취소"></a>
                </td>
              </tr>
            </table>
        </table>
      
    </section>

</body>
</html>
