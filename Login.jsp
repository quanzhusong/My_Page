<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% request.setCharacterEncoding("utf-8"); %>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>로그인</title>

</head>

<body>
<section>
    <table align=center display=table-cell> <tr><td><img src = "img/logo.png" style="transform:scale(1.2)" height="100px"></td></tr></table>
    <h1 align=center>로그인</h1>

    <form action="check.jsp" method="post">
        <table align=center>
            <tr>
                <td width = "180px"><input name="ID" type="text" id="ID" required="required" autocomplete="off" placeholder="ID를 입력하세요." maxlength="10"></td>
            </tr>
            <tr>
                <td><input id = "pw" name="pw" type = "password" required="required" autocomplete="off" placeholder="비밀번호를 입력하세요." maxlength="10"></td>
            </tr>
        </table>
    <br>
    <table align=center display=table-cell>
        <tr>
            <td>
                <input type="submit" value="로그인">
    </form>
                <a href="Join.jsp"><input type="button" value="회원가입"></a>
            </td>
        </tr>
    </table>
    <div align="center"><a href="Findpw.jsp">비밀번호를 잊으셨나요?</a></div>

    
</section>

</body>
</html>