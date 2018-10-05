<script src="/static/js/chartjs/Chart.bundle.js"></script>
<script src="/static/js/chartjs/Chart.min.js"></script>
<script src="/static/js/chartjs/Chart.PieceLabel.js"></script>

<script>
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		
		var atable = $('#viewWorkLoadByTypes').DataTable({
			"sDom": '<"search-box"r>lftip',
			"iDisplayLength": 20,
			"bLengthChange": false
		});
		var atable2 = $('#viewWorkLoadByPercentage').DataTable({		
			"iDisplayLength": 20,
			"bLengthChange": false
		});

		var oTable = $('#viewProjectsForecast').DataTable( {
			"sDom": '<"search-box"r>lftip',
			"iDisplayLength": 20,
			"bLengthChange": false,
	        order: [[ 1, 'asc' ]],
	        columns: [
	            {name: 'BusinessUnit', "orderable": false},
				{name: 'Region', "orderable": false},
				{name: 'ID', "orderable": false},
				{name: 'Name', "orderable": false},
				{name: 'Description', "orderable": false},
				{name: 'StartDate', "orderable": false},
				{name: 'EndDate', "orderable": false},
				{name: 'NumberSites', "orderable": false},
				{name: 'NumberProcessPerSite', "orderable": false},
				{name: 'MOMResources', "orderable": false},
				{name: 'DEVResources', "orderable": false},
				{name: 'TotalResources', "orderable": false},
				{name: 'EstimateCost', "orderable": false},
				{name: 'BillingDate', "orderable": false},
				{name: 'Status', "orderable": false},
				{name: 'Options', "searchable":false}
	        ]
	    } );
				
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		$('#backButton').prop('onclick',null).off('click');
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projectsForecast',{});
		});
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Forecast Project");
		//$('#buttonOption').attr("onclick","createForecastProject()");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#projectForecastModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
	});
	
	configureCreateModal = function(){
		
		$("#projectForecastID").val(null);
		$("#projectBusinessUnit").val(null);
		$("#projectForecastRegion").val(null);
		$("#projectForecastName").val(null);
		$("#projectForecastStartDate").val(null);		
		$("#projectForecastEndDate").val(null);
		
		$("#modalProjectForecastTitle").html("Create Forecast Project");
		$("#projectForecastUpdate").css("display", "none");
		$("#projectForecastCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pOperationCenter, pWorkOrder, pName, pStartDate, pEndDate, pActive, pLeaderID){
		
		$("#projectID").val(pID);
		$("#projectOperationCenter").val(pOperationCenter);
		$("#projectWorkOrder").val(pWorkOrder);
		$("#projectName").val(pName);
		
		$("#projectStartDate").val(pStartDate);
		$("#projectEndDate").val(pEndDate);
		$("#projectEndDate").attr("min", pStartDate);
		$("#projectActive").prop('checked', pActive);
		
		$("#leaderID").val(0);
		if (pLeaderID != null) {
			$("#leaderID").val(pLeaderID);
		}
		$("#modalProjectTitle").html("Update Project");
		$("#projectCreate").css("display", "none");
		$("#projectUpdate").css("display", "inline-block");
		$("#divProjectType").css("display", "none");
	}
	
	createForecastProject = function(){
		var settings = {
			method: 'POST',
			url: '/projectsForecast/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"BusinessUnit": $('#projectBusinessUnit').val(),
				"Region": $('#projectForecastRegion').val(),
				"Name": $('#projectForecastName').val(),
				"StartDate": $('#projectForecastStartDate').val(),
				"EndDate": $('#projectForecastEndDate').val()
			}
		}
		$.ajax(settings).done(function (response) {
		  	var data = {
				"default":true
			}
			reload('/projectsForecast',data);
		});
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/projects/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteForecastProject = function(){
		var settings = {
			method: 'POST',
			url: '/projectsForecast/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#projectID').val()
			}
		}
		$.ajax(settings).done(function (response) {
		 	var data = {
				"default":true
			}
			reload('/projectsForecast',data);
		});
	}
	
	updateForecastProject = function(){
		var value = "";
		var valueNumber = 0;
		var valueDate = new Date();
		var field = "";
		
		var dataToUpdate = null;
		
		switch ($('#field').html()) {
		  case "Business Unit":
			value = $('#value').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"BusinessUnit" : value
			} 
		    break;
		  case "Region":
			value = $('#value').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"Region" : value
			} 
		    break;
		  case "Name":
			value = $('#value').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"Name" : value
			} 
		    break;
		  case "Description":
			value = $('#value').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"Description" : value
			} 
		    break;
		  case "Status":
			value = $('#value').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"Status" : value
			} 
		    break;
		  case "Start Date":
			valueDate = $('#valueDate').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"StartDate" : valueDate
			} 
		    break;
		  case "End Date":
			valueDate = $('#valueDate').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"EndDate" : valueDate
			} 
		    break;
		  case "Billing Date":
			valueDate = $('#valueDate').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"BillingDate" : valueDate
			} 
		    break;
		  case "Number Of Sites":
			valueNumber = $('#valueNumber').val();
			if (valueNumber == 0) {
				valueNumber = -1;
			}
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"NumberSites" : valueNumber
			} 
		    break;
		  case "Number Of Process":
			valueNumber = $('#valueNumber').val();
			if (valueNumber == 0) {
				valueNumber = -1;
			}
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"NumberProcessPerSite" : valueNumber
			} 
		    break;
		  case "Estimate Cost":
			valueNumber = $('#valueNumber').val();
			if (valueNumber == 0) {
				valueNumber = -1;
			}
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"EstimateCost" : valueNumber
			} 
		    break;
		  case "MOM Resources":
			valueNumber = $('#valueNumber').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"TypeID" : $('#typeResourceId').val(),
				"TypeName": "MOM Engineer",
				"TypeNumberResources": valueNumber
			} 
		    break;
		  case "DEV Resources":
			valueNumber = $('#valueNumber').val();
			dataToUpdate = { 
				"ID": $('#reportID').val(),
				"TypeID" : $('#typeResourceId').val(),
				"TypeName": "Developer",
				"TypeNumberResources": valueNumber
			} 
		    break;
		  default:
		    console.log("Sorry, we are out of " + $('#field').html() + ".");
		}
		
		var settings = {
			method: 'POST',
			url: '/projectsForecast/update',
			headers: {
				'Content-Type': undefined
			},
			data: dataToUpdate
		}
		$.ajax(settings).done(function (response) {
		 	var data = {
				"default":true
			}
			reload('/projectsForecast',data);
		});
	}
	
	getResourcesByProject = function(projectID, projectName){
		var settings = {
			method: 'POST',
			url: '/projects/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ProjectId": projectID,
				"ProjectName": projectName
			}
		}
		$.ajax(settings).done(function (response) {
		  $("#content").html(response);
		  $('.modal-backdrop').remove();
		});
	}
	
	find = function(tableRow) {
	  var $table = tableRow.closest('table');
	  var query = "Project ID";
	  var result = tableRow.find('td').filter(function() {
	     return $table.find('th').index($(this).index()).html() === query;
	  });
	  alert(result.html());
	}
	
	$(document).on('click','#deleteProjectForecast',function(){
    	$('#confirmModal').modal('show');
	});
	
	openCity = function(evt, cityName) {
	    // Declare all variables
	    var i, tabscontent, tablinks;
	
	    // Get all elements with class="tabcontent" and hide them
	    tabscontent = document.getElementsByClassName("tabscontent");
	    for (i = 0; i < tabscontent.length; i++) {
	        tabscontent[i].style.display = "none";
	    }
	
	    // Get all elements with class="tablinks" and remove the class "active"
	    tablinks = document.getElementsByClassName("tablinks");
	    for (i = 0; i < tablinks.length; i++) {
	        tablinks[i].className = tablinks[i].className.replace(" active", "");
	    }
	
	    // Show the current tab, and add an "active" class to the button that opened the tab
	    document.getElementById(cityName).style.display = "block";
	    evt.currentTarget.className += " active";
	}
	
	// Get the element with id="defaultOpen" and click on it
	{{if .Default}}
		document.getElementById("planningOpen").click();
	{{else}}
		document.getElementById("defaultOpen").click();
	{{end}}
	
	$(document).on('click','#manageForecast',function(){
		$('#value').css("display", "inline-block");
		$('#valueNumber').css("display", "none");
		$('#valueDate').css("display", "none");
		$('#projectType').css("display", "none");
		$('#value').val($('#actualValue').val());
		$('#field').html($('#actualField').val());
    	$('#reportForecast').modal('show');
	});
	
	$(document).on('click','#manageForecastDate',function(){
		$('#value').css("display", "none");
		$('#valueNumber').css("display", "none");
		$('#valueDate').css("display", "inline-block");
		$('#projectType').css("display", "none");
		$('#valueDate').val($('#actualValue').val());
		$('#field').html($('#actualField').val());
    	$('#reportForecast').modal('show');
	});		
	
	$(document).on('click','#manageForecastNumber',function(){
		$('#value').css("display", "none");
		$('#valueNumber').css("display", "inline-block");
		$('#valueDate').css("display", "none");
		$('#projectType').css("display", "none");
		$('#valueNumber').val($('#actualValue').val());
		$('#field').html($('#actualField').val());
    	$('#reportForecast').modal('show');
	});	
		
	manageReport = function () {
		updateForecastProject();
	}
</script>

<div class="section"> 
	<h4>Forecast Projects</h4>
	<div class="tabs">

		<button class="tablink btn waves-effect waves-light blue" onclick="openCity(event, 'Report')" id="defaultOpen">Report</button>
		<button class="tablinks btn waves-effect waves-light blue" onclick="openCity(event, 'Planning')" id="planningOpen">Planning</button>
	</div>
	 
	<div id="Report" class="tabscontent">
		<div id="tableWorkLoadByTypes" class="row">
			{{if gt (len .MonthsSimple) 12}}
			
			<div class="col-sm-10 md-10">
				<h5 style="text-align: center;">Number of engineers by month</h5>
				<table id="viewWorkLoadByTypes" class="display" cellspacing="0" width="100%">
				    <thead>
				    	<tr>
							<th style="text-align:center;"></th>
							{{range $key, $month := .MonthsSimple}}
				        	<th style="text-align:center;">{{$month}}</th>
							{{end}}
				      	</tr>
				    </thead>
			    	<tbody>
			        	<tr>
							<td>MOM</td>
							{{range $index, $mom := .MOM}}
							<td>{{$mom}}</td>						
							{{end}}
			         	</tr>
						<tr>
							<td>DEV</td>
							{{range $index, $dev := .DEV}}
							<td>{{$dev}}</td>					
							{{end}}
			         	</tr>
			      	</tbody>
			   	</table>
			</div>
		   	<div class="col s12">
				<h5 style="text-align: center;">Workload percentage by month</h5>
				<table id="viewWorkLoadByPercentage" class="display responsive-table" cellspacing="0">
				    <thead>
				    	<tr>
							<th style="text-align:center;"></th>
							{{range $key, $month := .MonthsSimple}}
				        	<th style="text-align:center;">{{$month}}</th>
							{{end}}
				      	</tr>
				    </thead>
			    	<tbody>
						<tr>
							<td>Max</td>
							{{range $index, $max := .MaxLoad}}
							<td>{{$max}}%</td>					
							{{end}}
			         	</tr>
						<tr>
							<td>Resource Usage</td>
							{{range $index, $percent := .PercentageWorkLoad}}
							<td>{{$percent}}%</td>					
							{{end}}
			         	</tr>
			        	<tr>
							<td>Min</td>
							{{range $index, $min := .MinLoad}}
							<td>{{$min}}%</td>						
							{{end}}
			         	</tr>
			      	</tbody>
			   	</table>
			</div>
			{{else}}
			<div class="col-sm-6">
				<h5 style="text-align: center;">Number of engineers by month</h5>
				<table id="viewWorkLoadByTypes" class="display responsive-table" cellspacing="0" width="90%">
				    <thead>
				    	<tr>
							<th style="text-align:center;"></th>
							{{range $key, $month := .MonthsSimple}}
				        	<th style="text-align:center;">{{$month}}</th>
							{{end}}
				      	</tr>
				    </thead>
			    	<tbody>
			        	<tr>
							<td>MOM</td>
							{{range $index, $mom := .MOM}}
							<td>{{$mom}}</td>						
							{{end}}
			         	</tr>
						<tr>
							<td>DEV</td>
							{{range $index, $dev := .DEV}}
							<td>{{$dev}}</td>					
							{{end}}
			         	</tr>
			      	</tbody>
			   	</table>
			</div>
		   	<div class="col-sm-6">
				<h5 style="text-align: center;">Workload percentage by month</h5>
				<table id="viewWorkLoadByPercentage" class="display responsive-table" cellspacing="0" width="90%">
				    <thead>
				    	<tr>
							<th style="text-align:center;"></th>
							{{range $key, $month := .MonthsSimple}}
				        	<th style="text-align:center;">{{$month}}</th>
							{{end}}
				      	</tr>
				    </thead>
			    	<tbody>
						<tr>
							<td>Max</td>
							{{range $index, $max := .MaxLoad}}
							<td>{{$max}}%</td>					
							{{end}}
			         	</tr>
						<tr>
							<td>Resource Usage</td>
							{{range $index, $percent := .PercentageWorkLoad}}
							<td>{{$percent}}%</td>					
							{{end}}
			         	</tr>
			        	<tr>
							<td>Min</td>
							{{range $index, $min := .MinLoad}}
							<td>{{$min}}%</td>						
							{{end}}
			         	</tr>
			      	</tbody>
			   	</table>
			</div>
			{{end}}
		</div>
		<div class="col s6 m6 " style="width:90%">
			<h5 style="text-align: center;">No. of Resources per Month</h5>
			<canvas id="chartjs-stacked">
			</canvas>		
			<script>
				chart6=new Chart(document.getElementById("chartjs-stacked"),
				{	
					type: 'bar',
	                data: {
			            labels: {{.Months}},
			            datasets: [{
			                label: 'MOM',
			                data: {{.MOM}},
			                backgroundColor: '#cc6677'
			            }, {
			                label: 'DEV',
			                data: {{.DEV}},
			                backgroundColor: '#4477aa'
			            }]					
			        },
	                options: {
	                    responsive: true,
	                    scales: {
	                        xAxes: [{
	                            stacked: true,
								scaleLabel: {
		                            display: true,
		                            labelString: 'Month'
		                        }
	                        }],
	                        yAxes: [{
	                            stacked: true,
								scaleLabel: {
		                            display: true,
		                            labelString: 'Number of resources'
		                        }
	                        }]
	                    }
	                }
				});
			</script>			
		</div>
		<div class="col s6 m6" style="width:90%">
			<h5 style="text-align: center;">Resource Usage per Month</h5>
			<canvas id="chartjs-lines">
			</canvas>		
			<script>
				chart7=new Chart(document.getElementById("chartjs-lines"),
				{	
					type: 'line',
	                data: {
			            labels: {{.Months}},
			            datasets: [{
							label: "Resource Ussage",
		                    fill: false,
							pointRadius: 0,
							lineTension: 0,
		                    data: {{.PercentageWorkLoad}},
			                backgroundColor: '#332288',
			                borderColor: '#137cd0 '
			            }, {
			                label: "Max",
			               	fill: false,
                    		borderDash: [5, 5],
		                    data: {{.MaxLoad}},
			                backgroundColor: '#88ccee'
			            }, {
			                label: "Min",
			               	fill: false,
                    		borderDash: [5, 5],
		                    data: {{.MinLoad}},
			                backgroundColor: '#882255'
			            }]					
			        },
	                options: {
	                    responsive: true,
	                    scales: {
		                    xAxes: [{
		                        display: true,
		                        scaleLabel: {
		                            display: true,
		                            labelString: 'Month'
		                        }
		                    }],
		                    yAxes: [{
		                        display: true,
		                        scaleLabel: {
		                            display: true,
		                            labelString: 'Work load percentage'
		                        }
		                    }]
		                }
	                }
				});
			</script>			
		</div>
	</div>
	<div id="Planning" class="tabscontent">
		<table id="viewProjectsForecast"  class="display responsive-table" cellspacing="0" width="90%">
			<thead>
				<tr>
					<th>BU</th>
					<th>Region</th>
					<th>ID</th>
					<th>Name</th>
					<th>Description</th>
					<th>StartDate</th>
					<th>EndDate</th>
					<th>Sites</th>
					<th>Process</th>	
					<th>MOM Resources</th>
					<th>DEV Resources</th>
					<th>Total Resources</th>
					<th>Estimate Cost</th>	
					<th>Billing Date</th>
					<th>Status</th>
					<th>Options</th>			
				</tr>
			</thead>
			<tbody>
				{{$typeResources := .TypesResources}}
			 	{{range $key, $projectForecast := .ProjectsForecast}}
				<tr>
					<td>
						{{$projectForecast.BusinessUnit}}
						<a id="manageForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.BusinessUnit}});$('#actualField').val('Business Unit');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{$projectForecast.Region}}
						<a id="manageForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.Region}});$('#actualField').val('Region');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>{{$projectForecast.ID}}</td>
					<td>
						{{$projectForecast.Name}}
						<a id="manageForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.Name}});$('#actualField').val('Name');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{$projectForecast.Description}}
						<a id="manageForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.Description}});$('#actualField').val('Description');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{dateformat $projectForecast.StartDate "2006-01-02"}}
						<a id="manageForecastDate" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{dateformat $projectForecast.StartDate "2006-01-02"}});$("#actualField").val("Start Date");'> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{dateformat $projectForecast.EndDate "2006-01-02"}}
						<a id="manageForecastDate" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{dateformat $projectForecast.EndDate "2006-01-02"}});$("#actualField").val("End Date");'> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{$projectForecast.NumberSites}}
						<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.NumberSites}});$('#actualField').val('Number Of Sites');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{$projectForecast.NumberProcessPerSite}}
						<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.NumberProcessPerSite}});$('#actualField').val('Number Of Process');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					{{if eq (len $projectForecast.AssignResources) 0}}
						<td id ="MOMEngineers">
							0
							<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val(0);$("#actualField").val("MOM Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "MOM Engineer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
						</td>
						<td id ="DEVEngineers">
							0
							<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val(0);$("#actualField").val("DEV Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "Developer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
						</td>
					{{end}}
					{{range $keyAssigns, $assignResources := $projectForecast.AssignResources}}
						{{if eq (len $projectForecast.AssignResources) 1}}
							{{if eq "MOM Engineer" $assignResources.Name}}
								<td id ="MOMEngineers">
									{{$assignResources.NumberResources}}
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{$assignResources.NumberResources}});$("#actualField").val("MOM Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "MOM Engineer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{else}}
								<td id ="MOMEngineers">
									0
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast"  onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val(0);$("#actualField").val("MOM Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "MOM Engineer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{end}}
						{{else}}
							{{if eq "MOM Engineer" $assignResources.Name}}
								<td id ="MOMEngineers">
									{{$assignResources.NumberResources}}
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{$assignResources.NumberResources}});$("#actualField").val("MOM Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "MOM Engineer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{end}}
						{{end}}												
					{{end}}
					{{range $keyAssigns, $assignResources := $projectForecast.AssignResources}}
						{{if eq (len $projectForecast.AssignResources) 1}}
							{{if eq "Developer" $assignResources.Name}}
								<td id ="DEVEngineers">
									{{$assignResources.NumberResources}}
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{$assignResources.NumberResources}});$("#actualField").val("DEV Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "Developer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{else}}
								<td id ="DEVEngineers">
									0
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val(0);$("#actualField").val("DEV Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "Developer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{end}}
						{{else}}
							{{if eq "Developer" $assignResources.Name}}
								<td id ="DEVEngineers">
									{{$assignResources.NumberResources}}
									<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{$assignResources.NumberResources}});$("#actualField").val("DEV Resources");$("#typeResourceId").val({{range $idex, $typeResource := $typeResources}}{{if eq $typeResource.Name "Developer"}}{{$typeResource.ID}}{{end}}{{end}});'> <i class="mdi-editor-mode-edit tiny"></i></a>
								</td>
							{{end}}
						{{end}}
					{{end}}
					
					<td id ="totalEngineers">
					{{$projectForecast.TotalEngineers}}
					</td>
					<td>
						{{$projectForecast.EstimateCost}}
						<a id="manageForecastNumber" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.EstimateCost}});$('#actualField').val('Estimate Cost');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>	
					<td>
						{{dateformat $projectForecast.BillingDate "2006-01-02"}}
						<a id="manageForecastDate" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick='$("#reportID").val({{$projectForecast.ID}});$("#actualValue").val({{dateformat $projectForecast.BillingDate "2006-01-02"}});$("#actualField").val("Billing Date");'> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>
					<td>
						{{$projectForecast.Status}}
						<a id="manageForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick="$('#reportID').val({{$projectForecast.ID}});$('#actualValue').val({{$projectForecast.Status}});$('#actualField').val('Status');"> <i class="mdi-editor-mode-edit tiny"></i></a>
					</td>			
					<td>
						<a id="deleteProjectForecast" class="modal-trigger tooltipped" data-position="top" data-tooltip="Edit" href="#reportForecast" onclick="$('#nameDelete').html('{{$projectForecast.Name}}');$('#projectID').val({{$projectForecast.ID}});$('#reportID').val({{$projectForecast.ID}});"> <span class="glyphicon glyphicon-trash"></span></a>
					</td>
				</tr>
				{{end}}	
			</tbody>
		</table>
	</div>

</div>

<!-- Modal -->
<div class="modal fade" id="projectForecastModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalProjectForecastTitle" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="projectForecastID">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Business Unit"> Business Unit </label>
              <div class="col-sm-8">
              	<input type="text" id="projectBusinessUnit" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Region"> Region </label>
              <div class="col-sm-8">
              	<input type="text" id="projectForecastRegion" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Project Name"> Project Name </label>
              <div class="col-sm-8">
              	<input type="text" id="projectForecastName" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Start Date"> Start Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectForecastStartDate" style="inline-size: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="End Date"> End Date </label> 
              <div class="col-sm-8">
              	<input type="date" id="projectForecastEndDate" style="inline-size: 174px; border-radius: 8px;">
        		</div>
          </div>
        </div>
		<!--div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div id="divProjectType" class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Types"> Types </label> 
             	<div class="col-sm-8">
	             	<select  id="projectType" multiple style="width: 174px; border-radius: 8px;">
					{{range $key, $types := .Types}}
						<option value="{{$types.ID}}">{{$types.Name}}</option>
					{{end}}
					</select>
              	</div>    
          	</div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
              <div class="col-sm-8">
              	<input type="checkbox" id="projectActive"><br/>
              </div>    
          </div>
        </div>
		<div class="row-box col-sm-12" style="padding-bottom: 1%;">
			<div id="divProjectType" class="form-group form-group-sm">
			<label class="control-label col-sm-4 translatable" data-i18n="Leader"> Leader </label> 
				<div class="col-sm-8">
					<select  id="leaderID" style="width: 174px; border-radius: 8px;">
					<option value="0">Without leader</option>
					{{range $key, $resource := .Resources}}
					<option value="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
					{{end}}
					</select>
				</div>    
			</div>
		</div-->
      </div>
      <div class="modal-footer">
        <button type="button" id="projectForecastCreate" class="btn btn-default" onclick="createForecastProject()" data-dismiss="modal">Create</button>
		<button type="button" id="projectForecastUpdate" class="btn btn-default" onclick="" data-dismiss="modal">Update</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
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
		<input type="hidden" id="projectID">
        Are you sure you want to remove <b id="nameDelete"></b> from projects?
		<br>
		<li>The resources will lose this project assignment.</li>
		<li>The types will lose this project assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="projectDelete" class="btn btn-default" onclick="deleteForecastProject()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal -->
<div class="modal" id="reportForecast">
      <!-- Modal content-->
      <div class="modal-content">
            <h5 id="modalTitle" class="modal-title">Edit</h5>
			<div class="divider"></div> 

         <div class="modal-body">
			<input type="hidden" id="reportID">
			<input type="hidden" id="resourceID">
			<input type="hidden" id="actualValue">
			<input type="hidden" id="actualField">
			<input type="hidden" id="typeResourceId">
			<input type="hidden" id="actualBillableHours">
			<input type="hidden" id="actualProjectType">
            <div class="row-box col-sm-12" style="padding-bottom: 1%;">
               <div class="form-group form-group-sm">
                  <label id="field" class="control-label col-sm-4 translatable" data-i18n=""></label>
                  <div class="col-sm-8">
                    <input type="text" id="value" style="border-radius: 8px;" min="0" max="100">
					<input type="number" id="valueNumber" style="border-radius: 8px;" min="0" max="100">
					<input type="date" id="valueDate" style="border-radius: 8px;" min="0" max="100">
                  	<select  id="projectType" >
					{{range $key, $types := .Types}}
						<option value="{{$types.ID}}">{{$types.Name}}</option>
					{{end}}
					</select>
				  </div>
               </div>
            </div>
         </div>
         <div class="modal-footer">
		    <a id="reportAdd" class="waves-effect waves-green btn-flat modal-action modal-close" onclick="manageReport()" >Edit</a>
            <!--<button type="button" id="reportAdd" class="btn btn-default" onclick="manageReport()" data-dismiss="modal">OK</button>-->
            <a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
         </div>
      </div>
   </div>
</div>