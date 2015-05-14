/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function logconsole(msg){ 
  //console.log(msg);
  }

function isHTML5Compatible(){
  var cnvs = document.createElement('canvas');
  if (window.FileReader && window.Image && cnvs.getContext("2d") && (window.File || window.Blob))
  {
    return true;
  }
  else
    {
      return false;
    }
}

var isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
    // Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
    // At least Safari 3+: "[object HTMLElementConstructor]"
var isChrome = !!window.chrome && !isOpera;              // Chrome 1+
var isIE = /*@cc_on!@*/false || !!document.documentMode; // At least IE6

//$(document).ready(function () { 
//    if (isSafari)
//         $('input:file').removeAttr("multiple");
//});

function dataURItoFile(dataURI, name) {
    // convert base64/URLEncoded data component to raw binary data held in a string
    var byteString;
    if (dataURI.split(',')[0].indexOf('base64') >= 0)
        byteString = atob(dataURI.split(',')[1]);
    else
        byteString = unescape(dataURI.split(',')[1]);

    // separate out the mime component
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];

    // write the bytes of the string to a typed array
    var ia = new Uint8Array(byteString.length);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    var generatedFile;
    try{
      generatedFile = new File([ia], name, {type:mimeString});
    }
    catch(exception){
      generatedFile = new Blob([ia], {type:mimeString});
      generatedFile.name = name;
    }
    finally {}
    
	return generatedFile;
}

var smallfiles = [];

var oldcanvas;

function rotateFile(file,degrees, callback) {
  try{
    var reader = new FileReader();
    logconsole(file.name +" rotate reader created");
    reader.onloadend = function() {	
      logconsole(file.name +" rotate reader loaded");
      var tempImg = new Image();
      tempImg.src = reader.result;
      tempImg.onload = function() {
       logconsole(file.name +" roate image loaded");
        var cnvs = document.createElement('canvas');
        var cnvsSize;
        var isHorizontal;
        if (tempImg.width > tempImg.height)
          {
        cnvs.width= tempImg.width;
        cnvs.height= tempImg.width;
        cnvsSize = tempImg.width;
        isHorizontal = true;
          }
          else
            {
        cnvs.width=tempImg.height;
        cnvs.height= tempImg.height;
        cnvsSize = tempImg.height;
        isHorizontal = false;
            }
        var ctx = cnvs.getContext("2d");
		ctx.clearRect(0,0,cnvs.width,cnvs.height);
        ctx.save();
		ctx.translate(cnvs.width/2,cnvs.height/2);
        ctx.rotate(degrees*Math.PI/180);
		ctx.drawImage(this,-cnvs.width/2,-cnvs.height/2);
		ctx.restore(); 
        logconsole(file.name +" rotate image draw");
        var tempImg2 = new Image();
        oldcanvas = cnvs.toDataURL("image/jpg");
        cnvs.width= tempImg.height;
        cnvs.height= tempImg.width;
        //alert ("w:" + tempImg.width +" h:"+ tempImg.height);
        tempImg2.src = oldcanvas;
        tempImg2.onload = function() {
           logconsole(file.name +" rotate image2 loaded");
           // draw cropped image
            if ((degrees === -90 && isHorizontal) || (degrees === 90 && !isHorizontal))
           {
             var sourceX = 0;var sourceY = 0;var sourceWidth = cnvs.width;var sourceHeight = cnvs.height;
            }
            else if ((degrees === 90 && isHorizontal) || (degrees === -90 && !isHorizontal))
              {
            var sourceX = cnvsSize - cnvs.width;var sourceY = cnvsSize - cnvs.height;var sourceWidth = cnvs.width;var sourceHeight = cnvs.height;
              }
           var destX = 0;var destY = 0;var destWidth = cnvs.width;var destHeight = cnvs.height;
            ctx.clearRect(0,0,cnvs.width,cnvs.height);
            ctx.save();
            ctx.drawImage(this,sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);            ctx.restore();
            logconsole(file.name +" rotate image2 draw");
            var dataURL = cnvs.toDataURL("image/jpg");
            cnvs = null;
            ctx = null;
            var adjustedFile  = dataURItoFile(dataURL, file.name);
            smallfiles[currentIndex] = adjustedFile; 
            logconsole(file.name +" rotate file created");            
            if (typeof callback === "function")
          callback();
        }; 
      };
   }
   reader.readAsDataURL(file);
  } catch(exception){
    if (typeof callback === "function")
          callback();
  }
  finally{
    
  }
}

function resizeFile(file, callback) {
  if (file !== null && file.type.match('image.*')) {
    var reader = new FileReader();
    reader.onloadend = function() {
      logconsole(file.name +"reader loaded");
       var tempImg = new Image();
       tempImg.src = reader.result;
       tempImg.onload = function() {
         logconsole(file.name +"image loaded");
          var MAX_WIDTH = 1024;
          var MAX_HEIGHT = 768;
          var tempW = tempImg.width;
          var tempH = tempImg.height;
          if (tempW > tempH) {
             if (tempW > MAX_WIDTH) {
               tempH *= MAX_WIDTH / tempW;
               tempW = MAX_WIDTH;
            }
          } else {
            if (tempH > MAX_HEIGHT) {
               tempW *= MAX_HEIGHT / tempH;
               tempH = MAX_HEIGHT;
            }
        }
        var cnvs = document.createElement('canvas');
        cnvs.width = tempW;
        cnvs.height = tempH;
        var ctx = cnvs.getContext("2d");
        ctx.drawImage(this, 0, 0, tempW, tempH);
        var dataURL = cnvs.toDataURL("image/jpg");
        cnvs = null;
        ctx = null;
		var reducedFile = dataURItoFile(dataURL, file.name);
		smallfiles.push(reducedFile);
        logconsole(file.name +"created");
        appendDialog(file.name +"....OK");
        file = null;
        if (typeof callback === "function")
          callback();
      };
   };
   reader.readAsDataURL(file);
  }
  else
    {
      alert("Only images should be uploaded!");
      if (typeof callback === "function")
          callback();
      logconsole("unsuported file");
    } 
}

function copieFile(file, index, color, callback) {
  try{
    var reader = new FileReader();
    reader.onloadend = function() {
      logconsole(file.name +"reader loaded");
       var tempImg = new Image();
       tempImg.src = reader.result;
       tempImg.onload = function() {
       logconsole(file.name +"image loaded");
        var cnvs = document.createElement('canvas');
        cnvs.width = tempImg.width;
        cnvs.height = tempImg.height;
        var ctx = cnvs.getContext("2d");
        ctx.drawImage(this, 0, 0, tempImg.width, tempImg.height);
 
        var imageData = ctx.getImageData(0, 0, tempImg.width, tempImg.height);
        var data = imageData.data;
        var filename = "";
        if (color === 'bw'){
            for(var i = 0; i < data.length; i += 4) {
              var brightness = 0.34 * data[i] + 0.5 * data[i + 1] + 0.16 * data[i + 2];
              // red
              data[i] = brightness;
              // green
              data[i + 1] = brightness;
              // blue
              data[i + 2] = brightness;
            }
            filename = "bw_" + file.name;
        }
        else if (color === 'sepia'){
            for(var i = 0; i < data.length; i += 4) {
              var outputRed = (data[i] * .393) + (data[i + 1] *.769) + (data[i + 2] * .189);
              var outputGreen = (data[i] * .349) + (data[i + 1] *.686) + (data[i + 2] * .168);
              var outputBlue = (data[i] * .272) + (data[i + 1] *.534) + (data[i + 2] * .131);
              // red
              data[i] = Math.max(Math.min(outputRed, 255),0);
              // green
              data[i + 1] = Math.max(Math.min(outputGreen, 255),0);
              // blue
              data[i + 2] = Math.max(Math.min(outputBlue, 255),0);
            }
            filename = "sepia_" + file.name;
        }
        
        // overwrite original image
        ctx.putImageData(imageData, 0, 0);
         
        var dataURL = cnvs.toDataURL("image/jpg");
        cnvs = null;
        ctx = null;
        
		var colorFile = dataURItoFile(dataURL, filename);
		smallfiles.splice(index + 1,0,colorFile);
        logconsole(file.name +"created");
        if (typeof callback === "function")
          callback();
      };
   };
   reader.readAsDataURL(file);
  }
catch(exception){
    if (typeof callback === "function")
          callback();
  }
  finally{
    
  } 
}
 
