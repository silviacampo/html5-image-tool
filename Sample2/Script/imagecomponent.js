/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var modiffiles = {};
var tempImg;

function rotateImage(filepathname, filename, photoid,degrees, callback) {
  try{
        if (modiffiles[photoid] !== undefined && modiffiles[imgPhotoid] != null ){
        var reader = new FileReader();
        logconsole(filename +" rotate reader created");
        reader.onloadend = function() {	
          logconsole(filename +" rotate reader loaded");
          tempImg = new Image();
          tempImg.src = reader.result;
          tempImg.onload = onloadimagetorotate(filename, photoid, degrees, callback); 
       }
       reader.readAsDataURL(modiffiles[photoid]);
    }
    else{
      tempImg = new Image();
      tempImg.src = filepathname;
      tempImg.onload = onloadimagetorotate(filename, photoid, degrees, callback);   
    }
 } catch(exception){
    if (typeof callback === "function")
          callback();
  }
  finally{
    
  }
}

function onloadimagetorotate(filename, photoid, degrees, callback) {
        logconsole(filename +" image loaded");
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
		ctx.drawImage(tempImg,-cnvs.width/2,-cnvs.height/2);
		ctx.restore(); 
        logconsole(filename +" rotate image draw");
        var tempImg2 = new Image();
        var oldcanvas = cnvs.toDataURL("image/jpg");
        cnvs.width= tempImg.height;
        cnvs.height= tempImg.width;
        //alert ("w:" + tempImg.width +" h:"+ tempImg.height);
        tempImg2.src = oldcanvas;
        tempImg2.onload = function() {
           logconsole(filename +" rotate image2 loaded");
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
            ctx.drawImage(tempImg2,sourceX, sourceY, sourceWidth, sourceHeight, destX, destY, destWidth, destHeight);            ctx.restore();
            logconsole(filename +" rotate image2 draw");
            var dataURL = cnvs.toDataURL("image/jpg");
            cnvs = null;
            ctx = null;
            
            modiffiles[photoid]  = dataURItoFile(dataURL, filename);
            logconsole(filename +" rotate file created");            
            if (typeof callback === "function")
          callback();
        };  
      }

function copieImage(filepathname, filename, photoid, color, callback) {
  try{
    if (modiffiles[photoid] !== undefined && modiffiles[imgPhotoid] != null){
        var reader = new FileReader();
        logconsole(filename +" rotate reader created");
        reader.onloadend = function() {	
          logconsole(filename +" rotate reader loaded");
          tempImg = new Image();
          tempImg.src = reader.result;
          tempImg.onload = onloadimagetocopie(filename, photoid, color, callback );
       }
       reader.readAsDataURL(modiffiles[photoid]);
    }
    else{
      tempImg = new Image();
      tempImg.src = filepathname;
      tempImg.onload = onloadimagetocopie(filename, photoid, color, callback );
    }
  }
catch(exception){
    if (typeof callback === "function")
          callback();
  }
  finally{
    
  } 
}

function onloadimagetocopie(filename, photoid, color, callback ) { 
        logconsole(filename +" image loaded");
        var cnvs = document.createElement('canvas');
        cnvs.width = tempImg.width;
        cnvs.height = tempImg.height;
        var ctx = cnvs.getContext("2d");
        ctx.drawImage(tempImg, 0, 0, tempImg.width, tempImg.height);
 
        var imageData = ctx.getImageData(0, 0, tempImg.width, tempImg.height);
        var data = imageData.data;
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
            filename = "bw_" + filename;
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
            filename = "sepia_" + filename;
        }
        
        // overwrite original image
        ctx.putImageData(imageData, 0, 0);
         
        var dataURL = cnvs.toDataURL("image/jpg");
        cnvs = null;
        ctx = null;

		modiffiles[photoid] = dataURItoFile(dataURL, filename);
        logconsole(filename +"created");
        if (typeof callback === "function")
          callback();
      };
 
