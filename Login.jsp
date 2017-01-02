<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript">
	$.subscribe('resetForm', function(event, data) {
		$('#txtMessage').html('');
		$('#clientError').html('');
		$('#txtUserName').val('');
		$('#txtPassword').val('');
	});
	$(document).ready(function() {
		var reportTitle = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument
		.getElementById("reportTitle");
		$(reportTitle).html('').css({
		'display' : 'none'
		});
		var helpBtn = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument
		.getElementById("helpBtn");
		$(helpBtn).css('display','none');
		var menuID = parent.document.getElementById("mainFrameSet");
		$(menuID).attr("cols", "300px,*");
	});
</script>
<style type="text/css">
#txtUserName,#txtPassword{
	width: 130px;
}
.labelTD{
	font-size: medium;
	min-width: 80px;
}
</style>
</head>
<body class="loginPage">
	<s:form id="loginForm" method="post" theme="css_xhtml" errorPosition="top" action="login.action" >
	<br>
	<br>
	<center>
		<h3>Login</h3>

	</center>
		<s:actionerror id="txtMessage" cssClass="errorMessage" />
		<s:actionmessage id="clientError" cssClass="errorMessage" />
		<table cellspacing="4">
			<tr>
				<td class="labelTD">Username:</td>
				<td><sj:textfield id="txtUserName" name="userName" /></td>
			</tr>
			<tr>
				<td  class="labelTD">Password:</td>
				<td><s:password id="txtPassword" name="password" /></td>

			</tr>
		</table>
		<table width="100%" style="font-size: smaller;">
			<tr>
				<td align="right"><sj:submit button="true"
							value="Login" id="btnLogin" formIds="loginForm"></sj:submit></td>
				<td><sj:a button="true"
							onClickTopics="resetForm">Reset</sj:a></td>
			</tr>
			<tr></tr>
			<!-- <tr>
			<td align="left"><a href="ForgetPassword.jsp" target="classFrame" title="Forget Password">Forget Password</a></td>
			</tr> -->
		</table>
	</s:form>
</body>
</html>
