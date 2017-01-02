<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<head>
<sj:head jqueryui="true" jquerytheme="south-street" />
<link rel="stylesheet" href="./css/MasterStylesheet.css?v=2.4" type="text/css"
	title="Style">
<script type="text/javascript">
	$(document).ready(function() {
		$('#updateButtonDiv').hide();
		$('#backButtonDiv').hide();
		$('#createDiv').hide();

	});

	$.subscribe('villageSelection', function(event, data) {
		var grid = event.originalEvent.grid;
		var sel_id = grid.jqGrid('getGridParam', 'selrow');
		var villageCode = grid.jqGrid('getCell', sel_id, 'villageCode');
		var talukaCode = grid.jqGrid('getCell', sel_id, 'talukaCode');

		$.ajax({
			type : "POST",
			url : "mvillageData.action",
			data : {
				"villageCode" : villageCode,
				"subDistrictCode" : talukaCode
			},
			async : false,
			success : function(jdata) {

				$('#updateDiv').html(jdata);
				$('#updateDiv').show();
				$('#gridDiv').hide();
				$('#fileUploadDiv').hide();
				$('#createDiv').hide();
				$('#createButtonDiv').hide();
				$('#updateButtonDiv').show();
				$('#backButtonDiv').show();
				$('#actionMessage').html("");
				$('#messageDiv').html("");

			}
		});

	});
	function stateOnChange() {

		var stateCode = $('#stateSelect').val();

		$.getJSON('findDistrictList.action', {
			'stateCode' : stateCode
		}, function(data) {

			var districtList = (data.districtList);
			var options = $("#districtSelect");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"----------------Select-----------------"));

			$.each(districtList, function() {

				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});
		});
	}
	function districtOnChange() {
		var districtCode = $('#districtSelect').val();

		$.getJSON('subDistrictList.action', {
			'districtCode' : districtCode
		}, function(data) {

			var subDistrictList = (data.subDistrictList);
			var options = $("#subDistrictSelect");
			options.find('option').remove().end();
			options.append($("<option />").val("-1").text(
					"----------------Select-----------------"));
			$.each(subDistrictList, function() {
				options.append($("<option />").val(this.key).html(
						"<pre style='margin:0;'>" + this.displayValue
								+ "</pre>"));
			});

		});

	}
	function subDistrictOnChange() {
		var subDistrictCode = $('#subDistrictSelect').val();

		$
				.getJSON(
						'villageList.action',
						{
							'subDistrictCode' : subDistrictCode
						},
						function(data) {

							var villageList = (data.villageList);
							var options = $("#villageSelect");
							options.find('option').remove().end();
							options
									.append($("<option />")
											.val("-1")
											.text(
													"-------------------------Select--------------------------"));
							$.each(villageList, function() {
								options.append($("<option />").val(this.key)
										.html(
												"<pre style='margin:0;'>"
														+ this.displayValue
														+ "</pre>"));
							});

						});
	}

	function onVillageSelect() {

		var villageCode = $("#villageSelect").val();
		var talukaCode = $("#subDistrictSelect").val();
		var villageName = $("#villageSelect option:selected").text().split(':')[0]
				.trim();
		$.ajax({
			type : "POST",
			url : "mvillageCreateData.action",
			data : {
				"villageCode" : villageCode,
				"villageName" : villageName,
				"subDistrictCode" : talukaCode
			},
			async : false,
			success : function(jdata) {
				$('#gridDiv').hide();
				$('#updateDiv').html(jdata);
				$('#updateDiv').show();
				$('#createButtonDiv').hide();
				$('#updateButtonDiv').show();
				$('#actionMessage').html("");
				$('#messageDiv').html("");

			}
		});
	}

	function createVillage() {

		$('#gridDiv').hide();
		$('#actionMessage').html("");
		$('#messageDiv').html("");

		/* $('#createFieldsDiv').show(); */
		$('#createDiv').show();
		$('#updateDiv').hide();
		$('#createButtonDiv').hide();
		$('#updateButtonDiv').show();
		return true;

	}
	function backToMainPage() {

		$('#gridDiv').show();
		$('#createButtonDiv').show();
		$('#backButtonDiv').hide();
		$('#updateDiv').hide();
		$('#createDiv').hide();
		$('#fileUploadDiv').hide();
		$('#backButtonDiv').hide();

	}

	function updateVillage() {
		$('#actionMessage').html("");
		$('#messageDiv').html("");
		$('#updateDiv').hide();
		$('#createDiv').hide();
		$('#gridDiv').show();
		$('#fileUploadDiv').show();
		$('#createButtonDiv').show();
		$('#updateButtonDiv').hide();
		/* $(this).remove(); */
		return true;
	}
	function readExcelFile() {
		var file = document.getElementById('fileUpload').value;
		if (file == '') {
			$('#actionMessage').html("");
			$('#messageDiv').html("Please select an excel file to upload!");
			return false;

		}
		document.forms['frmVillageMaster'].action = "readExcelToUploadVillage.action";
		document.forms['frmVillageMaster'].submit();

	}
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="frmVillageMaster" name="frmVillageMaster" method="post"
		enctype="multipart/form-data" theme="css_xhtml">
		<sj:div id="createDiv">
			<table>
				<tr>
					<td><s:select headerKey="-1" label="State" id="stateSelect"
							cssClass="wwctrl" labelSeparator=":<br>"
							onchange="stateOnChange()" cssClass="wwctrl" labelposition="left"
							list="stateList" listKey="key" name="stateSelect"
							listValue="displayValue"
							headerValue="----------------Select-----------------" /></td>
					<td><s:select headerKey="-1" label="District"
							cssClass="wwctrl" labelSeparator=":<br>"
							onchange="districtOnChange()" id="districtSelect"
							labelposition="left" list="districtList" listKey="key"
							name="districtSelect" listValue="displayValue"
							headerValue="----------------Select-----------------" /></td>
					<td><s:select headerKey="-1" id="subDistrictSelect"
							onchange="subDistrictOnChange()" label="Taluka" cssClass="wwctrl"
							labelSeparator=":<br>" labelposition="left"
							list="subDistrictList" listKey="key" name="subDistrictSelect"
							listValue="displayValue"
							headerValue="----------------Select-----------------" /></td>
					<td><s:select headerKey="-1" id="villageSelect"
							onChange="onVillageSelect()" label="Village" cssClass="wwctrl"
							labelSeparator=":<br>" labelposition="left" list="villageList"
							listKey="key" name="villageSelect" listValue="displayValue"
							headerValue=" -------------------------Select--------------------------" /></td>
					<td><small><sj:div id="updateButtonDiv">
								<sj:a button="true" id="updateVillage" name="updateVillage"
									onclick="updateVillage();">
								Back
							</sj:a>
							</sj:div></small></td>

				</tr>
			</table>
		</sj:div>

		<s:url var="villageURL" action="villageMasterData.action" />
		<sj:div id="gridDiv">
			<sjg:grid id="villageGrid" caption="Village Details" dataType="json"
				sortable="true" autowidth="true" href="%{villageURL}" pager="true"
				onSelectRowTopics="villageSelection" sortname="id.villageCode"
				navigatorAdd="false" navigatorEdit="false" navigatorDelete="false"
				gridModel="selectedList" viewrecords="true" rowList="10,15,20,25"
				navigator="true" cssStyle="cursor: pointer;" navigatorSearch="true"
				rowNum="10" rownumbers="true"
				navigatorSearchOptions="{multipleSearch:false}">

				<sjg:gridColumn name="villageCode" index="villageCode"
					searchoptions="{sopt:['eq']}" title="Village Code" sorttype="int"
					sortable="true" search="true" searchtype="text" />
				<sjg:gridColumn name="villageName" index="villageName"
					searchoptions="{sopt:['eq']}" title="Village Name" sortable="true" />
				<sjg:gridColumn name="talukaCode" index="talukaCode"
					title="Taluka Code" sorttype="int" sortable="true"
					searchoptions="{sopt:['eq']}" search="true" searchtype="text" />
				<sjg:gridColumn name="cbsVillageCode" index="cbsVillageCode"
					title="CBSVillage Code" sorttype="int" sortable="true"
					searchoptions="{sopt:['eq']}" search="true" searchtype="text" />
				<sjg:gridColumn name="branchCode" index="branchCode"
					title="Branch Code" sortable="true" />
				<sjg:gridColumn name="bcCode" index="bcCode"
					searchoptions="{sopt:['eq']}" title="BC Code" sorttype="int"
					sortable="true" search="true" searchtype="text" />
				<sjg:gridColumn name="pin" index="pin" searchoptions="{sopt:['eq']}"
					title="Pin Code" sortable="true" />
				<sjg:gridColumn name="populationFlag" index="populationFlag"
					title="Population Flag" searchoptions="{sopt:['eq']}"
					sorttype="int" sortable="true" search="true" searchtype="text" />
				<sjg:gridColumn name="urbanFlag" index="urbanFlag"
					title="Urban Flag" searchoptions="{sopt:['eq']}" sorttype="int"
					sortable="true" search="true" searchtype="text" />
				<sjg:gridColumn name="latitude" index="latitude"
					searchoptions="{sopt:['eq']}" title="Latitude" sortable="true" />
				<sjg:gridColumn name="longitude" index="longitude"
					searchoptions="{sopt:['eq']}" title="Longitude" sortable="true" />
			</sjg:grid>
		</sj:div>
		<sj:div id="updateDiv"></sj:div>
		<sj:div id="backButtonDiv">
			<small><sj:a button="true" id="backButtonID"
					name="backButton" onclick="backToMainPage();">
						Back
						</sj:a></small>
		</sj:div>
		<sj:div id="createButtonDiv">
			<table width="100%">
				<tr>
					<td style="float: left;"><small><sj:a button="true"
								id="createVillage" name="createVillage"
								onclick="createVillage();">
							Create Village
						</sj:a></small></td>
					<td style="float: right;"><div id="fileUploadDiv">
							<table>
								<tr>
									<td>
										<fieldset
											style="width: 400px; height: 70px; border-color: green;">
											<legend>Select An Excel File To Upload</legend>
											<table width="100%">
												<tr>
													<td><s:file id="fileUpload" name="fileUpload" /></td>
												</tr>
											</table>
										</fieldset>
									</td>
									<td><small><sj:a button="true" id="exportToDB"
												onclick="return readExcelFile()">
								Upload
							</sj:a></small></td>
								</tr>
							</table>
						</div>
				</tr>
			</table>
			<table>
				<tr>
					<td width="850" style="float: right;"></td>
					<td><sj:div id="actionMessage" cssClass="errorMessage">
							<s:actionerror />
							<s:actionmessage />
						</sj:div> <sj:div id="messageDiv" cssClass="errorMessage"></sj:div></td>
				</tr>
			</table>

		</sj:div>
	</s:form>
</body>
</html>