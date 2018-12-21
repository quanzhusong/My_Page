<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% request.setCharacterEncoding("utf-8"); %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>잘못된 요청</title>
<style>
    table{
        text-align: center;
        margin-left: auto;
        margin-right: auto;
        margin-top: auto;
        margin-bottom: auto;
    }
</style>
</head>

<body>
<section>
    <table display=table-cell style="width:60%; height: 100px; margin: auto; text-align: center;"> 
        <tr><td>가입실패!</td></tr>
        <tr><td>아디디가 중복되었거나 잘못되었습니다. 다시 입렵하세요.</td></tr>
        <tr><td><br></td></tr>
        <tr><td><a href="Join.jsp">돌아가기</a></td></tr>
    </table>
</section>

</body>
</html>