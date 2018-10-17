<script src="/static/js/chartjs/Chart.bundle.js"></script>
<script src="/static/js/chartjs/Chart.min.js"></script>
<script src="/static/js/chartjs/Chart.PieceLabel.js"></script>
<script>
	$(document).ready(function () {
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		$('select').material_select();
		$('#viewProductivity').DataTable({			
			"iDisplayLength": 20,
			"bLengthChange": false,
			"columns": [
				null,
				{{range .Resources}}
				{"className":'border-fix'},
				{"className":'border-fix'},
				{{else}}
				null,
				null,
				{{end}}
				null,
				null,
				null,
				null,
				{
					"searchable": false
				}
			],
			"paging": false
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Productivity Report");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick', null).off('click');
		$('#refreshButton').click(function () {
			reload('/productivity', {});
		});
			
		// only show the option if already exist a search
		if ({{.ProjectID}} == "" || {{.ProjectID}} == "Select a project..."){
			$('#buttonOption').css("display", "none");
			//searchProductivityReport(361); //Temporal code, must be removed
		}

	});
	
	configureCreateModal = function () {
	
		$("#taskID").val(null);
		$("#taskName").val(null);
		$("#taskScheduled").val(null);
		$("#taskProgress").val(null);
		$("#taskIsOutOfScope").prop('checked', false);
	
		$("#modalTitle").html("Create Task");
		$("#taskCreate").css("display", "inline-block");
		$("#taskUpdate").css("display", "none");
	}
	
	configureUpdateModal = function (pID, pName, pScheduled, pProgress, pIsOutOfScope) {
	
		$("#taskID").val(pID);
		$("#taskName").val(pName);
		$("#taskScheduled").val(pScheduled);
		$("#taskProgress").val(pProgress);
		$("#taskIsOutOfScope").prop('checked', pIsOutOfScope);
	
		$("#modalTitle").html("Update Task");
		$("#taskCreate").css("display", "none");
		$("#taskUpdate").css("display", "inline-block");
	}
	
	createTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/createtask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ProjectID": {{.ProjectID}},
				"Name": $('#taskName').val(),
				"Scheduled": $('#taskScheduled').val(),
				"Progress": $('#taskProgress').val(),
				"IsOutOfScope": $('#taskIsOutOfScope').is(":checked")
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	updateTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/updatetask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#taskID').val(),
				"Name": $('#taskName').val(),
				"Scheduled": $('#taskScheduled').val(),
				"Progress": $('#taskProgress').val(),
				"IsOutOfScope": $('#taskIsOutOfScope').is(":checked")
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	deleteTask = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/deletetask',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#taskID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	$("#projectValue").change(function(){
		var projectID = $('#projectValue option:selected').attr('id');
		searchProductivityReport(projectID);

	});

	searchProductivityReport = function(pProjectID){
		$(".searchReport").hide();
		$(".loadingIcon").show();
		var projectID = $('#projectValue option:selected').attr('id');
		if (pProjectID != null){
			projectID = pProjectID;
		}		
		var settings = {
			method: 'POST',
			url: '/productivity',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectID": projectID
			}
		}
		$.ajax(settings).done(function (response) {
			$("#content").html(response);				
			$("#projectValue option[id="+projectID+"]").attr("selected", "selected");
			//$("#titleSearch").html($("#projectValue").val());	
			//console.warn($("#projectValue").val());	
			$("#titleSearch").html(" - "+$("#projectValue").val());
			$("#main-content2").show();	
			$(".progressInfo").show();
			$(".searchReport").show();
			$(".loadingIcon").hide();
		});		
	}
	
	$(document).on('click','#manageReport',function(){
		console.log($('#actualHours').val());
		console.log($('#actualBillableHours').val());
		$('#reportHours').val($('#actualHours').val());
		$('#reportBillableHours').val($('#actualBillableHours').val());
	});	
	
	$(document).on('click','#manageBillableReport',function(){
		console.log($('#actualHours').val());
		console.log($('#actualBillableHours').val());
		$('#reportHours').val($('#actualHours').val());
		$('#reportBillableHours').val($('#actualBillableHours').val());
	});
		
	manageReport = function () {
		if ($('#actualHours').val() == "" && $('#reportHours').val() != "") {
			createReport();
			console.log("Create");
		} else if ($('#actualHours').val() != "" && $('#reportHours').val() != "") {
			updateReport();
			console.log("Update");
		} else if ($('#actualHours').val() != "" && $('#reportHours').val() == "") {
			deleteReport();
			console.log("Delete");
		}
	}
	
	manageBillableReport = function () {
		if ($('#actualBillableHours').val() == "" && $('#reportBillableHours').val() != "") {
			createBillableReport();
			console.log("CreateBillable");
		} else if ($('#actualBillableHours').val() != "" && $('#reportBillableHours').val() != "") {
			updateBillableReport();
			console.log("UpdateBillable");
		} else if ($('#actualBillableHours').val() != "" && $('#reportBillableHours').val() == "") {
			deleteReport();
			console.log("DeleteBillable");
		}
	}
	
	createReport = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/createreport',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"TaskID": $('#taskID').val(),
				"ResourceID": $('#resourceID').val(),
				"Hours": $('#reportHours').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	createBillableReport = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/createreport',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"TaskID": $('#taskID').val(),
				"ResourceID": $('#resourceID').val(),
				"HoursBillable": $('#reportBillableHours').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
		
	updateReport = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/updatereport',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#reportID').val(),
				"Hours": $('#reportHours').val(),
				"HoursBillable": $('#reportBillableHours').val(),
				"IsBillable": false
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	updateBillableReport = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/updatereport',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#reportID').val(),
				"Hours": $('#reportHours').val(),
				"HoursBillable": $('#reportBillableHours').val(),
				"IsBillable": true
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	deleteReport = function () {
		var settings = {
			method: 'POST',
			url: '/productivity/deletereport',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"ID": $('#reportID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			searchProductivityReport({{.ProjectID}});
		});
	}
	
	//donwload pdf from original canvas
	downloadPDF = function() {
		
	  	var canvasTaskExecuted = document.querySelector('#chartjs');
		//creates image
		var canvasTaskExecutedImg = canvasTaskExecuted.toDataURL("image/jpg", 1.0);
		
		var canvasBarCollab = document.querySelector('#chartjsBarCollab');
		var canvasBarCollabImg = canvasBarCollab.toDataURL("image/jpg", 1.0);
		
		var canvasBar = document.querySelector('#chartjsBar');
		var canvasBarImg = canvasBar.toDataURL("image/jpg", 1.0);
		
		var canvasOutOfScope = document.querySelector('#chartjsOutOfScope');
		var canvasOutOfScopeImg = canvasOutOfScope.toDataURL("image/jpg", 1.0);
		
		var canvasBillable = document.querySelector('#chartjsBillable');
		var canvasBillableImg = canvasBillable.toDataURL("image/jpg", 1.0);
	  
		//creates PDF from img
		var doc = new jsPDF('landscape', 'mm', 'letter');
		doc.setProperties({
			title: 'Productivity Report'
		});
		doc.setFontSize(20);
		doc.text("Productivity Report", 139.5, 20, 'center' );
		
		doc.roundedRect(7, 30, 57, 20, 3, 3); // empty square  
		doc.text("Overall Progress", 35, 40, 'center' );
		doc.text("{{.TOverallProgress}} %", 35, 48, 'center' );
		
		doc.roundedRect(66, 30, 48, 20, 3, 3); // empty square 
		doc.text("Quoted Hours", 90, 40, 'center' );
		doc.text("{{.TQuotedHours}} h", 90, 48, 'center' );
		
		doc.roundedRect(116, 30, 48, 20, 3, 3); // empty square 
		doc.text("Billable Hours", 140, 40, 'center' );
		doc.text("{{.TBillableHours}} h", 140, 48, 'center' );
		
		doc.roundedRect(166, 30, 51, 20, 3, 3); // empty square 
		doc.text("Total Executed", 191, 40, 'center' );
		doc.text("{{.TExecutedHours}} h", 191, 48, 'center' );
		
		doc.roundedRect(219, 30, 49, 20, 3, 3); // empty square 
		doc.text("Out Of Scope", 243, 40, 'center' );
		doc.text("{{.TOutOfScopeHours}} h", 243, 48, 'center' );
		
		doc.text("Tasks Executed Distribution", 69.25, 70, 'center' );
		doc.addImage(canvasTaskExecutedImg, 'JPEG', 10, 80, 100, 100);
		
		doc.text("Percentage of billable task", 210, 70, 'center' );
		doc.addImage(canvasBillableImg, 'JPEG', 170, 80, 100, 100);
		
		doc.addPage();
		
		doc.text("Total Hours Per Engineers", 139.5, 20, 'center' );
		//doc.addImage(canvasBillableImg, 'JPEG', 10, 40, 100, 100);
		//doc.addImage(canvasBarImg, 'JPEG', 10, 40, 200, 100);
		doc.addImage(canvasBarCollabImg, 'JPEG', 10, 40, 50, 50);
		
		doc.addPage();
		
		/*
		doc.addImage(canvasTaskExecutedImg, 'JPEG', 10, 40, 100, 100);
		
		doc.addImage(canvasBarCollabImg, 'JPEG', 120, 40, 100, 100);
		
		doc.addImage(canvasBarImg, 'JPEG', 10, 140, 100, 200);
		
		doc.addImage(canvasOutOfScopeImg, 'JPEG', 10, 240, 100, 100);
		
		doc.addImage(canvasBillableImg, 'JPEG', 90, 240, 100, 100);*/
			
		var columns = ["Task",
						{{range $resource := .Resources}}
							"{{$resource.Name}} {{$resource.LastName}}",	
						{{end}}
						"Total Execute", "Scheduled", "Progress", "Is Out Of Scope"];
		var rows = [
		{{$resources := .Resources}}
		{{$resourceReports := .ResourceReports}}
		{{range $key, $productivityTask := .ProductivityTasks}}
		    ["{{$productivityTask.Name}}",
			{{range $resource := $resources}}
				{{$reportByTask := index $resourceReports $resource.ID}}
				{{if $reportByTask}}
					{{$reportHours := index $reportByTask.ReportByTask $productivityTask.ID}}
					{{if $reportHours}}
						"{{$reportHours.Hours}} - {{$reportHours.HoursBillable}}",
					{{else}}
						"0 - 0",
					{{end}}
				{{else}}
					"0 - 0",
				{{end}}
			{{end}}
			{{$productivityTask.TotalExecute}}, {{$productivityTask.Scheduled}}, {{$productivityTask.Progress}}, "{{$productivityTask.IsOutOfScope}}"],
		{{end}}	
		];		
		
		doc.text("Report", 139.5, 20, 'center' );
		doc.autoTable(columns, rows, {
			startY: 40
		});
		
		$('#objectPdf').attr('data', doc.output('datauristring'));
		$('#showDocumentPDF').modal('show');
	}  
</script>
<div class="containerProductivity">
<h4 id="titlePag"> </h4><h4 id="titleSearch"></h4> 

<a id="buttonOption" class="btn blue waves-effect waves-blue btn-flat modal-trigger white-text" href="#taskModal" onclick="configureCreateModal()" >New Task</a>
		<div class="row">
			<div class="col s6">
					<label for="projectValue" class="active">Projects list: </label>
					<select id="projectValue">
						<option id="0">Select a project...</option>
						{{range $index, $project := .Projects}}
						<option id="{{$project.ID}}">{{$project.Name}}</option>
						{{end}}
					</select>
			</div>
		<div class="col s6"> 
	<!--	<br><a class="btn waves-effect waves-light blue searchReport" onclick="searchProductivityReport()"><i class="mdi-action-search"></i></a>-->
		
			<div class="preloader-wrapper active loadingIcon">
				<div class="spinner-layer spinner-blue-only">
				<div class="circle-clipper left">
					<div class="circle"></div>
				</div><div class="gap-patch">
					<div class="circle"></div>
				</div><div class="circle-clipper right">
					<div class="circle"></div>
				</div>
				</div>
			</div>
			</div>
	</div>

<div id="main-content2">
	<div class="row">
			<div class="progressInfo">
				<div class="col s4 m3 l2">
					<div class="card">
						<div class="card-content blue white-text">
							<h6 style="text-align:  center;">Overall Progress</h6>
							<p style="text-align:center;">{{.TOverallProgress}} %</p></h1>												
						</div>
					</div>
				</div>	
				<div class="col s4 m3 l2">
					<div class="card">
						<div class="card-content blue white-text">
							<h6 style="text-align:  center;">Quoted Hours</h6>
							<p style="text-align:center;">{{.TQuotedHours}} h</p>
						</div>
					</div>
				</div>				
				<div class="col s4 m3 l2">
					<div class="card">
						<div class="card-content blue white-text">
							<h6 style="text-align:  center;">Billable Hours</h6>
							<p style="text-align:center;">{{.TBillableHours}} h</p>
						</div>
					</div>
				</div>
				<div class="col s4 m3 l2">
					<div class="card">
						<div class="card-content blue white-text">
							<h6 style="text-align:  center;">Total Executed</h6>
							<p style="text-align:center;">{{.TExecutedHours}} h</p>
						</div>
					</div>
				</div>
				<div class="col s4 m3 l2">
					<div class="card">
						<div class="card-content blue white-text">
							<h6 style="text-align:  center;">Out Of Scope</h6>
							<p style="text-align:center;">{{.TOutOfScopeHours}} h</p>
						</div>
					</div>
				</div>
			</div>	
		<div id="tableData"> 
		   	<table  id="viewProductivity" class="display" cellspacing="0" width="90%" >
			    <thead>
			    	<tr>
			        	<th rowspan="2" style="text-align:center;">Task</th>
						{{range $index, $resource := .Resources}}
						<th colspan="2" style="text-align:center;">{{$resource.Name}} {{$resource.LastName}}</th>
						{{end}}
			        	<th rowspan="2" style="text-align:center;">Total Execute</th>
			         	<th rowspan="2" style="text-align:center;">Scheduled</th>
						<th rowspan="2" style="text-align:center;">Progress</th>
						<th rowspan="2" style="text-align:center;">Is Out Of Scope</th>
			         	<th rowspan="2" style="text-align:center;">Options</th>
			      	</tr>
					<tr>
						{{range .Resources}}
						<th style="text-align:center;">Hours</th>
			        	<th style="text-align:center;">Hours Billable</th>
						{{else}}
						<th style="text-align:center;">Hours</th>
			        	<th style="text-align:center;">Hours Billable</th>
						{{end}}
			      	</tr>

			    </thead>
		    	<tbody>
				{{$resources := .Resources}}
				{{$resourceReports := .ResourceReports}}
		        {{range $key, $productivityTask := .ProductivityTasks}}
		        	<tr>
		        		<td>{{$productivityTask.Name}}</td>
						{{range $index, $resource := $resources}}
						<td>
							{{$reportByTask := index $resourceReports $resource.ID}}
							{{if $reportByTask}}
								{{$reportHours := index $reportByTask.ReportByTask $productivityTask.ID}}
								{{if $reportHours}}
									{{$reportHours.Hours}}
									<a id="manageReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportModal" onclick="$('#reportID').val({{$reportHours.ID}});$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val({{$reportHours.Hours}})"> <i class="mdi-editor-mode-edit tiny"></i></a>
								{{else}}
									<a id="manageReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportModal" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val(null)"> <i class="mdi-editor-mode-edit tiny"></i></a>
								{{end}}
							{{else}}
								<a id="manageReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportModal" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val(null)"><i class="mdi-editor-mode-edit tiny"></i></a>
							{{end}}
						</td>
						<td>
							{{$reportByTask := index $resourceReports $resource.ID}}
							{{if $reportByTask}}
								{{$reportHours := index $reportByTask.ReportByTask $productivityTask.ID}}
								{{if $reportHours}}
									{{$reportHours.HoursBillable}}
									<a id="manageBillableReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportBillableModal" onclick="$('#reportID').val({{$reportHours.ID}});$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val({{$reportHours.HoursBillable}})"> <i class="mdi-editor-mode-edit tiny"></i></a>
								{{else}}
									<a id="manageBillableReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportBillableModal" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val(null)"> <i class="mdi-editor-mode-edit tiny"></i></a>
								{{end}}
							{{else}}
								<a id="manageBillableReport" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportBillableModal" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val(null)"><i class="mdi-editor-mode-edit tiny"></i></a>
							{{end}}
						</td>
						{{end}}
			            <td>{{$productivityTask.TotalExecute}}</td>
			            <td>{{$productivityTask.Scheduled}}</td>
						<td>{{$productivityTask.Progress}}%</td>
						<td><input type="checkbox" {{if $productivityTask.IsOutOfScope}}checked{{end}} disabled></td>
			            <td>
							<a id="updateTask" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#taskModal" onclick="configureUpdateModal({{$productivityTask.ID}},'{{$productivityTask.Name}}',{{$productivityTask.Scheduled}},{{$productivityTask.Progress}}, {{$productivityTask.IsOutOfScope}})"><i class="mdi-editor-mode-edit tiny"></i></a>
							<a id="deleteTask" class="modal-trigger tooltipped" data-position="top" data-tooltip="Delete" href="#confirmModal" onclick="$('#taskID').val({{$productivityTask.ID}})"> <i class="mdi-action-delete tiny"></i></a>
			            </td>
		         	</tr>
		        {{end}}
		      	</tbody>
		   	</table>
		</div>
	</div>
	<div class="row">
		<div id="chart_div" class="col s5" >
			   	<div class="chart-container" id="chartjs-wrapper">
					<h5>Tasks Executed Distribution</h5>
					<canvas id="chartjs">
					</canvas>	

					<script>
						var seq = 0;
						{{if .TValues}}
							seq = {{len .TValues}};
						{{end}}					
						var colorF = new Array(seq);
						colorF.fill("white", 0, seq);
						chart2=new Chart(document.getElementById("chartjs"),
						{	"type": "pie",
							"responsive":true,
							"data": {
								"labels": {{.TLabels}},
								"datasets": [{ 
									"data": {{.TValues}},
									"backgroundColor": palette('tol', seq).map(function(hex) {
													   		return '#' + hex;
									})
								}]						
							},
							options: {
							  pieceLabel: {
							    render: 'percentage',
							    fontColor: colorF,
							    precision: 2
							  }
							}
						});
					</script>			
				</div>
		</div>
		<div id="chart2_div" class="col s6">
				<div class="chart-container-complete" id="chartjsBarCollab-wrapper">
					<h5>Total Hours Per Engineers</h5>
					<canvas id="chartjsBarCollab">
					</canvas>				
					<script>			
						chart3=new Chart(document.getElementById("chartjsBarCollab"),
						{
						  "type": "bar",
						  "data": {
							"labels": {{.ResourcesNames}},
							"datasets": [{
							  "label": "Hours",
							  "yAxisID": "collaborators-axis",
							  "data": {{.ResourceHours}},
							  "backgroundColor": palette('tol', seq).map(function(hex) {
													   		return '#' + hex;
									})
							}]
						  },
						  options: {
							responsive: true,
							scales: {
							  yAxes: [{
								id: 'collaborators-axis',
								type: 'linear'
							  }]
							}
						  }
						});
					</script>			
				</div>
		</div>
		<div class="col s12">
				<div id="chartjsBar-wrapper" style="width:90%">
					<h5 style="text-align: center;">Hours Executed VS Hours Scheduled VS Hours Billable</h5>
					<canvas id="chartjsBar">
					</canvas>			
					<script>				
						chart4=new Chart(document.getElementById("chartjsBar"),
						{
							"type": "bar",
							"data": {
							"labels": {{.TLabels}},
							"datasets": [{
								"type": "line",
								"label": "Billable",
								"borderColor": palette('tol', seq).map(function(hex) {
																return '#' + hex}),
								"data": {{.TValuesBillable}}
							},
							{
								"type": "bar",
								"label": "Executed",
								"backgroundColor": palette('tol', seq).map(function(hex) {
																return '#' + hex}),
								"yAxisID": "executed-axis",
								"data": {{.TValues}}
							}, {
								"type": "bar",
								"label": "Scheduled",
								"backgroundColor":palette('tol', seq).map(function(hex) {
																return '#' + hex}),
								"yAxisID": "scheduled-axis",
								"data": {{.TValuesScheduled}}
							}]
						},
						options: {
							responsive: true,
							scales: {
							yAxes: [{
								id: 'executed-axis',
								type: 'linear',
								position: 'left',
							}, {
								id: 'scheduled-axis',
								type: 'linear',
								position: 'right',
								ticks: {
								max: 100,
								min: 0
								}
							}]
							}
						}
						});
					</script>		
				</div>			
		</div>
		<div class="col s4" >		
			<div id="chartOutOfScope_div">
				<h5 id="titleOutOfScope" style="text-align: center;">Out Of Scope Tasks</h5>
				<!--<table id="viewProductivityOutOfScope" class="table table-striped table-bordered">
					<thead>
						<tr>
							<th>Task</th>
							<th>Hours</th>
						</tr>
					</thead>
					<tbody>
						{{$resources := .Resources}}
						{{$resourceReports := .ResourceReports}}
						{{range $key, $productivityTask := .ProductivityTasks}}
							{{if $productivityTask.IsOutOfScope}}
							<tr>
								<td>{{$productivityTask.Name}}</td>
								<td>{{$productivityTask.TotalExecute}}</td>
							</tr>
							{{end}}
						{{end}}
					</tbody>
				</table>-->
					<div class="chart-container" id="chartjsOutOfScope-wrapper">
						<canvas id="chartjsOutOfScope">
						</canvas>					
						<script>
							var seq = 0;
							{{if .TValuesOutOfScope}}
								seq = {{len .TValuesOutOfScope}};
							{{end}}					
							var colorF = new Array(seq);
							colorF.fill("white", 0, seq);
							chart5=new Chart(document.getElementById("chartjsOutOfScope"),
							{	"type": "pie",
								"data": {
									"labels": {{.TLabelsOutOfScope}},
									"datasets": [{ 
										"data": {{.TValuesOutOfScope}},
										"backgroundColor": palette('tol', seq).map(function(hex) {
																return '#' + hex;
														})
									}]						
								},
								options: {
								pieceLabel: {
									render: 'percentage',
									fontColor: colorF,
									precision: 2
								}
								}
							});						
						</script>		
					</div>			
			</div>
		</div>	
		<div class="col s3">
			<h5 id="titleOutOfScope" style="text-align: center;">Total Statistics</h5>
			<table id="viewProductivityStatistics" class="table table-striped table-bordered">
			    <thead>
			        <tr>
			            <th>Description</th>
			            <th>Total</th>
			        </tr>
			    </thead>
			    <tbody>
					<tr>
			            <td>Total of Executed hours</td>
			            <td>{{.TotalHoursExecutedProject}}h</td>
			        </tr>
					<tr>
			            <td>Total of Additional hours</td>
			            <td>{{.TotalAdditionalHours}}h</td>
			        </tr>
					<tr>
			            <td>Contrast between Real and Estimated time</td>
			            <td>{{.RealVsEstimated}}%</td>
			        </tr>
					<tr>
			            <td>Contrast between Estimated and Real time</td>
			            <td>{{.EstimatedVsReal}}%</td>
			        </tr>
					<tr>
			            <td>% Out of Scope value</td>
			            <td>{{.OutOfScope}}%</td>
			        </tr>
			    </tbody>
			</table>
		</div>
		<div class="col s4">
				<h5 id="titleBillableOrNotBillable" style="text-align: center;">Percentage of billable task</h5>
			   	<div class="chart-container" id="chartjsBillable-wrapper" style="width: 100%;">
					<canvas id="chartjsBillable">
					</canvas>				
					<script>
						var seq = 0;
						{{if .TValuesBillableOrNotBillable}}
							seq = {{len .TValuesBillableOrNotBillable}}+2;
						{{end}}					
						var colorF = new Array(seq);
						colorF.fill("white", 0, seq);
						chart6=new Chart(document.getElementById("chartjsBillable"),
						{	"type": "pie",
							"data": {
								"labels": ["Not Billable", "Billable"],
								"datasets": [{ 
									"data": {{.TValuesBillableOrNotBillable}},
									"backgroundColor": palette('tol', seq).map(function(hex) {
													   		return '#' + hex;
									 })
								}]						
							},
							options: {
							  pieceLabel: {
							    render: 'percentage',
							    fontColor: colorF,
							    precision: 2
							  }
							}
						});
					</script>
			
				</div>
			</p>
		</div>
	</div>
</div>

<div class="modal" id="confirmModal">
      <div class="modal-content">
            <h5 class="modal-title">Delete Confirmation</h5>
			<div class="divider CardTable"></div>
            Are you sure you want to delete the task <b id="nameDelete"></b> from report?
            <br>
            <li>The resources will lose the reported times.</li>
       
         <div class="modal-footer" style="text-align:center;">
           <a class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="deleteTask()" >Delete</a>
			<a class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
         </div>
      </div>
   </div>
</div>

<!-- Modal -->
<div class="modal" id="taskModal">
        <div class="modal-content">
            <h5 id="modalTitle" class="modal-title"></h5>
			 <div class="divider"></div><br> 

            <input type="hidden" id="taskID">
			<div class="input-field col s12 m5 l5">
				<label class="active" for="taskName"> Name </label>
				<input type="text" id="taskName">
			</div>
			<div class="input-field col s12 m5 l5">
				<label class="active" for="taskScheduled"> Scheduled </label>
				<input type="number" id="taskScheduled">
			</div>
			<div class="input-field col s12 m5 l5">
				<label class="active" for="taskProgress"> Progress </label>
				<input type="number" id="taskProgress">
			</div>
			<div class="input-field col s12 m5 l5">
				<input type="checkbox" id="taskIsOutOfScope">
				<label for="taskIsOutOfScope">Is Out Of Scope </label>
			</div>
			
         </div>
         <div class="modal-footer">
			<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
            <a id="taskCreate" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="createTask()" >Create</a>
            <a id="taskUpdate" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="updateTask()" >Update</a>
         </div>
      </div>
   </div>
</div>
<!-- Modal -->
<div class="modal" id="reportModal">
   		<div class="modal-content">
            <h5 id="modalTitle" class="modal-title">Report Hours</h5>
			<div class="divider"></div><br>
			<input type="hidden" id="reportID">
			<input type="hidden" id="resourceID">
			<input type="hidden" id="actualHours">
			<input type="hidden" id="actualBillableHours">
            <div class="input-field col s12 m5 l5">
				<label class="active"> Hours </label>                  
				<input type="number" id="reportHours" min="0" max="100">
            </div>	
        </div>
         <div class="modal-footer">
			<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
            <a class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="manageReport()" >Edit</a>
         </div>
      </div>
</div>
<!-- Modal --> 
<div class="modal" id="reportBillableModal">
    <div class="modal-content">
            <h5 id="modalTitle" class="modal-title">Report Billable Hours</h5>
			<div class="divider"></div> <br>
			<input type="hidden" id="reportID">
			<input type="hidden" id="resourceID">
			<input type="hidden" id="actualBillableHours">
            <div class="input-field col s12 m5 l5">
				<label class="active" for="reportBillableHours">  Hours Billable </label>
            	<input type="number" id="reportBillableHours"  min="0" max="100">
            </div>
         </div>
         <div class="modal-footer">
			<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			<a class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" onclick="manageBillableReport()" >Edit</a>
         </div>
      </div>
   </div>
</div>

<!-- Modal PDF -->
<div id="showDocumentPDF" class="modal fade" role="dialog">
	<div class="modal-dialog" style="width: 95%;height: 90%;padding: 0;">	
		<!-- Modal content-->
		<div class="modal-content" style="height: 100%;">
		  <div class="modal-header">
		    <button type="button" class="close" data-dismiss="modal">&times;</button>
		    <h4 class="modal-title">Preview Productivity Rerport</h4>
		  </div>
		  <div class="modal-body" style="height: 80%">
			<object id="objectPdf" type="application/pdf" width="100%" height="100%"></object>
		  </div>
		  <div class="modal-footer">
		    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		  </div>
		</div>	
	</div>
</div>