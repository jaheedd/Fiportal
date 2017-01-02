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
<script type="text/javascript" src="./js/JavaScript.js?v=2.4"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#updateButtonDiv').hide();
	});
	$.subscribe('bcSelection', function(event, data) {
		var grid = event.originalEvent.grid;
		var sel_id = grid.jqGrid('getGridParam', 'selrow');
		var bcCode = grid.jqGrid('getCell', sel_id, 'bcCode');
		$.ajax({
			type : "POST",
			url : "bcMasterData.action",
			data : {
				"bcCode" : bcCode
			},
			async : false,
			success : function(jdata) {

				$('#updateDiv').html(jdata);
				$('#updateDiv').show();
				$('#gridDiv').hide();
				$('#fileUploadDiv').hide();
				$('#updateButtonDiv').show();
				$('#createButtonDiv').hide();
				$('#actionMessage').html("");
				$('#messageDiv').html("");
			}
		});

	});
	function createBc() {
		$('#actionMessage').html("");
		$('#messageDiv').html("");
		$.ajax({
			type : "POST",
			url : "createBcMaster.action",
			data : {},
			async : false,
			success : function(jdata) {

				$('#gridDiv').hide();
				$('#updateDiv').html(jdata);
				$('#updateDiv').show();
				$('#createButtonDiv').hide();
				$('#updateButtonDiv').show();
			}
		});

	}

	function updateBc() {
		$('#updateDiv').hide();
		$('#gridDiv').show();
		$('#fileUploadDiv').show();
		$('#createButtonDiv').show();
		$('#updateButtonDiv').hide();
		$('#actionMessage').html("");
		$('#messageDiv').html("");
	}
	function readExcelFile() {
		var file = document.getElementById('fileUpload').value;
		if (file == '') {
			$('#actionMessage').html("");
			$('#messageDiv').html("Please select an excel file to upload!");
			return false;

		}
		document.forms['bcMasterForm'].action = "readExcelToUploadBC.action";
		document.forms['bcMasterForm'].submit();
	}
	$.subscribe('loadGrid', function(event, data) {
		$("#bcGrid").jqGrid("setGridParam", {
			records : 0,
			page : 1
		}).trigger("reloadGrid");
	});
</script>
</head>
<body>
	<hr color="#F28500">
	<s:form id="bcMasterForm" name="bcMasterForm" method="post"
		theme="css_xhtml" enctype="multipart/form-data">
		<table width="100%">
			<tr>
			<td colspan="4" align="left">
				<div class="divSearchCondition"></div>
			</td>
		</tr>
		</table>
		<s:url var="bcGridURL" action="bcMastersGrid.action" />
		<sj:div id="gridDiv">
			<sjg:grid id="bcGrid" caption="BC Details" dataType="json"
				sortable="true" autowidth="true" href="%{bcGridURL}" pager="true"
				onSelectRowTopics="bcSelection" sortname="bcCode"
				gridModel="selectedBCList" viewrecords="true" rowList="10,15,20,25"
				cssStyle="cursor: pointer;" rowNum="10" rownumbers="true"
				navigatorEdit="false" navigatorAdd="false" navigatorDelete="false"
				navigatorSearch="true" navigator="true" navigatorView="true"
				reloadTopics="loadGrid" navigatorRefresh="false"
				navigatorSearchOptions="{multipleSearch:true,reloadAfterSubmit:true, 
				groupOps: [ { op: 'AND', text: 'All Match' }, { op: 'OR', text: 'Any of one' }],
				closeOnEscape:true,closeAfterSearch:true,searchOnEnter:true,onSearch:afterSearch,
				marksearched:true,onReset:clearSearch,dragable:true}"
				navigatorExtraButtons="{refresh:{title : 'Refresh',icon: 'ui-icon-refresh', topic:'loadGrid'}, 
			seperator: {title : 'seperator',icon: 'ui-separator'}}">


				<sjg:gridColumn name="bcCode" index="bcCode" title="BC Code"
					sorttype="int" sortable="true" search="true" searchtype="text"
					search="true" searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcName" index="bcName" title="BC Name"
					sortable="true" width="300" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bankCode" index="bankCode" title="Bank Code"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="branchCode" index="branchCode"
					title="Branch Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcAddress1" index="bcAddress1"
					title="BC Address1" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcAddress2" index="bcAddress2"
					title="BC Address2" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="pin" index="pin" title="Pin Code."
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="stateCode" index="stateCode"
					title="State Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="districtCode" index="districtCode"
					title="District Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="talukaCode" index="talukaCode"
					title="Taluka Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="villageCode" index="villageCode"
					title="Village Code" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="mobile" index="mobile" title="Mobile No."
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="cbsodAccNo" index="cbsodAccNo"
					title="BC OD A/c" sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcbfCode" index="bcbfCode" title="BC BF Code"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcsbac" index="bcsbac" title="BC SB A/c"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
				<sjg:gridColumn name="bcfdac" index="bcfdac" title="BC FD A/c"
					sortable="true" search="true"
					searchoptions=" {sopt:['eq','cn','bw']}" />
			</sjg:grid>
		</sj:div>
		<sj:div id="updateDiv" />
		<sj:div id="createButtonDiv">
			<table width="100%">
				<tr>
					<td style="float: left;"><small><sj:a button="true"
								id="createBC" name="createBC" onclick="createBc();">
							Create BC
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
												onclick="readExcelFile()">
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
		<sj:div id="updateButtonDiv">
			<small><sj:a button="true" id="updateBc" name="updateBc"
					onclick="updateBc();">
				Back
			</sj:a></small>
		</sj:div>
	</s:form>
</body>
</html>