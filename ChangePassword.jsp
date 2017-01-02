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
		$('#txtCurrentPassword').val('');
		$('#txtNewPasswordFirst').val('');
		$('#txtNewPasswordSecond').val('');
	});
	$(document)
			.ready(
					function() {
						var reportTitle = parent.document
								.getElementById("headerFrameSet").firstElementChild.contentDocument
								.getElementById("reportTitle");
						$(reportTitle).html('').css({
							'display' : 'none'
						});
						var helpBtn = parent.document
								.getElementById("headerFrameSet").firstElementChild.contentDocument
								.getElementById("helpBtn");
						$(helpBtn).css('display', 'none');
						var menuID = parent.document
								.getElementById("mainFrameSet");
						$(menuID).attr("cols", "300px,*");
					});
</script>
<style type="text/css">
.txtFields {
	width: 130px;
}

.labelTD {
	font-size: medium;
	min-width: 80px;
}
</style>
</head>
<body>
	<s:form id="changePasswordForm" method="post" theme="css_xhtml"
		errorPosition="top" action="changePassword.action">

		<fieldset id="chPwdFieldSet" class="changePwdFieldSet">
			<legend>Change password</legend>


			<s:actionerror id="txtMessage" cssClass="errorMessage" />
			<s:actionmessage id="clientError" cssClass="errorMessage" />
			<table cellspacing="4">
				<%-- <tr>
				<td class="labelTD">Username:</td>
				<td><sj:textfield id="txtUserName" name="userName" cssClass="txtFields"/></td>
			</tr> --%>
				<tr>
					<td class="labelTD">Current Password:</td>
					<td><sj:textfield id="txtCurrentPassword"
							name="passwordCurrent" /></td>

				</tr>
				<tr>
					<td class="labelTD">New Password:</td>
					<td><sj:textfield id="txtNewPasswordFirst"
							name="passwordNewFirst" /></td>

				</tr>
				<tr>
					<td class="labelTD">Repeat Password:</td>
					<td><sj:textfield id="txtNewPasswordSecond"
							name="passwordNewSecond" /></td>

				</tr>
			</table>
			<table width="100%" style="font-size: smaller;">
				<tr>
					<td align="right"><sj:submit button="true" value="Change"
							id="btnChange" formIds="changePasswordForm"></sj:submit></td>
					<td align="left"><sj:a button="true" onClickTopics="resetForm">Reset</sj:a></td>
				</tr>
			</table>
		</fieldset>
	</s:form>
</body>
</html>
