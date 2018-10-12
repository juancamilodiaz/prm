<script src="/static/js/chartjs/Chart.bundle.js"></script>
<script src="/static/js/chartjs/Chart.min.js"></script>
<script src="/static/js/chartjs/Chart.PieceLabel.js"></script>

<script>
	$(document).ready(function () {
		$('#viewProductivity').DataTable({
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

		console.log("Objeto resource : ",{{ .Testeo }})
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Productivity Report");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick', null).off('click');
		$('#refreshButton').click(function () {
			reload('/productivity', {});
		});
	
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new task");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#taskModal");
		$('#buttonOption').attr("onclick", "configureCreateModal()");
		
		// only show the option if already exist a search
		if ({{.ProjectID}} == "" || {{.ProjectID}} == "Select a project..."){
			$('#buttonOption').css("display", "none");
			$("#main-content").collapse("hide");
			$("#tableData").collapse("hide");
			$("#filters").collapse("hide");
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
	
	searchProductivityReport = function(pProjectID){
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
			$("#filters").collapse("hide");
			$("#main-content").collapse("show");
			$("#tableData").collapse("show");
			$("#projectValue option[id="+projectID+"]").attr("selected", "selected");
			$("#titleSearch").html($("#projectValue").val());
		});
	}
	
	$(document).on('click','#updateTask',function(){
    	$('#taskModal').modal('show');
	});
	
	$(document).on('click','#deleteTask',function(){
    	$('#confirmModal').modal('show');
	});
	
	$(document).on('click','#manageReport',function(){
		console.log($('#actualHours').val());
		console.log($('#actualBillableHours').val());
		$('#reportHours').val($('#actualHours').val());
		$('#reportBillableHours').val($('#actualBillableHours').val());
    	$('#reportModal').modal('show');
	});	
	
	$(document).on('click','#manageBillableReport',function(){
		console.log($('#actualHours').val());
		console.log($('#actualBillableHours').val());
		$('#reportHours').val($('#actualHours').val());
		$('#reportBillableHours').val($('#actualBillableHours').val());
    	$('#reportBillableModal').modal('show');
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

<div class="row">
	<div class="col-sm-5">
		<button class="buttonHeader button2" data-toggle="collapse" data-target="#filters">
			<span class="glyphicon glyphicon-filter"></span> Filter 
		</button>
		<button class="buttonHeader button2" data-toggle="collapse" data-target="#tableData">
			<span class="glyphicon glyphicon-th-list"></span> Data Table 
		</button>
	</div>
	<div class="col-sm-5">
	</div>
	<div class="col-sm-2">
		<button class="buttonHeader button2" id="download-pdf" onclick="downloadPDF()" style="display: none;">
			<span class="glyphicon glyphicon-download-alt"></span> Download PDF
		</button>
	</div>
</div>

<div id="filters" class="collapse">
	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
			<label for="projectValue">Projects list:</label>
				<select class="form-control" id="projectValue">
					<option id="0">Select a project...</option>
					{{range $index, $project := .Projects}}
					<option id="{{$project.ID}}">{{$project.Name}}</option>
					{{end}}
				</select>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<br>
				<button class="buttonHeader button2" onclick="searchProductivityReport()">
				<span class="glyphicon glyphicon-search"></span> Search 
				</button>
			</div>
		</div>
	</div>
</div>
<div id="main-content" class="collapse">
	<div>
		<h3 id="titleSearch"></h3>
		<div class="col-md-12">
			<div class="col-md-2">
			</div>
			<div class="col-md-10">
				<div class="col-md-2">
				</div>
				<div class="col-md-2 Indicator" style="border-radius: 8px; margin: 2px; width: 210px;">
					<h4 style="text-align:  center;">Overall Progress</h4>
					<h1><p style="text-align:center;">{{.TOverallProgress}} %</p></h1>
				</div>
				<div class="col-md-2 Indicator" style="border-radius: 8px; margin: 2px; width: 210px;">
					<h4 style="text-align:  center;">Quoted Hours</h3>
					<h1><p style="text-align:center;">{{.TQuotedHours}} h</p></h1>
				</div>
				<div class="col-md-2 Indicator" style="border-radius: 8px; margin: 2px; width: 210px;">
					<h4 style="text-align:  center;">Billable Hours</h3>
					<h1><p style="text-align:center;">{{.TBillableHours}} h</p></h1>
				</div>
				<div class="col-md-2 Indicator" style="border-radius: 8px; margin: 2px; width: 210px;">
					<h4 style="text-align:  center;">Total Executed</h3>
					<h1><p style="text-align:center;">{{.TExecutedHours}} h</p></h1>
				</div>
				<div class="col-md-2 Indicator" style="border-radius: 8px; margin: 2px; width: 210px;">
					<h4 style="text-align:  center;">Out Of Scope</h4>
					<h1><p style="text-align:center;">{{.TOutOfScopeHours}} h</p></h1>
				</div>
			</div>
		</div>
		<div id="tableData" class="collapse" style="margin-top: 120px;">
		   	<table id="viewProductivity" class="table table-striped table-bordered border-fix">
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
									<a id="manageReport" onclick="$('#reportID').val({{$reportHours.ID}});$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val({{$reportHours.Hours}})"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
								{{else}}
									<a id="manageReport" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val(null)"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
								{{end}}
							{{else}}
								<a id="manageReport" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualHours').val(null)"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
							{{end}}
						</td>
						<td>
							{{$reportByTask := index $resourceReports $resource.ID}}
							{{if $reportByTask}}
								{{$reportHours := index $reportByTask.ReportByTask $productivityTask.ID}}
								{{if $reportHours}}
									{{$reportHours.HoursBillable}}
									<a id="manageBillableReport" onclick="$('#reportID').val({{$reportHours.ID}});$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val({{$reportHours.HoursBillable}})"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
								{{else}}
									<a id="manageBillableReport" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val(null)"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
								{{end}}
							{{else}}
								<a id="manageBillableReport" onclick="$('#reportID').val(null);$('#resourceID').val({{$resource.ID}});$('#taskID').val({{$productivityTask.ID}});$('#actualBillableHours').val(null)"> <span align="right" class="glyphicon glyphicon-pencil pull-right"></span></a>
							{{end}}
						</td>
						{{end}}
			            <td>{{$productivityTask.TotalExecute}}</td>
			            <td>{{$productivityTask.Scheduled}}</td>
						<td>{{$productivityTask.Progress}}%</td>
						<td><input type="checkbox" {{if $productivityTask.IsOutOfScope}}checked{{end}} disabled></td>
			            <td>
							<a id="updateTask" onclick="configureUpdateModal({{$productivityTask.ID}},'{{$productivityTask.Name}}',{{$productivityTask.Scheduled}},{{$productivityTask.Progress}}, {{$productivityTask.IsOutOfScope}})"> <span class="glyphicon glyphicon-edit"></span></a>
							<a id="deleteTask" onclick="$('#taskID').val({{$productivityTask.ID}})"> <span class="glyphicon glyphicon-trash"></span></a>
			            </td>
		         	</tr>
		        {{end}}
		      	</tbody>
		   	</table>
		</div>
	</div>
	
	<div class="col-sm-12" style="margin-top:10px;">
		<div id="chart_div" class="col-sm-6">
			<p>
			   	<div class="chart-container" id="chartjs-wrapper">
					<h3>Tasks Executed Distribution</h3>
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
			</p>
		</div>
		<div id="chart2_div" class="col-sm-6">
			<p>
				<div class="chart-container-complete" id="chartjsBarCollab-wrapper" style="width: 50%;">
					<h3>Total Hours Per Engineers</h3>
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
							  "backgroundColor": window.chartColors.blue,
							  "yAxisID": "collaborators-axis",
							  "data": {{.ResourceHours}}
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
			</p>
		</div>
	</div>
	<div class="col-sm-12" style="margin-top:10px;">
		<p>
		   	<div id="chartjsBar-wrapper">
				<h3 style="text-align: center;">Hours Executed VS Hours Scheduled VS Hours Billable</h3>
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
							"borderColor": window.chartColors.green,
							"data": {{.TValuesBillable}}
				        },
						{
							"type": "bar",
							"label": "Executed",
							"backgroundColor": window.chartColors.greenclear,
							"yAxisID": "executed-axis",
							"data": {{.TValues}}
					    }, {
							"type": "bar",
							"label": "Scheduled",
							"backgroundColor": window.chartColors.greendark,
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
		</p>
	</div>
	<div class="col-sm-12" style="margin-top:10px;">		
		<div id="chartOutOfScope_div" class="col-sm-6">
			<h3 id="titleOutOfScope" style="text-align: center;">Out Of Scope Tasks</h3>
			<table id="viewProductivityOutOfScope" class="table table-striped table-bordered">
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
			</table>
			<p>
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
			</p>
		</div>	
		<div class="col-sm-6">
			<h3 id="titleOutOfScope" style="text-align: center;">Total Statistics</h3>
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
			<p>
				<h3 id="titleBillableOrNotBillable" style="text-align: center;">Percentage of billable task</h3>
			   	<div class="chart-container" id="chartjsBillable-wrapper" style="width: 36%;">
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
<div class="modal fade" id="confirmModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Delete Confirmation</h4>
         </div>
         <div class="modal-body">
            Are you sure you want to delete the task <b id="nameDelete"></b> from report?
            <br>
            <li>The resources will lose the reported times.</li>
         </div>
         <div class="modal-footer" style="text-align:center;">
            <button type="button" id="taskDelete" class="btn btn-default" onclick="deleteTask()" data-dismiss="modal">Yes</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
         </div>
      </div>
   </div>
</div>

<!-- Modal -->
<div class="modal fade" id="taskModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="modalTitle" class="modal-title"></h4>
         </div>
         <div class="modal-body">
            <input type="hidden" id="taskID">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
                  <div class="col-sm-8">
                     <input type="text" id="taskName" style="border-radius: 8px;">
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Scheduled"> Scheduled </label>
                  <div class="col-sm-8">
                     <input type="number" id="taskScheduled" style="border-radius: 8px;" min="0">
                  </div>
               </div>
            </div>
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Progress"> Progress </label>
                  <div class="col-sm-8">
                     <input type="number" id="taskProgress" style="border-radius: 8px;" min="0" max="100">
                  </div>
               </div>
            </div>
			<div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Is Out Of Scope"> Is Out Of Scope </label>
                  <div class="col-sm-8">
					<input type="checkbox" id="taskIsOutOfScope"><br/>
                  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" id="taskCreate" class="btn btn-default" onclick="createTask()" data-dismiss="modal">Create</button>
            <button type="button" id="taskUpdate" class="btn btn-default" onclick="updateTask()" data-dismiss="modal">Update</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
         </div>
      </div>
   </div>
</div>

<!-- Modal -->
<div class="modal fade" id="reportModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="modalTitle" class="modal-title">Report Hours</h4>
         </div>
         <div class="modal-body">
			<input type="hidden" id="reportID">
			<input type="hidden" id="resourceID">
			<input type="hidden" id="actualHours">
			<input type="hidden" id="actualBillableHours">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours </label>
                  <div class="col-sm-8">
                     <input type="number" id="reportHours" style="border-radius: 8px;" min="0" max="100">
                  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" id="reportAdd" class="btn btn-default" onclick="manageReport()" data-dismiss="modal">OK</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
         </div>
      </div>
   </div>
</div>

<!-- Modal -->
<div class="modal fade" id="reportBillableModal" role="dialog">
   <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 id="modalTitle" class="modal-title">Report Billable Hours</h4>
         </div>
         <div class="modal-body">
			<input type="hidden" id="reportID">
			<input type="hidden" id="resourceID">
			<input type="hidden" id="actualBillableHours">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label class="control-label col-sm-4 translatable" data-i18n="Hours"> Hours Billable </label>
                  <div class="col-sm-8">
                     <input type="number" id="reportBillableHours" style="border-radius: 8px;" min="0" max="100">
                  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
            <button type="button" id="reportBilableAdd" class="btn btn-default" onclick="manageBillableReport()" data-dismiss="modal">OK</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
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
