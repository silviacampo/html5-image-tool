<%--
    Document   : imagecomponent
    Created on : March 12, 2015, 4:35:18 PM
    Author     : Silvia
--%>

<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% ResourceBundle bundle = ResourceBundle.getBundle("layout", request.getLocale());%>
<%
 String appPath = request.getContextPath();
 String id = request.getParameter("id");
%>
  <div ><canvas id="imgCompCanvas<%=id%>" class="imgCanvas" width="256" height="256"></canvas></div>
  <div id="imgCompEditor<%=id%>" style="text-align: center; width: 256;" >
    <button id="imgcounterclockwise<%=id%>" class="fontabutton"><i class="fa fa-undo"></i></button>
	<button id="imgclockwise<%=id%>" class="fontabutton"><i class="fa fa-repeat"></i></button>
    <button id="imgblackwhite<%=id%>" class="fontabutton"><i class="fa fa-picture-o"></i></button>
    <button id="imgsepia<%=id%>" class="fontabutton"><i class="fa fa-picture-o fa-sepia"></i></button>
    <button id="imgcancel<%=id%>" class="fontabutton"><i class="fa fa-times-circle-o"></i></button>
  </div>
<script type="text/javascript">
      var multiple = true;
      var imgFilename = "";  
      var imgFileThumbPathName = ""; 
      var imgFilePathName = "";
      var imgPhotoid= "";

      
      var canvas2 = document.getElementById('imgCompCanvas<%=id%>');
      var context2 = canvas2.getContext('2d');
      var imageObj2 = new Image();
      
      imageObj2.onload = function() {
        var cw = canvas2.width;
        var ch = canvas2.height;
 		context2.clearRect(0,0,cw,ch);
        context2.save();
		// translate context to center of canvas
        context2.translate(cw / 2, ch / 2);
        // scale y component
        context2.scale(0.25, 0.25);
        var x = cw-imageObj2.width/4;
        var y = ch-imageObj2.height/4;
		context2.drawImage(imageObj2,(-cw +x) * 2,(-ch  + y)* 2);
		context2.restore();
      };
      
 function initImageComponent(ismultiple, filename, filepathname, filethumbpathname, photoid) {
   multiple = ismultiple;
   imgFilename = filename;
   imgFilePathName = filepathname;
   imgFileThumbPathName = filethumbpathname;
   imgPhotoid = photoid;
   
   if (isHTML5Compatible())
     {
        if (modiffiles === undefined || modiffiles[imgPhotoid] === undefined)
        {
         logconsole("path:" +imgFileThumbPathName);
         loadImg2(imgFilePathName);
        }
        else
        {
          //if (multiple === false){
          //  $("input:file").prop("disabled", true);
          //  $("input:file").hide();           
          //}
        }
     }
   else
     {
       $("#imgCompEditor<%=id%>").hide();       
     }  
 }
 
 function hideImageComponent(){
   $("#imgCompEditor<%=id%>").hide(); 
 }

  function loadImg2(filepathname)  {
  if (filepathname !== null){
    imageObj2.src = filepathname;
  }
  else{
  	 var reader = new FileReader();
		reader.onload = function(e) {
           imageObj2.src = reader.result;
         };
         logconsole(modiffiles[imgPhotoid]);
		 reader.readAsDataURL(modiffiles[imgPhotoid]);
  }
  }

	$("#imgclockwise<%=id%>").click(function(){
      disableButtons();
      $("#imgclockwise<%=id%> i").attr("class", "fa fa-spinner fa-pulse");
	  rotateImage(imgFilePathName, imgFilename, imgPhotoid, 90, function() 
       {
          //if (multiple === false){
            //$("input:file").prop("disabled", true);
            //$("input:file").hide();           
          //}
          loadImg2(null);
        enableButtons();
        $("#imgclockwise<%=id%> i").attr("class", "fa fa-repeat");
       });
       return false;
    });

    $("#imgcounterclockwise<%=id%>").click(function(){
      disableButtons();
      $("#imgcounterclockwise<%=id%> i").attr("class", "fa fa-spinner fa-pulse");
 	  rotateImage(imgFilePathName, imgFilename, imgPhotoid,-90,function() 
       {
          //if (multiple === false){
           // $("input:file").prop("disabled", true);
            //$("input:file").hide();           
          //}
		loadImg2(null);
        enableButtons();
        $("#imgcounterclockwise<%=id%> i").attr("class", "fa fa-undo");
       });
       return false;
    });

$("#imgblackwhite<%=id%>").click (function(){
  disableButtons();
  $("#imgblackwhite<%=id%> i").attr("class", "fa fa-spinner fa-pulse");
  copieImage(imgFilePathName, imgFilename, imgPhotoid, 'bw', function() 
       {
         //if (multiple === false){
          //  $("input:file").prop("disabled", true);
          //  $("input:file").hide();           
          //}
          loadImg2(null);
          enableButtons();
          $("#imgblackwhite<%=id%> i").attr("class", "fa fa-picture-o");
       });
       return false;
});

$("#imgsepia<%=id%>").click (function(){
  disableButtons();
  $("#imgsepia<%=id%> i").attr("class", "fa fa-spinner fa-pulse");
  copieImage(imgFilePathName, imgFilename, imgPhotoid ,'sepia', function() 
       {
          //if (multiple === false){
          //  $("input:file").prop("disabled", true);
          //  $("input:file").hide();           
          //} 
          loadImg2(null);
          enableButtons();
          $("#imgsepia<%=id%> i").attr("class", "fa fa-picture-o fa-sepia");
       });
       return false;
});
 
$("#imgcancel<%=id%>").click(function(){ 
  disableButtons();
  $("#imgcancel<%=id%> i").attr("class", "fa fa-spinner fa-pulse");
  modiffiles[imgPhotoid] = null; 
  loadImg2(imgFilePathName);
  //$("input:file").replaceWith($("input:file").val('').clone(true));
  //$("input:file").removeAttr('disabled');
  //$("input:file").show();
  enableButtons();
  $("#imgcancel<%=id%> i").attr("class", "fa fa-times-circle-o");
  return false;
});

function disableButtons(){
      $("#imgclockwise<%=id%>").prop("disabled", true);
      $("#imgcounterclockwise<%=id%>").prop("disabled", true);
      $("#imgblackwhite<%=id%>").prop("disabled", true);
      $("#imgsepia<%=id%>").prop("disabled", true);
      $("#imgcancel<%=id%>").prop("disabled", true);
}

function enableButtons(){
      $("#imgclockwise<%=id%>").removeAttr('disabled');
      $("#imgcounterclockwise<%=id%>").removeAttr('disabled');
      $("#imgblackwhite<%=id%>").removeAttr('disabled');
      $("#imgsepia<%=id%>").removeAttr('disabled');
      $("#imgcancel<%=id%>").removeAttr('disabled');
}
</script>