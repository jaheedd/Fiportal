<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript" src="struts/js/base/jquery.ui.effect.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect.min.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect-slide.min.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect-fade.min.js"></script>
<script type="text/javascript">
	function disableBackButton() {
		window.history.forward();
	}
	setTimeout("disableBackButton()", 0);
	function change_frames(file1, file2) {
		parent.loginFrame.location = file1;
		parent.classFrame.location = file2;
		var reportTitle = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument.getElementById("reportTitle");
		$(reportTitle).html('');
	}
	$(document).ready(function() {
		parent.classFrame.location='DisplayDetails.html';
		var helpBtn = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument.getElementById("helpBtn");
		$(helpBtn).css('display', 'block');
		var usernameSpan = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument.getElementById("usernameSpan");
		var userName = $("#userNameHidden").val();
		$(usernameSpan).html("Welcome, "+userName);
	});
	function resizeFrame(event) {
		var reportTitle = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument.getElementById("reportTitle");
		hideMenu();
		$(reportTitle).html(event.currentTarget.text).css({
			'display' : 'block'
		}).effect("slide",{speed:'slow'});
		

	}
	function hideMenu() {
		var menuID = parent.document.getElementById("mainFrameSet");
		$(menuID).attr("cols", "30px,*");
		$("#menuField").css({
			'display' : 'none'
		});
		$("#buttonAnchor").button({
			icons : {
				primary : "ui-icon-circle-arrow-e"
			}
		}).attr('title', 'Open Menu');
		$("#logoutID").css({
			'display' : 'none'
		});
		$("#navButton").attr({
			'icon' : 'ui-icon-circle-arrow-e'
		});
		//$(".ui-button-icon-primary").addClass("imgIndicator").show();
	}
	$.subscribe('toggleMenu', function(event, data) {
		var icon = $("#buttonAnchor").button("option", "icons").primary;
		if (icon == 'ui-icon-circle-arrow-e')
			openMenu();
		else
			hideMenu();
	});
	function openMenu() {
		$("#menuField").css({
			'display' : 'block'
		});
		$("#logoutID").css({
			'display' : 'block'
		});
		var menuID = parent.document.getElementById("mainFrameSet");
		$(menuID).attr("cols", "325px,*");
		$("#buttonAnchor").button({
			icons : {
				primary : "ui-icon-circle-arrow-w"
			}
		}).attr('title', 'Hide Menu');
	}
	function onLogout() {
		var helpBtn = parent.document.getElementById("headerFrameSet").firstElementChild.contentDocument.getElementById("helpBtn");
		$(helpBtn).css('display', 'none');
	}
</script>
<style type="text/css">
.ui-menu.ui-widget.ui-widget-content.ui-corner-all {
	width: 70px;
}

.imgIndicator {
    width: 30px;
    height: 30px;
    z-index:999;
    left:300px;
    display:block;
    position: relative;
    /* Chrome, Safari, Opera */
    -webkit-animation-name: myfirst;
    -webkit-animation-duration: 1s;
    -webkit-animation-timing-function: linear;
    -webkit-animation-delay: 1s;
    -webkit-animation-iteration-count: infinite;
    -webkit-animation-direction: alternate;
    -webkit-animation-play-state: running;
    /* Standard syntax */
    animation-name: myfirst;
    animation-duration: 1s;
    animation-timing-function: linear;
    animation-delay: 1s;
    animation-iteration-count: infinite;
    animation-direction: alternate-reverse;
    animation-play-state: running;
}

/* Chrome, Safari, Opera */
@-webkit-keyframes myfirst {
    0%   {background:red; left:40px; top:0px;}
    100% { left:0px; top:0px;}
}

/* Standard syntax */
@keyframes myfirst {
    0%   { left:40px; top:0px;}
    100% { left:0px; top:0px;}
}
</style>
<title>SERVICES</title>
</head>


<body bgcolor=#F28500 class="servicesBody">
	<s:hidden name="userName" id="userNameHidden"></s:hidden>
	<span style="float: right;" id="navButton"><sj:a
			id="buttonAnchor" button="true" title="Hide Menu"
			buttonIcon="ui-icon-circle-arrow-w"
			cssStyle="height:30px;width:30px;font-size:xx-large;"
			buttonText="false" onClickTopics="toggleMenu"></sj:a>
			<!-- <img id="menuNotifier" alt="" src="images/back-alt.png" height="30px" width="30px"> --></span>
			
	<table style="margin: 0px;" id="menuField">
		<tr>

			<td style="font-weight: bold; font-size: medium;" colspan="2"></td>
		</tr>
		<tr>
			<td colspan="2">
				<fieldset
					style="font-size: small; border: none; margin:-12px 0 0 -10px;min-width: 250px;"
					class="ui-corner-all">
					<sj:accordion id="accordionA" active="0" collapsible="true">
						<sj:accordionItem id="itemReports" title="Reports">
							<ul>
								<li><a href="allbcdetails.action"
									onclick="resizeFrame(event);" title="Display All BC Details"
									target="classFrame">All BC Details</a></li>

								<li><a href="todayLoginDetails.action"
									onclick="resizeFrame(event);" title="BC Logged in Details"
									target="classFrame">BC Logged in Details</a></li>
								<li><a href="districtReportAction.action"
									onclick="resizeFrame(event);"
									title="District wise Enrollment Report" target="classFrame">District
										Enrollment Report</a></li>
								<li><a href="enrollAndTxnReport.action"
									onclick="resizeFrame(event);"
									title="BC wise Enrollment and Transaction Summary"
									target="classFrame">BC wise Enrollment and Transaction
										Summary</a></li>
								<li><a href="enrollReports.action"
									onclick="resizeFrame(event);" title="Enrollment Summary"
									target="classFrame">Enrollment Summary</a></li>
								<li><a href="enrollmentRejection.action"
									onclick="resizeFrame(event);" title="Enrollment Rejection"
									target="classFrame">Enrollment Rejection Report</a></li>
								<li><a href="ReverseMigrationReport.action"
									onclick="resizeFrame(event);" title="Reverse Migration Report"
									target="classFrame">Reverse Migration Report</a></li>
								<li><a href="txnReports.action" title="Transaction Summary"
									onclick="resizeFrame(event);" target="classFrame">Transaction
										Summary</a></li>
								<li><a href="txnFailReports.action"
									onclick="resizeFrame(event);"
									title="Failed Transaction Summary" target="classFrame">Failed
										Transaction Summary</a></li>
								<li><a href="customerWithAdhar.action"
									onclick="resizeFrame(event);"
									title="Customers With Aadhaar No." target="classFrame">Customers
										with Aadhaar No.</a></li>
								<li><a href="CBSAccReport.action"
									onclick="resizeFrame(event);" title="CBS Account Report"
									target="classFrame">CBS Account Report</a></li>
								<li><a href="PendingAuthorizationReport.action"
									onclick="resizeFrame(event);" title="Pending Authorization Report"
									target="classFrame">Pending Authorization Report</a>
								<li><a href="BC_OD_Balance_Report.action"
									onclick="resizeFrame(event);" title="BC OD Balance Report"
									target="classFrame">BC OD Balance Report</a></li>
								<li><a href="CUD_File_Upload_Report.action"
									onclick="resizeFrame(event);"
									title="CUD File Processing Status Report" target="classFrame">CUD
										File Processing Status Report</a></li>
										<!-- <li><a href="pmacMappingReport.action"
									onclick="resizeFrame(event);" title="PM AC Mapping Report"
									target="classFrame">PM AC Mapping Report</a></li> -->
							</ul>
						</sj:accordionItem>
						<sj:accordionItem id="itemAccounts" title="Accounts">
							<ul style="color: #F28500;">
								<li><a href="bcWiseAccEnroll.action"
									onclick="resizeFrame(event);"
									title="BC Wise A/c Opening Report" target="classFrame">BC
										Wise A/c Opening Report</a></li>
								<li><a href="cbsAccBrRegionWise.action"
									onclick="resizeFrame(event);"
									title="Branch Wise Enrollment Report" target="classFrame">Branch
										Wise Enrollment Report</a></li>
								<li><a href="brWiseCustomer.action"
									onclick="resizeFrame(event);" title="CBS Customer Report"
									target="classFrame">CBS Customer Report</a></li>
									<li><a href="invoiceDifference.action"
									onclick="resizeFrame(event);" title="Invoice Difference Report"
									target="classFrame">Invoice Difference Report</a></li>
							</ul>
						</sj:accordionItem>
						<s:if test="userName=='SRISHTI' || userName=='SANDEEPP'">
							<sj:accordionItem id="itemTools" title="Tools">
								<ul style="color: #F28500;">
									<li><a href="resetMobilizID.action"
										onclick="resizeFrame(event);" title="Reset Mobiliz ID"
										target="classFrame">Reset Mobiliz ID</a></li>
								</ul>
							</sj:accordionItem>
						</s:if>
						<s:if test="userName=='ASHISH' || userName=='SANDEEPP' || userName=='SHANTANUD'">
							<sj:accordionItem id="itemMasters" title="Masters">

								<ul style="color: #F28500;">
									<li><a href="branchMaster.action"
										title="Create and update Branch Master" target="classFrame"
										onclick="resizeFrame(event);">Branch Master</a></li>
									<li><a href="bcMasters.action"
										title="Create and update BC Master" target="classFrame"
										onclick="resizeFrame(event);">BC Master</a></li>
									<li><a href="villageMasters.action"
										title=" Create and update village Master" target="classFrame"
										onclick="resizeFrame(event);">Village Master</a></li>
									<li><a href="bcAndVillageMaster.action"
										title="Create BC And Village Master" target="classFrame"
										onclick="resizeFrame(event);">BC Creation Utility</a></li>

									<li><a href="occupationMaster.action"
										title="Occupation Master" target="classFrame"
										onclick="resizeFrame(event);">Occupation Master</a></li>

									<li><a href="documentMaster.action"
										title="Document Master" target="classFrame"
										onclick="resizeFrame(event);">Document Master</a></li>

									<li><a href="mastersExcelSheetFormat.action"
										title="Masters Excel Sheet Format" target="classFrame"
										onclick="resizeFrame(event);">Masters Excel Sheet Format</a></li>

									<!-- <li><a href="bcbfCodeMaster.action"
									title="BCBF Code Master" target="classFrame" onclick="resizeFrame(event);">BCBF Code
										Master</a></li> -->
									<!-- <li><a href="misReport.action" title="Monthly MIS Report"
									target="classFrame" onclick="resizeFrame(event);">Monthly MIS Report</a></li> -->

								</ul>
							</sj:accordionItem>
						</s:if>
						<%-- <sj:accordionItem id="itemVAS" title="Value Added Services">

							<ul style="color: #F28500;">
								<li><a href="vasReport.action"
									title="Value Added Services Report" target="classFrame"
									onclick="resizeFrame(event);">Value Added Services Report</a></li>
							</ul>
						</sj:accordionItem> --%>
					</sj:accordion>
				</fieldset>
			</td>
		</tr>
	</table>
</body>
</html>
