<%--
    Document   : filecomponent
    Created on : March 12, 2015, 4:35:18 PM
    Author     : Silvia
--%>

<%@page import="java.util.ResourceBundle"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% ResourceBundle bundle = ResourceBundle.getBundle("layout", request.getLocale());%>
<%
 String appPath = request.getContextPath();
%>
<br/>
<a href="#"id="visualisefiles"><span><%=bundle.getString("filecomp.visualisefiles")%></span></a>
<a href="#" id="deletefiles"><span><%=bundle.getString("filecomp.deletefiles")%></span></a>
<div id="filecomp-modal" title="<%=bundle.getString("filecomp.visualisefiles")%>">
  <div style="float:right;">
    <a id="closeFileComponent" href="#"><span><%=bundle.getString("filecomp.close")%></span></a>
  </div>
  <div style="float:left; margin-right: 10px;"><ul style="height:612; width:250px" id="filesInfo"></ul></div>
  <div style="float:left;"><canvas id="imgCanvas" width="512" height="512"><i class="fa fa-spinner fa-pulse"></i></canvas></div>
  <div><button id="counterclockwise" class="fontabutton">
      <i class="fa fa-undo"></i>
    </button>
	<button id="clockwise" class="fontabutton">
      <i class="fa fa-repeat"></i>
    </button>
    <br><br>
    <button id="blackwhite" class="fontabutton"><i class="fa fa-picture-o"></i></button>
    <button id="sepia" class="fontabutton"><i class="fa fa-picture-o fa-sepia"></i></button>
  </div>
</div>
<script type="text/javascript">
  var currentIndex;
  	var canvas = document.getElementById('imgCanvas');
    var context = canvas.getContext('2d');
      var imageObj = new Image();
      imageObj.onload = function() {
       var cw = canvas.width;
       var ch = canvas.height;
 		context.clearRect(0,0,cw,ch);
        context.save();
		// translate context to center of canvas
      context.translate(cw / 2, ch / 2);
      // scale y component
      context.scale(0.5, 0.5);
      var x = cw-imageObj.width/2;
      var y = ch-imageObj.height/2;
		context.drawImage(imageObj,-512 + x,-512 + y);
		context.restore();
      };
 function initfileComponent() {
   if (isHTML5Compatible())
     {
        if (smallfiles.length ===0)
        {
         $("#visualisefiles").hide();
         $("#deletefiles").hide();
         $("input:file").replaceWith($("input:file").val('').clone(true));
         $("input:file").removeAttr('disabled');
         $("input:file").show();
        }
        else
        {
         $("#visualisefiles").show();
         $("#deletefiles").show();
        }
        $("#filecomp-modal").hide();
     }
   else
     {
       $("#visualisefiles").hide();
       $("#deletefiles").hide();
       $("#filecomp-modal").hide();
     }  
 }
 
 function openFileDialog() {
    jQuery.each(smallfiles, function(i, file) {
      var filename;
      if (file.name === undefined || file.name === null){
        filename = "<%=bundle.getString("filecomp.photo")%> " + i;
      }
      else{
        filename = file.name;
      }
       $("#filesInfo").append('<li><a href="" >' + filename + ' </a>\n\
   <button class="fontabutton"><i class="fa fa-trash-o"></i></button></li>');
     });
    currentIndex = 0;
    $("#filesInfo li a").attr('class', 'normal');
    $("#filesInfo li a").first().attr('class', 'selected');
    loadImg();
    $("#clockwise").removeAttr('disabled');
    $("#clockwise i").attr("class", "fa fa-repeat");
    $("#counterclockwise").removeAttr('disabled');
    $("#counterclockwise i").attr("class", "fa fa-undo");
    var wWidth = $(window).width();
    var dWidth = wWidth * 0.9;
    var wHeight = $(window).height();
    var dHeight = wHeight * 0.9;
    $("#filecomp-modal").dialog({
        height: dHeight,
        width: dWidth,
        dialogClass: 'dialogwtitle',
        beforeclose: function() {
         return false;
        },
        modal: true,
        resizable: true
   })
 }

function closeFileDialog() {
   $("#filecomp-modal").dialog('close');
   $('#filesInfo li').remove();
   imageObj.src = "#";
 }
 
 $("#visualisefiles").click(function() { 
   openFileDialog(); 
 });
 
 $("#deletefiles").click(function() {
   smallfiles = [];
   $("input:file").replaceWith($("input:file").val('').clone(true));
   initfileComponent();
   $("input:file").removeAttr('disabled');
   $("input:file").show();
 });
 
 $("#closeFileComponent").click(function(){
   closeFileDialog(); 
 });

$("#filesInfo").on("click","li a", function(){
		currentIndex = $(this).parent().index();
        $("#filesInfo li a").attr('class', 'normal');
        $(this).attr('class', 'selected');
        loadImg();
		return false;
  });

$("#filesInfo").on("click","li button", function(){
		currentIndex = $(this).parent().index();
        smallfiles.splice(currentIndex, 1);
        if (smallfiles.length ===0){
          closeFileDialog();
          $("#visualisefiles").hide();
          $("#deletefiles").hide();
          $("input:file").replaceWith($("input:file").val('').clone(true));
          $("input:file").removeAttr('disabled');
          $("input:file").show();
        }
        else
          {
          $('#filesInfo li').remove();
          jQuery.each(smallfiles, function(i, file) {
          $("#filesInfo").append('<li><a href="" >' + file.name + ' </a>\n\
            <button class="fontabutton"><i class="fa fa-trash-o"></i></button></li>');
            });
          currentIndex = 0;
          $("#filesInfo li a").attr('class', 'normal');
          $("#filesInfo li a").first().attr('class', 'selected');
          loadImg();
          }
		return false;
  });

  function loadImg()  {
  	 var reader = new FileReader();
		reader.onload = function(e) {
           imageObj.src = reader.result;
         }
		 reader.readAsDataURL(smallfiles[currentIndex]);
  }

	$("#clockwise").click(function(){
      disableButtons();
      $("#clockwise i").attr("class", "fa fa-spinner fa-pulse");
	  rotateFile(smallfiles[currentIndex],90,function()
       {
		loadImg();
        enableButtons();
        $("#clockwise i").attr("class", "fa fa-repeat");
       });
    });

    $("#counterclockwise").click(function(){
      disableButtons();
      $("#counterclockwise i").attr("class", "fa fa-spinner fa-pulse");
 	  rotateFile(smallfiles[currentIndex],-90,function()
       {
		loadImg();
        enableButtons();
        $("#counterclockwise i").attr("class", "fa fa-undo");
       });
    });

$("#blackwhite").click (function(){
  disableButtons();
  $("#blackwhite i").attr("class", "fa fa-spinner fa-pulse");
  copieFile(smallfiles[currentIndex], currentIndex, 'bw', function()
       {
         $('#filesInfo li').remove();
         jQuery.each(smallfiles, function(i, file) {
          $("#filesInfo").append('<li><a href="" >' + file.name + ' </a>\n\
            <button class="fontabutton"><i class="fa fa-trash-o"></i></button></li>');
            });
          currentIndex = currentIndex +1;
          $("#filesInfo li a").attr('class', 'normal');
          $("#filesInfo li:nth-child("+ (currentIndex + 1) +") a").attr('class', 'selected');
          loadImg();
          enableButtons();
          $("#blackwhite i").attr("class", "fa fa-picture-o");
       });
});

$("#sepia").click (function(){
  disableButtons();
  $("#sepia i").attr("class", "fa fa-spinner fa-pulse");
  copieFile(smallfiles[currentIndex], currentIndex, 'sepia', function()
       {
         $('#filesInfo li').remove();
         jQuery.each(smallfiles, function(i, file) {
          $("#filesInfo").append('<li><a href="" >' + file.name + ' </a>\n\
            <button class="fontabutton"><i class="fa fa-trash-o"></i></button></li>');
            });
          currentIndex = currentIndex +1;
          $("#filesInfo li a").attr('class', 'normal');
          $("#filesInfo li:nth-child("+ (currentIndex + 1) +") a").attr('class', 'selected');
          loadImg();
          enableButtons();
          $("#sepia i").attr("class", "fa fa-picture-o fa-sepia");
       });
});

function disableButtons(){
      $("#clockwise").prop("disabled", true);
      $("#counterclockwise").prop("disabled", true);
      $("#blackwhite").prop("disabled", true);
      $("#sepia").prop("disabled", true);
}

function enableButtons(){
      $("#clockwise").removeAttr('disabled');
      $("#counterclockwise").removeAttr('disabled');
      $("#blackwhite").removeAttr('disabled');
      $("#sepia").removeAttr('disabled');
}
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
          $("input:file").prop("disabled", true);
          $("input:file").hide();
          initfileComponent();
          $("#button").removeAttr('disabled');
          closeDialog();
          resetDialog();
        }
    });
    
}

function isValidFileComponent(multiple)
{
  if (multiple === false)
    {
      if (smallfiles.length > 1)
        {
          return false;
        }
    }
    return true;
}

</script>