<%@ page contentType="text/html;charset=euc-kr" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.lang.String.*"%>

<%  
    // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.
    if (session.getAttribute("signedUser") == null) {
        response.sendRedirect("logout.jsp");
    }
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MyPage</title>
<!-- <link rel="stylesheet" type="text/css" href="****.css"> -->
<style>
    .header {top:0px;  height:60px; width:100%; position:fixed;    z-index:1; background-color: rgb(248, 248, 248);}
    .section{top:75px; height:100%; width:75%;  position:relative; z-index:0;}
    .aside  {top:100px;height:100%; width:25%;  position:fixed;    z-index:0; left:77%; }

    table{
        border-collapse: collapse;
	    margin-bottom: 5px;
    }
    td, tr{
        border: 1px solid gray;
	    padding: 5px;
    }

    #container {
        margin: 5px;
        padding: 5px;
    }
    .col {
        padding: 0;
    }

    #left {
        float:left;
    }

    #right {
        float:right;
    }
</style>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script type ="text/javascript">
    $(document).ready(function(){
        $(document).on("click", ".logout", function(event) {
            var flag = confirm("로그아웃?");
            if(flag == true) {
                window.location.href = 'logout.jsp'; //왜 작동안되지...
                //ocation.href = 'logout.jsp';
                //window.location.href = 'http://localhost:8080/webs/My_Page/logout.jsp';
            }
            else{ 
                return false;
            }
        }); 
    })
</script>

</head>

<body>
    <header class="header">
        <form>
            <div id="container">
                <div id="left" class="col"><img src="img/logo.png" style="transform:scale(0.9)" height="45px"></div>
                <div id="right" class="col"><%   
                // String id=세션에 저장된 id, 테스트를 위해 주석
                String id = "abc";
                //String id = (String)session.getAttribute("signedUser");

                out.println("안녕하세요, "+id+" 님");
                %> <button class="logout" id="logout"><a href="logout.jsp">로그아웃</a></div>
            </div>
        </form>
       </header>
<hr>
<session class="section">
    <iframe src="post.jsp" width="98%" height="500"></iframe>
    <br><br>
    <iframe src="money.jsp" width="98%" height="500"></iframe>

<br>
    <%
        Date now = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy.MM.dd E요일 a hh:mm");
        String today = sf.format(now);
    %>
    
    <%= today %>
<br> 

<!--  구현중.. 구현이 제대로 안 되어 있으므로 주석으로 막음
<div id="chart_div" height="400"><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br></div><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
-->
<%
/* 구현중.. 구현이 제대로 안 되어 있으므로 주석으로 막음
    //DB선언
    Connection conn = null;
    Connection conn1 = null;
    Connection conn2 = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    PreparedStatement pstmt2 = null;

    //그래프 출력
    out.print("<script>google.charts.load('current', {packages: ['corechart', 'bar']}); google.charts.setOnLoadCallback(drawMultSeries);");
    out.print("function drawMultSeries() { var data = new google.visualization.DataTable(); ");
    out.print("data.addColumn('timeofday', '월 금액 사용'); data.addColumn('number', '내가 사용한 금액'); data.addColumn('number', '모든 사람들의 평균치');");
    out.print("data.addRows([");

    try{
        Context initContext = new InitialContext();//그래프 함수
        //DB함수
        Context envContext = (Context)initContext.lookup("java:/comp/env");
        DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
        conn = ds.getConnection();
        String sql = "select M_Date from Mon" ;
        pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        int numbe = 1;
        for(int i = 1; i < 32; i++ ){ //1~31일
        //while(numbe<32){ //31회 출력
            while(rs.next()) { 
                String dat = rs.getString(1); // M_Date
                //out.print(dat+"<br>");

                String p1 = "[.]";
                String[] datt = dat.split(p1);
                String nwdate = datt[0]+"."+datt[1]+"."+numbe;
                //위에서 얻은 값은 2018.12.1   2018.11.29  이런값을 split하여 datt[0]=2018  datt[1]=11  datt[2]=1/대신에 numbe = 1 2  3 4....~31
                //즉 첫실행은 DB에 있는 값 2018.11.1~31  2018.12.1~31 을 출력

                String sql1 = "select avg(M_Money) from Mon where M_Date = '"+nwdate+"';" ;  //전체 특정 날짜 평균 money
                //pstmt1 = conn1.prepareStatement(sql1);
                pstmt1 = conn.prepareStatement(sql1);
                ResultSet rs1 = pstmt1.executeQuery();

                String mone = null; 
                String my_mone = null;
                while(rs1.next()) {  
                    mone = rs1.getString(1); //mone = 평균값.  값이 있으면 1회 출력 없으면 null;
                } 
                String sql2 = "select sum(M_Money) from Mon where M_Date = '"+nwdate+"' and M_ID = '"+id+"'"; //나의 특정 날짜 사용한 money
                //pstmt2 = conn2.prepareStatement(sql2);
                pstmt2 = conn.prepareStatement(sql2);
                ResultSet rs2 = pstmt2.executeQuery();
                while(rs2.next()) { 
                    my_mone = rs2.getString(1); //my_mone = 나의 해당 날짜의 mone 평균값.  값이 있으면 1회 출력 없으면 null;
                }
                //4가지 가능성 . 모든 유저의 평균 사용금액이 null인 날도 있음.
                if(mone != null){
                    if(my_mone != null){
                        out.print("[{v: ["+numbe+"], f: '"+numbe+"일'}, "+my_mone+", "+mone+"],");
                        out.print("<br>");
                    }
                    else{
                        out.print("[{v: ["+numbe+"], f: '"+numbe+"일'}, 0, "+mone+"],");
                        out.print("<br>");
                    }
                }
                else{
                    if(my_mone != null){
                        out.print("[{v: ["+numbe+"], f: '"+numbe+"일'}, "+my_mone+", 0],");
                        out.print("<br>");
                    }
                    else{
                        out.print("[{v: ["+numbe+"], f: '"+numbe+"일'}, 0, 0],");
                        out.print("<br>");
                    }
                }

            }
            numbe++;
        }
        //  원하는 최종 출력값
        //  [{v: ["반복문 1~31"], f: '반복문 1~31 일'}, 내가 해당 날에 사용한 금액, 3050],
        out.print("[{v: ['1'], f: '1일'}, 1000, 3050],");
        out.print("[{v: ['2'], f: '2일'}, 0, 1042],");
        out.print("[{v: ['3'], f: '3일'}, 0, 0],");
        out.print("[{v: ['4'], f: '4일'}, 10000, 7000],");
        //  .........
    
        rs.close();
        pstmt.close();
        conn.close();
	}
	catch(Exception e) {
		System.out.println(e);
    }
    
    out.print("]);");
    out.print("var options = { title: '나의 소비 경향',");
    out.print("hAxis: { title: '날짜', format: '|', ");
    out.print("viewWindow: { min: [0], max: [32] } },");
    out.print("vAxis: { title: '금액(단위: 원)' }  };");
    out.print("var chart = new google.visualization.ColumnChart( document.getElementById('chart_div')); chart.draw(data, options); } </script>");
*/
%>
</session>
       
<!-- 시간 부족으로 미구현.
       <aside class="aside">
           <div>
           <table width="300px;"> 
               <tr>
                   <td>교시</td><td>시간</td> <td>월</td><td>화</td><td>수</td><td>목</td><td>금</td>
               </tr>
               <tr><td>1</td><td>9:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>2</td><td>10:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>3</td><td>11:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>4</td><td>12:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>5</td><td>13:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>6</td><td>14:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>7</td><td>15:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>8</td><td>16:00</td><td></td><td></td><td></td><td></td><td></td></tr>
               <tr><td>9</td><td>17:00</td><td></td><td></td><td></td><td></td><td></td></tr>
           </table>
           </div>
       </aside>
-->
</body>

</html>