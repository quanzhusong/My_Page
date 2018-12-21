<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%  
    // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.
    if (session.getAttribute("signedUser") == null) {
        response.sendRedirect("logout.jsp");
    }
%>
<%
String del = request.getParameter("del");
String edi = request.getParameter("edi");
String edimoney = request.getParameter("edimoney");
String edino = request.getParameter("edino");

Connection conn = null;
PreparedStatement pstmt = null;
try{
    Context initContext = new InitialContext();
    Context envContext = (Context)initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
    conn = ds.getConnection();
    if((request.getParameter("M_Money") != "")&&(request.getParameter("M_Money") != null)) {
        String sql = "insert into mon values(?,?,?,?,?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("M_No"));
        pstmt.setString(2,request.getParameter("M_ID"));
        pstmt.setString(3,request.getParameter("M_Date"));
        pstmt.setString(4,request.getParameter("M_Money"));
        pstmt.setString(5,request.getParameter("M_Text"));
        pstmt.executeUpdate();
    }

    if(del != null && del != "") {
out.print("<script>alert('삭제되었습니다. "+del+"');</script>");
        String sql = "delete from mon where M_No = '" +del+ "';" ; 
        pstmt = conn.prepareStatement(sql);
        pstmt.executeUpdate();
    }

    if(edino != null && edino != "") {
        String sql = "update mon set M_Text = ? , M_Money = ? where M_No = ? ";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,edi);
        pstmt.setString(2,edimoney);
        pstmt.setString(3,edino);
        pstmt.executeUpdate();
out.print("<script>alert('수정 완료. "+edino+"');</script>");
    }
}
catch(Exception e) {
    e.printStackTrace();
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<title>가계부</title>
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
    textarea{
        resize: none;
        width:100%;
        border:1;
    }
</style>
<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script type="text/javascript">

$(document).ready(function(){
    $(document).on("click", ".btnDel", function(event) {
        var flag = confirm("삭제하시겠습니까 "+$(this).parent().parent().parent().parent().parent().attr('id'));
        if(flag) {
            var form = document.createElement("form"); 
            form.setAttribute("charset", "UTF-8");
            form.setAttribute("method","post");   
            form.setAttribute("action","money.jsp");
            document.body.appendChild(form);
  
            var insert = document.createElement("input");
            insert.setAttribute("type","hidden");
            insert.setAttribute("name","del");
            insert.setAttribute("id","del");
            insert.setAttribute("value",$(this).parent().parent().parent().parent().parent().attr('id'));
            form.appendChild(insert);
 
            form.submit();
        }
    }); 
/*
    $(document).on("click", ".btnEdi", function(event) {
        var prom = alert("내용 수정 "+$(this).parent().parent().parent().parent().parent().attr('id'));
        if(prom) {
            var form = document.createElement("form");     
            form.setAttribute("charset", "UTF-8");
            form.setAttribute("method","post");            
            form.setAttribute("action","money.jsp");       
            document.body.appendChild(form);           
  
            var insert = document.createElement("input"); 
            insert.setAttribute("type","hidden"); 
            insert.setAttribute("name","edino");
            insert.setAttribute("id","edino");
            insert.setAttribute("value",$(this).parent().parent().parent().parent().parent().attr('id'));
            form.appendChild(insert); 

            var insert = document.createElement("input"); 
            insert.setAttribute("type","hidden"); 
            insert.setAttribute("name","edi");
            insert.setAttribute("id","edi");
            insert.setAttribute("value",prom);
            form.appendChild(insert);
 
            form.submit();
        }
    }); 
*/
    $("#tabl tr").click(function(){
        var num = $(this).parent().parent().parent().attr('id');
        var trs = $("tr[class='hid"+num+"']");
        for(i = 0; i < trs.length; i++){   
            trs[i].style.visibility = "visible";
        }

        var inpus = $("input[class='cost"+num+"']");
        for(i = 0; i < inpus.length; i++){   
            inpus[i].style.border = "1px solid black";
        }

        var cost = $("input[class='hid_cost"+num+"']");
        for(i = 0; i < cost.length; i++){   
            cost[i].type='number';
            cost[i].style.border = "1px solid red";
        }
    });

    $(document).on("click", ".btnnone", function(event) {
        var num = $(this).parent().parent().parent().parent().parent().attr('id');
        var trs = $("tr[class='hid"+num+"']");
        for(i = 0; i < trs.length; i++){   
            trs[i].style.visibility = "collapse";
        }
        var inpus = $("input[class='cost"+num+"']");
        for(i = 0; i < inpus.length; i++){   
            inpus[i].style.border = "none";
        }
        var cost = $("input[class='hid_cost"+num+"']");
        for(i = 0; i < cost.length; i++){   
            cost[i].type='hidden';
            cost[i].style.border = "none";
        }
    }); 

})   

</script>
</head>

<body>
        <div id="container"></div>
<section class="section">
        <div class="addbtn"><button><a href="money_add.jsp">추가</a></button></div> 
        <form method="POST" action="money.jsp"> 
            <table width="100%;">
                <tr><td align="center">가계부</td></tr>
                <tr><td height="400px;" id="list">
                    <div id="add2">
                        <%
                        try{
                            String usr = (String)session.getAttribute("signedUser");
                            String sql = "select M_No, M_Text, M_Date, M_Money from mon where M_ID = " + "'"+usr+"';";
                            pstmt = conn.prepareStatement(sql);
                            ResultSet rs = pstmt.executeQuery(); 
                        
                            int i=1;
                            while(rs.next()) {
                                if(i==1){ 
                                    out.println("<from method='post' id='"+rs.getString(1)+"'>");
                                }

out.println("<form method='post' id='"+rs.getString(1)+"'><table width='100%' id='tabl' class='table table-bordered table-hover text-center'><tr><td><input type='hidden' name='edino' value='"+rs.getString(1)+"'>&nbsp; 사용금액: <input type='text' class='cost"+rs.getString(1)+"' value='"+rs.getString(4)+"' style='border:none;' readonly> <input type='hidden'  id='M_Money' name='edimoney' class='hid_cost"+rs.getString(1)+"' value='"+rs.getString(4)+"'> 원</td> <td align='left' width='100px;'>"+rs.getString(3)+"</td></tr>");
out.println("<tr class='hid"+rs.getString(1)+"' style='visibility:collapse;'><td colspan='2'><textarea id='text' name='edi' length='100%' rows='2'>"+rs.getString(2)+"</textarea><hr><input type='submit' name='edino' value='편집' class='btnEdi' id='edi'> <input type='button' value='삭제' class='btnDel' id='del'> <input type='button' value='취소' class='btnnone' id='none'></td></tr></table></form>");

                                if(i==1){
                                    i++;
                                    out.println("</from>");
                                }
                            }
                            rs.close();
                            pstmt.close();
                            conn.close();
                        }
                        catch(Exception e) {
                            System.out.println(e);
                        }
                        %>
                    </div>
                </td></tr>
            </table>
        </form>
</section>
</body>