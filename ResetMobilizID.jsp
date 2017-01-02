<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- jquerytheme = south-street, redmod, lightness, humanity, cupertino -->
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/Stylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript" src="struts/js/base/jquery.ui.effect.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect.min.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect-pulsate.js"></script>
<script type="text/javascript"
	src="struts/js/base/jquery.ui.effect-pulsate.min.js"></script>
<head>
<title>Reset Mobiliz ID</title>

<script>
	function getBCDetails(bcCode) {
		showIndicator();
		$.getJSON('findBCToReset.action', {
			'bcCode' : bcCode
		}, function(jData) {
			hideIndicator();
			var vo = jData.vo;
			var bcCode = vo.bcCode;
			if (bcCode === "null" || bcCode === null || bcCode === ""
					|| typeof bcCode === "undefined") {
				$('#divDetail').html(
						"<h3>No details found of<br> BC : "
								+ $('#bcListCombo').val() + " </h4>");
			} else {
				//$('#divDetail').val((vo);
				$('#bcCode').val(vo.bcCode);
				$('#bcName').val(vo.bcName);
				$('#enrollment').val(vo.enrollment);
				$('#mobile').val(vo.mobile);
				var list = vo.village.split(',');
				//alert(list.length);
				var options = $('#village');
				options.find('option').remove().end();
				$.each(list, function() {
					options.append($("<option />").val(this).html(this));
				});
				$("#bcDeatilDiv").css({
					'display' : 'table'
				});
			}
		});

	}
	$.subscribe('getBCs', function(event, data) {
		$("#bcDeatilDiv").css({
			'display' : 'none'
		});
		$("#messageDiv").css({
			'display' : 'none'
		});
		$(".errorLabel").html('');
		$('#txtRequestFrom').val('');
		$('#txtReason').val('');
		showIndicator();
		var bcCode = $('#bcListCombo').val();
		if (bcCode != "-1")
			getBCDetails(bcCode);
		else
			hideIndicator();
	});
	function resetMobilisID() {
		var requestFrom = $('#txtRequestFrom').val();
		var reason = $('#txtReason').val();
		var bcCode = $('#bcListCombo').val();
		showIndicator();
		$.getJSON('resetMobilisAction.action', {
			'bcCode' : bcCode,
			'requestFrom' : requestFrom,
			'reason' : reason
		}, function(jData) {
			var resultOutput = jData.resultOutput;
			if (resultOutput == 0) {
				$('#bcDeatilDiv').css({
					'display' : 'none'
				});
				$('#messageDiv').html("BC : " + bcCode + " Reset Succeed!")
						.css({
							'border' : '2px ridge green',
							'color' : 'green',
							'display' : 'block'
						}).toggle(false).toggle('slide');
				$.publish('reloadBCList');
			} else if (resultOutput == 1) {
				$('#messageDiv').html("Sorry, You do not have permission!")
						.css({
							'border' : '2px ridge red',
							'color' : 'red',
							'display' : 'block'
						}).effect("pulsate", {
							times : 1
						}, 1000);
			} else {
				$('#messageDiv').html("Failed!").css({
					'border' : '2px ridge red',
					'color' : 'red',
					'display' : 'block'
				}).effect("pulsate", {
					times : 1
				}, 1000);
				;
			}
			hideIndicator();
		});
	}
	function validateFields() {
		var requestFrom = $('#txtRequestFrom').val();
		var reason = $('#txtReason').val();
		var bcCode = $('#bcListCombo').val();
		if (bcCode.length > 2 && requestFrom.length > 1 && reason.length > 2) {
			$("#confirmTextID").html(
					"Do you really want to reset<br>BC : " + bcCode + " ?");
			$('#confirmDialog').dialog('open');
		} else {
			$("#messageDiv").html('Enter All details!').css({
				'border' : '2px ridge red',
				'color' : 'red',
				'display' : 'block'
			}).effect("pulsate", {
				times : 1
			}, 1000);

		}
	}
	function validateField() {
		var requestFrom = $('#txtRequestFrom').val();
		var reason = $('#txtReason').val();
		var bcCode = $('#bcListCombo').val();
		$(".errorLabel").html('');
		var errorLabels = $(".errorLabel");
		if (requestFrom.length < 2) {
			$(errorLabels[0]).html("Enter a valid entry!").effect("pulsate", {
				times : 1
			}, 800);
		}
		if (reason.length < 1) {
			$(errorLabels[1]).html("Enter a valid reason!").effect("pulsate", {
				times : 1
			}, 800);
		} else if (reason.length < 10) {
			$(errorLabels[1]).html("Enter minimum 10 characters!").effect(
					"pulsate", {
						times : 1
					}, 800);
		}
		if (bcCode.length > 2 && requestFrom.length > 1 && reason.length > 10) {
			$("#confirmTextID").html(
					"Do you really want to reset<br>BC : " + bcCode + " ?");
			$('#confirmDialog').dialog('open');
		}
	}
	function onCancel() {
		$('#txtRequestFrom').val('');
		$('#txtReason').val('');
		$(".errorLabel").html('');
		$.publish('reloadBCList');
		$('#bcDeatilDiv').css({
			'display' : 'none'
		});

		$('#messageDiv').html("BC Reset Canceled!").css({
			'border' : '2px ridge red',
			'color' : 'red',
			'display' : 'block'
		}).effect("pulsate", {
			times : 1
		}, 1000);
		hideIndicator();
	}
	function checkLength(event) {
		var character = event.which;
		if (event.target.textLength > 88 && character != 46 && character != 8)
			return false;
		else
			return true;
	}
</script>
<style type="text/css">
#wwlbl_txtReason {
	width: 100px;
	min-width: 100px;
}

.wwctrl input,textarea,select {
	max-width: 204px;
	width: 204px;
}

.wwctrl textarea {
	max-height: 60px;
	max-width: 204px;
}

.errorLabel {
	color: red;
	font-weight: bold;
}
</style>

</head>
<body>
	<hr color="#F28500">

	<s:form name="resetMobilizIDForm" id="resetMobilizIDForm" method="post"
		theme="css_xhtml">

		<s:url var="getBCList" action="findBCNames.action" />
		<%-- 	<s:label value="Select BC : " /> --%>
		<table>
			<tr height="40px;">
				<td><sj:select headerKey="-1" headerValue="Select BC"
						cssStyle="height:25px;" label="Select BC " labelposition="left"
						list="bcList" href="%{getBCList}" id="bcListCombo" listKey="key"
						autocomplete="false" listValue="displayValue" name="bcCode"
						onChangeTopics="getBCs" reloadTopics="reloadBCList" /></td>
				<td><img id="indicatorLoading" class="indicator"
					src="images/indicator.gif" /></td>
			</tr>

		</table>
		<sj:div id="messageDiv" indicator="indicatorLoading"
			cssStyle="min-height:30px;height:30px;font-size:x-large;text-align:center;border-radius:20px 0px 20px 0px;margin:1% 30%;" />
		<fieldset id="bcDeatilDiv"
			style="display: none; font-weight: bold; margin: 0% 30%; border-radius: 10px; padding: 25px; min-width: 450px;"
			class="ui-widget-content">
			<legend>Reset Mobiliz ID</legend>
			<table>
				<tr>
					<td width='109px;'>BC Code</td>
					<td>:</td>
					<td><s:textfield id="bcCode" readonly="true" /></td>
				</tr>
				<tr>
					<td width='109px;'>BC Name</td>
					<td>:</td>
					<td><s:textfield id="bcName" readonly="true" /></td>
				</tr>
				<tr>
					<td width='109px;'>Village</td>
					<td>:</td>
					<td><select id="village" multiple="multiple" size="3"></select></td>
				</tr>
				<tr>
					<td width='109px;'>Mobile No.</td>
					<td>:</td>
					<td><s:textfield id="mobile" readonly="true" /></td>
				</tr>
				<tr>
					<td width='109px;'>Enrollments</td>
					<td>:</td>
					<td><s:textfield id="enrollment" readonly="true" /></td>
				</tr>
				<tr>
					<td colspan="3"><sj:textfield name="requestFrom"
							labelSeparator="&emsp;&nbsp;&emsp;:" labelposition="left"
							maxlength="30" id="txtRequestFrom" label="Request From"
							cssStyle="width:200px;" /></td>
					<td align="left" class="required">*</td>
				</tr>
				<tr>
					<td></td>
					<td align="right" colspan="2"><label class="errorLabel"></label></td>
				</tr>
				<tr>
					<td colspan="3"><sj:textarea name="reason" id="txtReason"
							label="Reason" labelposition="left"
							onkeydown="return checkLength(event);"
							cssStyle="max-width:204px;width:204px;max-height:60px;"
							labelSeparator="&emsp;&emsp;&emsp;&emsp;&emsp;:" /></td>
					<td align="left" class="required">*</td>
				</tr>
				<tr>
					<td></td>
					<td align="right" colspan="2"><label class="errorLabel"></label></td>
				</tr>
				<tr>
					<td colspan="3" align="right" style="font-size: small;"><sj:a
							onclick="onCancel()" button="true" id="cancelButton"
							buttonIcon="ui-icon-closethick" cssStyle="width:100px;">Cancel</sj:a>
						<sj:a button="true" id="resetButton" onclick="validateField()"
							cssStyle="width:100px;">Reset</sj:a></td>
				</tr>
			</table>
		</fieldset>

		<sj:dialog id="confirmDialog" width="auto" autoOpen="false"
			modal="true" closeOnEscape="true" title="BC Detail" position="center"
			cssStyle="font-size: +16px; font-style: normal;" draggable="true"
			buttons="{'No': function(){ $('#confirmDialog').dialog('close'); onCancel();},'Yes': function(){ resetMobilisID();$('#confirmDialog').dialog('close');} }">
			<sj:div id="confirmTextID" />
		</sj:dialog>
		<div id="tempDiv"></div>
	</s:form>
</head>
<body>

</body>
</html>