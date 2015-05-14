<%-- 
    Document   : edit
    Created on : Jun 2, 2013, 9:18:36 PM
    Author     : Silvia
--%>

<%@page import="java.util.ResourceBundle"%>
<%@page import="com.silviacampo.projet1.modeljpa.User"%>
<%@page import="com.silviacampo.projet1.FileComponent"%>
<%@page import="com.silviacampo.projet1.modeljpa.Album"%>
<%@page import="com.silviacampo.projet1.modeljpa.Comment"%>
<%@page import="java.util.List"%>
<%@page import="com.silviacampo.projet1.modeljpa.Photo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/user/isloggedin.jsp" %>
<jsp:include page="/ViewPhoto" />
<% Photo photo = (Photo) request.getAttribute("photo");
 Album album = null;
 if (photo == null) {
  response.sendRedirect(request.getContextPath() + "/index.jsp");
 } else {
  album = photo.getAlbum();
  if (album == null) {
   response.sendRedirect(request.getContextPath() + "/index.jsp");
  } else {
   if (session.getAttribute(this.getServletContext().getInitParameter("connectedCookie")) != null
           && session.getAttribute(this.getServletContext().getInitParameter("userCookie")) != null) {
    User user = (User) session.getAttribute(this.getServletContext().getInitParameter("userCookie"));
    if (user == null || !user.equals(album.getUser())) {
     response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
   }
  }
 }
%>
<!DOCTYPE html>
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <jsp:include page="/layout/headLinks.jsp"/>
  <% ResourceBundle bundle = ResourceBundle.getBundle("photo", request.getLocale()); 
  ResourceBundle bundleheader = ResourceBundle.getBundle("layout", request.getLocale());
  %>
  <title><%=bundle.getString("edit.title")%></title>
 </head>
 <body>
  <div id="main">
   <jsp:include page="/layout/header.jsp"/>
   <jsp:include page="/layout/menu.jsp"/>
   <div id="content">
    <%

     String appPath = request.getContextPath();
     //if (photo != null) {
     String n = request.getParameter("name");
     n = n == null ?  (photo.getName() == null ? "" :photo.getName()) : n;
     String d = request.getParameter("description");
     d = d == null ? (photo.getDescription() ==null ? "" : photo.getDescription()) : d;

    %>
    <form action="editPhoto.do?id=<%=photo.getId()%>" name="albumForm" id="albumForm" method="POST" enctype="multipart/form-data">
     <fieldset class="myfieldset"><legend><%=bundle.getString("edit.legend")%></legend>
      <table style="text-align: left; width: 100%; " border="0" cellpadding="10" cellspacing="2">
       <tbody>
        <tr>
         <td rowspan="3" style="width: 256px;"><% FileComponent fc = new FileComponent(this.getServletContext().getInitParameter("rootpath"));%>
           <img class="myThumbnailImg" alt="photo" src="
           <%
          out.print(appPath + fc.GetAlbumThumbnailsHttpDir(album.getId()));
          out.print("/");
          out.print(photo.getFilename()); %>" >
           <jsp:include page="/layout/imagecomponent.jsp">
              <jsp:param name="id" value="<%=photo.getId()%>"/>
           </jsp:include>
           <script>
             initImageComponent(false, 
                              "<% out.print(photo.getFilename()); %>",
                              "<% out.print(appPath + fc.GetAlbumHttpDir(album.getId()));
                                  out.print("/"); out.print(photo.getFilename()); %>",
                              "<% out.print(appPath + fc.GetAlbumThumbnailsHttpDir(album.getId()));
                                  out.print("/"); out.print(photo.getFilename()); %>",
                                "<%=photo.getId()%>");
           </script>
           
         </td>
         <td style="width: 156px;vertical-align: top;"><%=bundle.getString("edit.nameLbl")%></td>
         <td style="vertical-align: top;"><input name="name" id="name" style="width:100%" value="<%=n%>"></td>
        </tr>
        <tr>
         <td style="width: 156px;vertical-align: top;"><%=bundle.getString("edit.descriptionLbl")%></td>
         <td style="vertical-align: top;"><textarea style="width:100%" rows="4" id="description" name="description" ><%=d%></textarea>
         </td>
        </tr>
        <tr>
         <td style="width: 156px;vertical-align: top;"><%=bundle.getString("edit.replaceImageLbl")%></td>
         <td style="vertical-align: top;"><input type="file" name="photo" id="photo" ><br/>
         <jsp:include page="/layout/filecomponent.jsp"/>
         </td>
        </tr>
        <tr>
         <td  ></td>
         <td colspan="2">
<!--           <input type="submit" name="do" value="<%=bundle.getString("edit.go")%>" onClick="openDialog();"/>-->
           <input type="button" id="button" value="<%=bundle.getString("edit.go")%>"/></td>
        </tr>
       </tbody>
      </table>
     </fieldset>
    </form>
   </div>
   <jsp:include page="/layout/footer.jsp"/>
  </div>
   <script>
     if(isHTML5Compatible()){
       $(".myThumbnailImg").hide();
     } 
     else
       {
         $(".imgCanvas").hide();
       }
     initfileComponent();     
     
     $("#button").click(function(){
        if (isValidFileComponent(false) && isValidInput()){
        openDialog();
        try{
          var descriptionValue = $("#description").val();
          var nameValue = $("#name").val();
          var data = new FormData();
          data.append('description', descriptionValue);
          data.append('name', nameValue);    
          
          if (modiffiles[imgPhotoid] !== undefined && modiffiles[imgPhotoid] != null){
            data.append('photo', modiffiles[imgPhotoid]);           
          }
          else{ 
            jQuery.each(smallfiles, function(i, file) {
            data.append('photo', file);
          });
          }         

          $.ajax({
          url: "editPhoto.do?id=<%=photo.getId()%>",
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
        }
        else
        {
          if (isValidInput())
          {
            alert("<%=bundle.getString("edit.errorMultipleFiles")%>");
          }
          else
          {
            alert("<%=bundle.getString("edit.errorMultipleFiles")%>");
          }
        }
      });

function isValidInput()
{
      if (smallfiles.length > 0 && (modiffiles[imgPhotoid] !== undefined && modiffiles[imgPhotoid] != null))
        {
          return false;
        }
      return true;
}

     $('#photo').change(function(e) {
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
        //if (smallfiles.length >0){
        //  hideImageComponent();
        //}
    });

  </script> 
 </body>
</html>
