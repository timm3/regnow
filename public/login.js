<!--

function validateEnterpriseId() {
  var value = document.forms['easForm'].elements['ENT_ID'].value;
  
  document.forms[0].innerHTML = document.forms[0].innerHTML + 
    "<input type=hidden name=ContinueButton value='Continue'>" +
    "<input type=hidden name=principalInput value='" + value + "'>";
    
  document.forms[0].submit();
}

function setFocus() {
	var ftu = document.getElementById("firstTimeUser");
	ftu.innerHTML = "<div class=\"ftbuttons\"><input type=\"button\" name=\"First Time Users\" value=\"First Time Users\" tabindex=\"4\" onClick=\"location='../servlet/FirstTimeUsers'\" /></div>";

  document.forms['easForm'].elements['principal'].focus();
}

function setFocusResetPassword() {
  document.PasswordReset.currpwd.focus();
}

function cookiesOn() {
  var cookieEnabled=(navigator.cookieEnabled)? true : false;

  //if not IE4+ nor NS6+
  if (typeof navigator.cookieEnabled=="undefined" && !cookieEnabled) { 
    document.cookie="testcookie"
    cookieEnabled=(document.cookie.indexOf("testcookie")!=-1)? true : false;
  }

  return cookieEnabled;
}


//-->