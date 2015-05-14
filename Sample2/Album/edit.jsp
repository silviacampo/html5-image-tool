<%-- 
    Document   : edit
    Created on : Jun 2, 2013, 9:19:24 PM
    Author     : Silvia
--%>

<%@page import="java.util.ResourceBundle"%>
<%@page import="com.silviacampo.projet1.modeljpa.User"%>
<%@page import="com.silviacampo.projet1.FileComponent"%>
<%@page import="com.silviacampo.projet1.modeljpa.Photo"%>
<%@page import="java.util.List"%>
<%@page import="com.silviacampo.projet1.modeljpa.Album"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/user/isloggedin.jsp" %>
<jsp:include page="/ViewAlbum" />
<%
    Album album = (Album) request.getAttribute("album");
    if (album == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    } else {
        if (session.getAttribute(this.getServletContext().getInitParameter("connectedCookie")) != null
                && session.getAttribute(this.getServletContext().getInitParameter("userCookie")) != null) {
            User user = (User) session.getAttribute(this.getServletContext().getInitParameter("userCookie"));
            if (user == null || !user.equals(album.getUser())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:include page="/layout/headLinks.jsp"/>
        <% ResourceBundle bundle = ResourceBundle.getBundle("album", request.getLocale());
        ResourceBundle bundleheader = ResourceBundle.getBundle("layout", request.getLocale());
        %>
        <title><%=bundle.getString("edit.title")%></title>
        <style>
            #sortable { list-style-type: none; margin: 0; padding: 0; width: 1100px; }
            #sortable li { margin: 3px 3px 3px 0; padding: 1px; float: left; width: 200px; height: 270px; text-align: center; background-color: white; }
        </style>
    </head>
    <body>
        <div id="main">
            <jsp:include page="/layout/header.jsp"/>
            <jsp:include page="/layout/menu.jsp"/>
            <div id="content">
                <%String appPath = request.getContextPath();
                    //if (album != null) {
                    String n = request.getParameter("name");
                    n = n == null ? album.getName() : n;
                    String d = request.getParameter("description");
                    d = d == null ? album.getDescription() : d;
                    String s = request.getParameter("scope");
                    s = s == null ? new Integer(album.getScope()).toString() : s;
                    String albumDate = request.getParameter("albumDate");
                    albumDate = albumDate == null ? album.getFormattedAlbumDate(): albumDate;
                    List<Photo> photos = album.getPhotos();
                %>
                <form action="editAlbum.do?id=<%=album.getId()%>" name="albumForm" id="albumForm" method="POST" enctype="multipart/form-data">
                    <fieldset class="myfieldset"><legend><%=bundle.getString("edit.legend")%></legend>
                        <table style="text-align: left; width: 100%;" border="0" cellpadding="10" cellspacing="2">
                            <tbody>
                                <tr>
                                    <td style="width: 156px;vertical-align: top;"><%=bundle.getString("edit.nameLbl")%></td>
                                    <td style="vertical-align: top;"><input name="name" id="name" style="width:100%" value="<%=n%>">
                                        <% if (request.getAttribute("mandatoryName") != null
                                                    && request.getAttribute("mandatoryName").toString() == "true") {%>
                                        <br/><span class="errorMessage"><%=bundle.getString("edit.mandatoryName")%></span>
                                        <%}%>
                                    </td>
                                    <td style="width: 156px;"><%=bundle.getString("edit.scopeLbl")%>
                                    </td>
                                    <td style="width: 250px;">
                                        <select size="1" name="scope" id="scope"><option <%if (s.equals("0")) {%>selected="selected"<%}%> value="0"><%=bundle.getString("scope.public")%></option><option <%if (s.equals("1")) {%>selected="selected"<%}%> value="1"><%=bundle.getString("scope.friendsOnly")%></option><option <%if (s.equals("2")) {%>selected="selected"<%}%> value="2"><%=bundle.getString("scope.private")%></option></select>
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2" style="width: 156px;vertical-align: top;"><%=bundle.getString("edit.descriptionLbl")%></td>
                                    <td rowspan="2" style="vertical-align: top;"><textarea style="width:100%" rows="4" id="description" name="description" ><%=d%></textarea>
                                        <% if (request.getAttribute("mandatoryDescription") != null
                                                    && request.getAttribute("mandatoryDescription").toString() == "true") {%>
                                        <br/><span class="errorMessage"><%=bundle.getString("edit.mandatoryDescription")%></span>
                                        <%}%>
                                    </td>
                                    <td style="width: 156px;"><%=bundle.getString("edit.albumDateLbl")%>
                                    </td>
                                    <td style="width: 250px;">
                                        <input type="text" name="albumDate" id="datepicker" value="<%=albumDate%>">
                                    </td>
                                </tr>
                                <tr>                                 
                                    <td style="width: 156px;"><%=bundle.getString("edit.previewLbl")%>&nbsp;</td>
                                    <td style="width: 250px;">
                                        <% if (album.getPreview() != null) {%> 
                                        <img class="myThumbnailImg" alt="photo" src="<%
                                            FileComponent fc = new FileComponent(this.getServletContext().getInitParameter("rootpath"));
                                            out.print(appPath + fc.GetAlbumThumbnailsHttpDir(album.getId()));
                                            out.print("/");
                                            out.print(album.getPreview().getFilename());
                                             %>">
                                        <%}%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <br>
                                        <%=bundle.getString("edit.addImagesLbl")%> 
                                        <input type="file" name="photos" id="photos" multiple="multiple" >
                                        <span class="myNote"><%=bundle.getString("edit.noteMultipleFiles")%></span>
                                        <br/><jsp:include page="/layout/filecomponent.jsp"/>
                                        <%
                                            if (photos != null && photos.size() > 0) {
                                                //int colsNumber = Integer.parseInt(this.getServletContext().getInitParameter("ColsNumber"));
                                                //int colsCount = 0;
%>
                                        <br/>
                                        <br/>
                                        <span class="myNote"><%=bundle.getString("edit.noteSortPhotos")%></span>

                                        <div id="photosList">
                                            <!--<table class="listTable">
                                             <tbody>
                                              <tr>-->
                                            <ul id="sortable">
                                                <%for (Photo photo : photos) {%>
                                                <li class="ui-state-default">
                                                    <input type="hidden" name="posPhoto<%=photo.getId()%>" id="posPhoto<%=photo.getId()%>" />
                                                    <!--<td class="listCell">-->
                                                    <img class="myThumbnailImg" alt="photo" src="<%
                                                        FileComponent fc = new FileComponent(this.getServletContext().getInitParameter("rootpath"));
                                                        out.print(appPath + fc.GetAlbumThumbnailsHttpDir(album.getId()));
                                                        out.print("/");
                                                        out.print(photo.getFilename());%>" ><br/><%//=photo.getPosition()%>
                                                    <%=photo.getName() == null ? "" : photo.getName()%><br/>
                                                    <a class="myLink" style="text-decoration: underline; color: #0000FF;"
                                                       onmouse="this.style.setAttribute('color','#800080')" onmouseover="this.style.setAttribute('color', '#FF0000');"
                                                       href="<%=appPath%>/photo/edit.jsp?id=<%=photo.getId()%>" target="_blank"><%=bundle.getString("edit.editlnk")%></a> &nbsp;
                                                    <input name="previewPhoto<%=photo.getId()%>" type="checkbox"><%=bundle.getString("edit.previewlnk")%> &nbsp;
                                                    <input type="checkbox" name="deletePhoto<%=photo.getId()%>" /><%=bundle.getString("edit.deletelnk")%>
                                                    <!--</td>-->
                                                </li>
                                                <%//colsCount += 1;if ((colsCount % colsNumber) ==0){%>
                                                <!--</tr>  <tr> -->
                                                <%//}
                                                    }%>
                                            </ul>
                                            <!--</tr>
                                           </tbody>
                                          </table>-->
                                        </div>
                                        <br>
                                        <%}%>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" ></td>
                                    <td colspan="2">
<!--                                        <input type="submit" name="do" id="do" value="<%=bundle.getString("edit.go")%>" onClick="readPosition();
                openDialog();" />-->
                                        <input type="button" id="button" value="<%=bundle.getString("edit.go")%>"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </fieldset>
                </form>
                <%//} else {%>
                <!--Wrong album-->
                <%//}%>
            </div>
            <jsp:include page="/layout/footer.jsp"/>
        </div>
        <script>
          $(function() {
    $( "#datepicker" ).datepicker({
  dateFormat: "yy-mm-dd"
});
  });
          
               initfileComponent();
        
            $(function() {
                $("#sortable").sortable();
                $("#sortable").disableSelection();
            });

            function readPosition() {
                $("#sortable").find('li').each(function(index) {
                    $(this).find('input:hidden').first().val(index);
                    //alert(index);
                });
            }
            
     $("#button").click(function(){
        openDialog();
        readPosition();
        try{
          var descriptionValue = $("#description").val();
          var nameValue = $("#name").val();
          var scopeValue = $("#scope").val();
          var albumDateValue = $( "#datepicker" ).val();
 
           var data = new FormData();
           data.append('description', descriptionValue);
           data.append('name', nameValue);   
           data.append('scope', scopeValue); 
           data.append('albumDate', albumDateValue);

          $("#sortable").find('li').each(function(index) {
            data.append($(this).find('input:hidden').first().attr("name"), $(this).find('input:hidden').first().val());
            if($(this).find('input:checkbox').first().is(':checked')){
              data.append($(this).find('input:checkbox').first().attr("name"), $(this).find('input:checkbox').first().val());
            }
            if($(this).find('input:checkbox').last().is(':checked')){
              data.append($(this).find('input:checkbox').last().attr("name"), $(this).find('input:checkbox').last().val());
            }

          });
    
          jQuery.each(smallfiles, function(i, file) {
            data.append('photos', file);
          });
            $.ajax({
            url: "editAlbum.do?id=<%=album.getId()%>",
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
          </script>
    </body>
</html>

