function switchlang(strclass,strlang,cookieflag) {
   var i, a;
   var targetClasses = strclass.split(" ");

   for(i=0; (a = document.getElementsByTagName("span")[i]); i++) {
      if (PHP.in_array(a.className, targetClasses, false) != -1) {
		 if (a.className == 'artistname' && strlang == 'ja-Latn') strlang = 'en';
         if (a.getAttribute("lang") == strlang) {
            a.style.display = 'inline';
         }
         else {
            a.style.display = 'none';
         }
      }
   }
   if (cookieflag == true) {
	   var expires = new Date();
	   expires.setTime(expires.getTime() + 720*24*60*60*1000);
	   set_cookie('gfa_lang', strlang, expires);
   }
};

function switchcover(i) {
   curr = curr + i;
   if (curr == $covercount) curr = 0;
   if (curr < 0) curr = $covercount - 1;
   document.images["coverart"].src = covers[curr];
   writecaption(captions[curr]);
};

function writecaption(txt) {
   if(document.getElementById) {
      document.getElementById("covercaption").innerHTML=txt;
   } else if (document.all) {
      document.all["covercaption"].innerHTML=txt;
   } else if (document.layers) {
      with(document.layers["covercaption"].document) {
         open();
         write(txt);
         close();
      }
   }
};

function toggle_rightcolumn(dsp,cookieflag) {
	setblock('rightcolumn',dsp);
	if (cookieflag == true) {
	   var expires = new Date();
	   expires.setTime(expires.getTime() + 720*24*60*60*1000);
	   set_cookie('gfa_col', dsp, expires);
	}
};

function toggle_nsfw(dsp) {
	var unsafe_medium = '../db/img/album-nsfw-medium.gif?09';
	var unsafe_thumb = '../db/img/album-nsfw-thumb60.gif';
	if (dsp == 'show') {
		//$('img.unsafe').each(function(){ $(this).attr('src', this.rel); alert(this.rel); });
	}
	else {
		//$('img.unsafe').attr('src', unsafe_medium);
	}
	var expires = new Date();
	expires.setTime(expires.getTime() + 720*24*60*60*1000);
	set_cookie('gfa_nsfw', dsp, expires);
	window.location.reload();
};

function artist_select(objid) {
   if (objid.options[objid.selectedIndex].value == '1') {
      setblock('personfields','none');
   } else {
      setblock('personfields','');
   }
};

function select_change(objid) {
   if (objid.options[objid.selectedIndex].value == 'move') {
      setblock('folderdiv','block');
   } else {
      setblock('folderdiv','none');
   }
};

function setblock(nr, dsp) {
   if (document.layers) {
      document.layers[nr].display = dsp;
   }
   else if (document.all) {
      document.all[nr].style.display = dsp;
   }
   else if (document.getElementById) {
      document.getElementById(nr).style.display = dsp;
   }
};

function discofilter(formobj) {
	var hideString = "";
	setblockclass("tbody", "*", true, "discotable");
	for (var i =0; i < formobj.elements.length; i++)
	{
		var elm = formobj.elements[i];
		if (elm.checked == false) {
			hideString = hideString + " " + elm.value;
		}
		setblockclass("tr", elm.value, elm.checked, "discotable");
	}
	if (hideString != "") {
		setblockclass("tbody", hideString.substr(1), false, "discotable");
	}
};

function setblockclass(strtag,strclass,dsp,containerid) {
	var i, a, container_id;
	if (typeof containerid == "undefined") container_id = document;
	else container_id = document.getElementById(containerid);
	var targetClasses = strclass.split(" ");
	for(i=0; (a = container_id.getElementsByTagName(strtag)[i]); i++) {
		var elementClass = a.className;
		if (elementClass != '' || strclass == "*") {
			var allmatch = true;
			if (elementClass != strclass && strclass != "*") {
				var elementClasses = elementClass.split(" ");		
				for (var j in elementClasses) {
					if (PHP.in_array(elementClasses[j], targetClasses, false) == -1) allmatch = false;
				}
			}
			if (allmatch == true) {
				if (dsp == true) {
					a.style.display = '';
				}
				else {
					a.style.display = 'none';
				}
			}
		}
	}
};

function fResize(elem, offset) {
   if (elem = document.getElementById(elem)) {
      var fHeight = elem.offsetHeight;
      if (fHeight + offset > 0) {
         elem.style.height = (fHeight + offset) + "px"; // NN
         elem.style.posHeight = fHeight + offset; //IE
      }
   }
};

function imgzoom(e) {
	if (!e) e = window.event;
	if (!e.target) e.target = e.srcElement; // ie
	var el = e.target;
    var wheelData = e.detail ? e.detail * -1 : e.wheelDelta / 40;
	var zoom = 20 * wheelData;
	var curWidth = el.width ? el.width : el.offsetWidth;
	if (zoom < 0 && curWidth <= 100) { zoom = 0; }
	el.style.width = (curWidth + zoom) + 'px';
	
	if(e.stopPropagation)
      e.stopPropagation();
    if(e.preventDefault)
      e.preventDefault();
    e.cancelBubble = true;
    e.cancel = true;
    e.returnValue = false;
    return false;
};

function vgmdb_toggle_all(formobj, matchname, setto)
{
	for (var i =0; i < formobj.elements.length; i++)
	{
		var elm = formobj.elements[i];
		if (elm.type == 'checkbox' && elm.name.toLowerCase().indexOf(matchname.toLowerCase(), 0) != -1)
		{
			elm.checked = setto;
		}
	}
};

function vgmdb_check_all(formobj)
{
	vgmdb_toggle_all(formobj, 'apply', formobj.allbox.checked);
};

function vgmdb_radiopopup(toggle)
{
	var expires = new Date();
	if (toggle == true)
	{
		expires.setTime(expires.getTime() + 720*24*60*60*1000);
		set_cookie('gfa_radiopop', '1', expires);
	}
	else
	{
		expires.setTime(expires.getTime() - 3600);
		set_cookie('gfa_radiopop', '', expires);	
	}
};
