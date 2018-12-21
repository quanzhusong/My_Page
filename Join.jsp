<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<% request.setCharacterEncoding("utf-8"); %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>

<script type ="text/javascript">
function IspwDone(){
    pw = document.getElementsByName("pw");
    if(pw[0].value !== pw[1].value){
        alert("비밀번호를 확인해주세요.");
        pw[1].focus();
    }
}
</script>

</head>

<body>

<section id="s">
    <table align=center display=table-cell> <tr><td><img src = "img/logo.png" style="transform:scale(1.2)" height="100px"></td></tr></table>
    <!-- transform은 이미지 크기 -->
    <h1 align=center>회원가입</h1>
        <!--form으로 묶기-->
    <form method="post" action="join_check.jsp">
        <table align=center>
            <tr>                             <!--ID-->
                <td width = "180px"><input name="ID" id="ID" type="text" required="required" autocomplete="off" placeholder="ID를 입력하세요." maxlength="10"></td>
            </tr>

            <tr>                             <!--pw-->
                <td width = "180px"><input name="pw" id="pw" name="pw" type = "password" required="required" autocomplete="off" placeholder="비밀번호를 입력하세요." maxlength="15"></td>
            </tr>

            <tr>                             <!--pw-->
                <td width = "180px"><input name="pw" id="pw2" name="pw" type = "password" required="required" autocomplete="off" placeholder="비밀번호를 다시 입력하세요." maxlength="15" class="IspwDone" onchange="IspwDone()"></td>
            </tr>
        </table>
        <br>
        <hr style="width:200px" size="1px">
        <br>

        <table align=center display=table-cell>
            <tr><td>                   <!--Find_PW-->
                <select id="Find_PW" name="Find_PW" style='width:180px;'>
                    <option selected>-비밀번호 찾기 질문-</option>
                    <option value="1">나의 email 주소</option>
                    <option value="2">낵 좋아하는 명언</option>
                    <option value="3">가장 좋아하는 가수는?</option>
                    <option value="4">가장 인상 깊게 본 영화는?</option>
                </select>
            </td></tr>
            <tr><td>                 <!--Answer-->
                <input id="Answer" name="Answer" type="text" placeholder="응답하기" style='width:180px;' required="required" maxlength="15">
            </td></tr>

            <table align=center display=table-cell>
                <tr>
                    <td>
                        <input type="submit" value="가입하기">
    </form>
                        <a href="Login.jsp"><input type="button" value="취소"></a>
                    </td>
                </tr>
            </table>
        </table>
    
</section>

</body>
</html>