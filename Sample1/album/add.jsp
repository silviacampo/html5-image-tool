<%-- 
    Document   : add
    Created on : Jun 2, 2013, 9:19:12 PM
    Author     : Silvia
--%>

<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/user/isloggedin.jsp" %>
<!DOCTYPE html>
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <jsp:include page="/layout/headLinks.jsp"/> 
  <% ResourceBundle bundle = ResourceBundle.getBundle("album", request.getLocale()); 
  ResourceBundle bundleheader = ResourceBundle.getBundle("layout", request.getLocale());
  %>
  <title><%=bundle.getString("add.title")%></title>
 </head>
 <body>
  <div id="main">
   <jsp:include page="/layout/header.jsp"/>
   <jsp:include page="/layout/menu.jsp"/>
   <div id="content">
    <%
     String n = request.getParameter("name");
     n = n == null ? "" : n;
     String d = request.getParameter("description");
     d = d == null ? "" : d;
     String s = request.getParameter("scope");
     s = s == null ? "" : s;
    %>
    <form action="addAlbum.do" name="albumForm" id="albumForm" method="POST" enctype="multipart/form-data">
     <fieldset class="myfieldset"><legend><%=bundle.getString("add.legend")%></legend>
       <table style="text-align: left; width: 100%;" border="0" cellpadding="2" cellspacing="2">
       <tbody>
        <tr>
         <td style="width: 69px;"><%=bundle.getString("add.nameLbl")%></td>
         <td style="width: 442px;"><input name="name" id="name" value="<%=n%>">
            <% if (request.getAttribute("mandatoryName") != null
                && request.getAttribute("mandatoryName").toString() == "true") {%>
            <br/><span class="errorMessage"><%=bundle.getString("add.mandatoryName")%></span>
            <%}%>
         </td>
         <td style="width: 61px;"><%=bundle.getString("add.scopeLbl")%>
         </td>
         <td style="width: 350px;">
          <select size="1" name="scope" id="scope"><option <%if (s.equals("0")) {%>selected="selected"<%}%> value="0"><%=bundle.getString("scope.public")%></option><option <%if (s.equals("1")) {%>selected="selected"<%}%> value="1"><%=bundle.getString("scope.friendsOnly")%></option><option <%if (s.equals("2")) {%>selected="selected"<%}%> value="2"><%=bundle.getString("scope.private")%></option></select>
         </td>
        </tr>
        <tr>
         <td style="width: 69px;"><%=bundle.getString("add.descriptionLbl")%></td>
         <td style="width: 442px;"><textarea cols="30" rows="3" name="description" id="description" ><%=d%></textarea>
            <% if (request.getAttribute("mandatoryDescription") != null
                && request.getAttribute("mandatoryDescription").toString() == "true") {%>
            <br/><span class="errorMessage"><%=bundle.getString("add.mandatoryDescription")%></span>
            <%}%>         
         </td>
        </tr>
        <tr>
         <td colspan="4">
          <%=bundle.getString("add.selectImages")%> <input type="file" name="photos" id="photos" multiple="multiple" >
          <span class="myNote"><%=bundle.getString("add.noteMultipleFiles")%></span>
         </td>
        </tr>
        <tr>
         <td colspan="2" ></td>
         <td colspan="2">
<!--           <input type="submit" name="do" value="<%=bundle.getString("add.go")%>" onClick="openDialog()"/>-->
           <input type="button" id="button" value="<%=bundle.getString("add.go")%>"/></td>
        </tr>
       </tbody>
      </table>
      <br>

     </fieldset>
    </form>
   </div>
   <jsp:include page="/layout/footer.jsp"/>
  </div>
          <script>            
            
     
     $("#button").click(function(){
        openDialog();
        try{
          var descriptionValue = $("#description").val();
          var nameValue = $("#name").val();
          var scopeValue = $("#scope").val();
 
          var data = new FormData();
         data.append('description', descriptionValue);
         data.append('name', nameValue);   
         data.append('scope', scopeValue); 
 
        jQuery.each(smallfiles, function(i, file) {
          data.append('photos', file);
        });
          $.ajax({
          url: "addAlbum.do",
          data: data,
          cache: false,
          contentType: false,
          processData: false,
          type: 'POST',
          success: function(data){
              document.open();
              document.write(data);
              document.close();
              closeDialog();
          }
           });
        }
        catch(exception){
          $('#albumForm').submit();
        }
        finally {}
});

$('#photos').change(function(e) {
    writeDialog("<%=bundleheader.getString("header.processingfiles")%>");
    openDialog();    
    $("#button").prop("disabled", true);
	smallfiles = [];
    if(isHTML5Compatible()){
      try{
        processFile(this.files,0);
      }
      catch(exception){}
      finally {}
    }
    else
    {
      smallfiles = this.files;
      $("#button").removeAttr('disabled');
      closeDialog();
      resetDialog();
    }
 });

function processFile(files,index)
{
  var file = files[index];
  resizeFile(file,function()
    {
      index = index +1; 
      if(index < files.length)
      {
        processFile(files,index);
      }
      else
        {
         $("#button").removeAttr('disabled');
          closeDialog();
          resetDialog();
        }
    });
    
}
</script>
 </body>
</html>
