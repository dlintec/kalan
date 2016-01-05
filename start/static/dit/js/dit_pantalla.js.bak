function gebID(id){ return document.getElementById(id); }
  function gebTN(tagName){ return document.getElementsByTagName(tagName); }
  function setStyleToTags(tagName, styleString){
    var tags = gebTN(tagName);
    for( var i = 0; i<tags.length; i++ ) tags[i].setAttribute('style', styleString);
  }
  function testSizes(){
    gebID( 'screen.Width' ).innerHTML = screen.width;
    gebID( 'screen.Height' ).innerHTML = screen.height;

    gebID( 'window.Width' ).innerHTML = window.innerWidth;
    gebID( 'window.Height' ).innerHTML = window.innerHeight;

    gebID( 'documentElement.Width' ).innerHTML = document.documentElement.clientWidth;
    gebID( 'documentElement.Height' ).innerHTML = document.documentElement.clientHeight;

    gebID( 'body.Width' ).innerHTML = gebTN("body")[0].clientWidth;
    gebID( 'body.Height' ).innerHTML = gebTN("body")[0].clientHeight;  
  }

document.addEventListener("DOMContentLoaded", function () {
	console.log('creanto estado de pantalla');

	  var table = document.createElement('table');
	  table.innerHTML = 
		   "<tr><th>SOURCE</th><th>WIDTH</th><th>x</th><th>HEIGHT</th></tr>"
		  +"<tr><td>screen</td><td id='screen.Width' /><td>x</td><td id='screen.Height' /></tr>"
		  +"<tr><td>window</td><td id='window.Width' /><td>x</td><td id='window.Height' /></tr>"
		  +"<tr><td>document<br>.documentElement</td><td id='documentElement.Width' /><td>x</td><td id='documentElement.Height' /></tr>"
		  +"<tr><td>document.body</td><td id='body.Width' /><td>x</td><td id='body.Height' /></tr>"
	  ;

	  gebTN("body")[0].appendChild( table );

	  setStyleToTags("table",
					 "border: 2px solid black !important; position: fixed !important;"
					+"left: 50% !important; top: 0px !important; padding:10px !important;"
					+"width: 150px !important; font-size:18px; !important"
					+"white-space: pre !important; font-family: monospace !important;"
					+"z-index: 9999 !important;background: white !important;"
	  );
	  setStyleToTags("td", "color: black !important; border: none !important; padding: 5px !important; text-align:center !important;");
	  setStyleToTags("th", "color: black !important; border: none !important; padding: 5px !important; text-align:center !important;");

	  table.style.setProperty( 'margin-left', '-'+( table.clientWidth / 2 )+'px' );
      testSizes();
	  setInterval( testSizes, 200 );
}, false);
