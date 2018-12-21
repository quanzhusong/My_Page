<%@ page contentType="text/html;charset=utf-8" import="javax.sql.*,java.sql.*, javax.naming.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<%  
    // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.
    if (session.getAttribute("signedUser") == null) {
        response.sendRedirect("logout.jsp");
    }
%>

<%
// 데이터베이스 연결관련 변수 선언
Connection conn = null;
PreparedStatement pstmt = null;

//입력받은 삭제할 값 보기 테스트.
//request.setCharacterEncoding("utf-8");
//String strTemp1 = request.getParameter("del");
//out.println(strTemp1);
//***********테스트, 입력받은 P_No을 String으로 입력받고, 다시 strig을 int로 변환
//String spno = request.getParameter("P_No");
//int npno=1;
//if(spno!=null){
//int p_no = Integer.parseInt(spno);
//npno = p_no + 1;
//}
// out.println(npno);
    
try{
    Context initContext = new InitialContext();
    Context envContext = (Context)initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource)envContext.lookup("jdbc/mysql");
    
    // 커넥션 얻기
    conn = ds.getConnection();

    // 값을 입력한 경우 sql 문장을 수행.
    if((request.getParameter("P_Text") != null) && (request.getParameter("P_Text") != "")) {
        
        // Connection 클래스의 인스턴스로 부터 SQL  문 작성을 위한 Statement 준비
        String sql = "insert into plan values(?,?,?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("P_No"));
        pstmt.setString(2,request.getParameter("U_ID"));
        pstmt.setString(3,request.getParameter("P_Text"));
        pstmt.executeUpdate();
    }

    if((request.getParameter("del") != null) && (request.getParameter("del") != "")) {
        String sql = "delete from plan where P_No = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("del"));
        pstmt.executeUpdate();
    }

    if((request.getParameter("edino") != null) && (request.getParameter("edino") != "")) {
        String sql = "update plan set P_Text = ? where P_No = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1,request.getParameter("edi"));
        pstmt.setString(2,request.getParameter("edino"));
        pstmt.executeUpdate();
    }
}
catch(Exception e) {
    e.printStackTrace();
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>계획</title>
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
</script>
<script type ="text/javascript">


$(document).ready(function(){
    //$("#del").click(function(){
    $(document).on("click", ".btnDel", function(event) {
    //class=btnDel이라는 버튼을 클릭시 아래 이벤트 발생.
        var flag = confirm("삭제하시겠습니까 "+$(this).parent().parent().parent().parent().parent().attr('id'));
        //출력-현제클릭한버튼-상위<form id> <table> <tbody> <tr> <td> <button>
        if(flag) {
            //client.query('delete from plan where P_No = ?',$(this).parent().parent().parent().parent().parent().attr('id'));
            //$.jsql.table.deleteRows ({ dbName: mypage, where: P_No = $(this).parent().parent().parent().parent().parent().attr('id')})
            //$.post("delete.jsp", {name:"P_No",value:$(this).parent().parent().parent().parent().parent().attr('id')});

            var form = document.createElement("form");      // form 엘리멘트 생성
            form.setAttribute("charset", "UTF-8");
            form.setAttribute("method","post");             // method 속성 설정
            form.setAttribute("action","post.jsp");         // action 속성 설정
            document.body.appendChild(form);                // 현재 페이지에 form 엘리멘트 추가
  
            var insert = document.createElement("input");   // input 엘리멘트 생성
            insert.setAttribute("type","hidden");           // type 속성을 hidden으로 설정
            insert.setAttribute("name","del");
            insert.setAttribute("id","del");
            insert.setAttribute("value",$(this).parent().parent().parent().parent().parent().attr('id'));
            form.appendChild(insert);                       // form 엘리멘트에 input 엘리멘트 추가
 
            form.submit();
        }
    }); 
    $(document).on("click", ".btnEdi", function(event) {
        var prom = prompt("수정하기 "+$(this).parent().parent().parent().parent().parent().attr('id'));
        if(prom) {
            var form = document.createElement("form");     
            form.setAttribute("charset", "UTF-8");
            form.setAttribute("method","post");            
            form.setAttribute("action","post.jsp");       
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
})


</script>

</head>

<body>
        <div id="container"></div>
<section class="section">
        <div class="addbtn"><button><a href="post_add.jsp">추가</a></button></div> 
        <form method="POST"> 
            <table width="100%;">
                <tr><td align="center">계획</td></tr>
                <tr><td height="400px;" id="list">
                    <div id="add1">

<%
	try{
        String usr = (String)session.getAttribute("signedUser");
		String sql = "select P_No, P_Text from Plan where U_ID = " + "'"+usr+"';";
		pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery(); 

        int i=1;
		while(rs.next()) {
            //첫번째 실행에서 from이 씹히는 기괴한 현상이 발생..... 대응방안 - 첫 시행에 from하나를 한 번 더 만들어주기...
            if(i==1){ 
                out.println("<from method='post' id='"+rs.getString(1)+"'>");
            }
			out.println("<form method='post' id='"+rs.getString(1)+"'><table width='100%'><tr><td><input type='button' value='편집' class='btnEdi' id='edi'> <input type='button' value='삭제' class='btnDel' id='del'> &nbsp;"+rs.getString(2)+"</td></tr></table></form>");
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