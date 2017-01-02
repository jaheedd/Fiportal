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
<link rel="stylesheet" href="./css/responsive.css?v=2.4"
	media="all and (width:800px;)" type="text/css" title="Style" />
<script type="text/javascript" src="./js/dateFormat.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect.min.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect-blind.min.js"></script>
<script type="text/javascript">
	function updateTime() {
		var date = formatDate(new Date());
		setTimeout("updateTime()", 1000);
		document.getElementById('date_time').innerHTML = date;
	}
	$(document).ready(
			function() {
				var d = new Date("july 21, 2014");
				var currentDate = new Date();
				if (d.getDate() > currentDate.getDate()
						&& d.getMonth() == currentDate.getMonth())
					blinker();
				updateTime();
			});
	function blinker() {
		setTimeout('blinker()', 800);
		var display = $(".newNotification").html();
		if (display == 'New')
			$(".newNotification").html('');
		else
			$(".newNotification").html('New');
		//alert(display);
		//$(".newNotification").css("display",display);
	}
	function showAboutPage() {
		/* var aboutDialog = parent.document.getElementById("mainFrameSet").firstElementChild.contentDocument
				.getElementById("aboutDialog"); */
		settings = 'top=100,left=100,directories=0,titlebar=no,toolbar=0,location=no,location=0,status=0,menubar=0,scrollbars=no,resize=0,width=490,height=220,addressbar=0';
		// depending upon your need you can set any thing here
		//directories=0,titlebar=0,toolbar=0,location=0,status=0,menubar=0,scrollbars=no,resizable=no,width=400,height=350
		window.open("about.html", "", settings);
	}
	function removeReportName() {
		$("#reportTitle").css('display', 'none');
	}
	$(window).resize(function() {
		//alert("here");
	});
	function change_frames(file1, file2) {
		parent.loginFrame.location = file1;
		parent.classFrame.location = file2;
		$("#reportTitle").html('');
		$("#helpBtn").css('display', 'none');
		var menuID = parent.document.getElementById("mainFrameSet");
		$(menuID).attr("cols", "325px,*");
	}
</script>
</head>
<body style="margin: 0px;">
	<sj:div cssClass="header">
		<table width="100%" height="100%" style="margin-top: -15px;">
			<tr>
				<td width="12%" style="margin-left: -1px;" rowspan="2"><img
					src="./images/digitalLogo.png" height="84px"
					style="width: 169px; padding-top: 18px; background: white;"></img></td>
				<td>
					<h2 style="float: left; padding-top: 10px;">FI Portal</h2>
				</td>
				<td align="center" width="35%" rowspan="2" style="padding-top: 2%;">
					<span id="reportTitle"
					style="font-size: medium; text-decoration: underline; font-weight: bolder; display: none; color: #539f32; border-radius: 11px 11px 11px 11px; margin: 0px; padding: 10px 40px;">
				</span>
				</td>
				<td>
					<h2 style="float: right; padding-top: 10px; font-size: 20px;"
						id="bankNameID">Central Bank of India</h2>
				</td>
			</tr>
			<tr>
				<td
					style="padding-bottom: 12px; margin-top: -6px; font-size: small;">
					<span id="helpBtn"><span id="usernameSpan"
						class="username-span"> </span><a
						href="javascript:change_frames('Login.jsp', 'DisplayDetails.html')">Logout</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<a title="Help" onclick="removeReportName();" id="helpLink"
						href="UserManual.jsp" target="classFrame">Help</a> &nbsp;&nbsp; <sj:a
							title="About" button="false" href="#" onclick="showAboutPage();">About</sj:a>&nbsp;&nbsp;&nbsp;&nbsp;
						<a title="Change Password" onclick="removeReportName();"
						id="changePwdLink" href="chPassword.action" target="classFrame">Change
							Password</a> </span>
				</td>
				<td style="float: right; padding-bottom: 12px;"><span
					id="date_time" class="date_time"></span></td>
			</tr>
			<!-- <tr>
				<td colspan="3"><marquee id="warningMsg" class="warningMsg"
						dir="ltr" direction="left"> This portal is deployed
						pointing to production database for testing purpose! Please do not
						change anything using Masters and Reset Mobiliz.</marquee></td>
			</tr> -->
		</table>
	</sj:div>
</body>
</html>