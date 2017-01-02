<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Forget Password</title>
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript">
	$.subscribe('resetForm', function(event, data) {
		$('#txtUserName').val('');
		$('#txtEmailID').val('');
	});
</script>
</head>
<body class="ForgetPassword">
<fieldset class="fieldSet"><legend>Forget Password</legend>
	<s:form id="ForgetPasswordForm" method="post" theme="css_xhtml">
		<table cellspacing="4">
			<tr>
				<td>Username:</td>
				<td><sj:textfield id="txtUserName" name="userName" /></td>
			</tr>
			<tr>
				<td>Email ID:</td>
				<td><sj:textfield id="txtEmailID" name="emailID" /></td>
			</tr>
		</table>
		<table style="font-size: smaller;">
			<tr>
				<td align="left"><sj:submit button="true" value="Submit"
						id="btnSubmit" formIds="ForgetPasswordForm"></sj:submit></td>
				<td align="left"><sj:a button="true" onClickTopics="resetForm">Reset</sj:a></td>
			</tr>
		</table>
	</s:form>
	</fieldset>
</body>
</html>