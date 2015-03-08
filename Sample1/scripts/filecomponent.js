/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function logconsole(msg){ console.log(msg);}

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

function dataURItoFile(dataURI, file) {
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
      generatedFile = new File([ia], file.name, {type:mimeString});
    }
    catch(exception){
      generatedFile = new Blob([ia], {type:mimeString});
    }
    finally {}
    
	return generatedFile;
}

var smallfiles = [];

function resizeFile(file, callback) {
  if (file != null && file.type.match('image.*')) {
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
		var reducedFile = dataURItoFile(dataURL, file);
		smallfiles.push(reducedFile);
        logconsole(file.name +"created");
        appendDialog(file.name +"....OK");
        if (typeof callback === "function")
          callback();
      };
   };
   reader.readAsDataURL(file);
  }
  else
    {
      alert("Only supported images!");
      if (typeof callback === "function")
          callback();
      logconsole("unsuported file");
    } 
}

 

 
