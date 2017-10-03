<script>
	var MyProject = {};
	$(document).ready(function(){	
		MyProject.table = $('#availabilityTable').DataTable({
			"columns": [
				{"className":'details-control',"searchable":true},
				null
	        ],
			"columnDefs": [ {
			      "targets": [1],
			      "orderable": true
			    } ],
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": true,
		});
		
		$('#availabilityTable tbody').on('click', 'td.details-control', function(){
			
		});
	
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Projects");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/projects',{});
			configureSimulatorModal();
		}); 
		$('#titlePag').html($('#projectName').val());
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/projects/recommendation',{
				"ProjectId": {{.ProjectId}},
				"ProjectName": "{{.Title}}"
			});
		}); 
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("Save Project");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("onclick","createProject();configureSimulatorModal();");
		
		
		var prjStartDate = formatDate({{.StartDate}});
		var prjEndDate = formatDate({{.EndDate}});
		$('#dates').text("Date From: "+ prjStartDate + "  -  Date To: " + prjEndDate);
		
		$('#projectID').val(null);
		$('#projectName').val(null);
		$('#projectStartDate').val(null);
		$('#projectEndDate').val(null);
		$('#projectActive').prop('checked', false);	
		$('#projectTypeSimulator').val(null);
	});
	
	function showDetails(pObjBody, pListOfRange) {
        var tr = pObjBody.closest('tr');
        var row = MyProject.table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
        }
        else {
            // Open this row
            row.child( format(pListOfRange) ).show();
            tr.addClass('shown');
        }
    }
	
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++) {
			insert += '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate+'</td>'+
	            '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].Hours+'</td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="table table-striped table-bordered  dataTable">'+insert+'</table>';
	}
			
	configureShowModal = function(pID, pName){
		
		$("#showResourceID").val(pID);
		$("#showResourceName").val(pName);
		/*$("#resourceLastName").val(pLastName);
		$("#resourceEmail").val(pEmail);
		$("#resourceRank").val(pRank);
		$("#resourceActive").prop('checked', pActive);
		*/
		$("#modalTitle").html("Show Resource Information");
	}
	
	configureShowCreateModal = function(){
		$("#resourceDateStartProject").val(getDateToday());
		$("#resourceDateEndProject").val(getDateToday());
		$("#resourceDateEndProject").attr("min", $("#resourceDateStartProject").val());
	}
	
	setResourceToProject = function(ID, resourceId, projectId, startDate, endDate, hours, lead, isToCreate){
		var settings = {
			method: 'POST',
			url: '/projects/setresource',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": ID,
				"ProjectId": projectId,
				"ResourceId": resourceId,
				"StartDate": startDate,
				"EndDate": endDate,
				"Hours": hours,
				"Lead": lead,
				"IsToCreate": isToCreate
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/projects/resources', {"ProjectId": projectId,"ProjectName": "{{.Title}}"})
		});
	}
	
	getResources = function(){
		var settings = {
			method: 'POST',
			url: '/resources',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Template": "select",				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#resourceNameProject').html(response);
		});
	}
	
	getResource = function(pResourceId){
		var settings = {
			method: 'POST',
			url: '/resources/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": pResourceId,				
			}
		}
		$.ajax(settings).done(function (response) {
		  $('#resourceInfo').html(response);
		  $('#showInfoResourceModal').modal("show");
		});		
	}
	
	createProject = function(){
		var settings = {
			method: 'POST',
			url: '/projects/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#projectName').val(),
				"StartDate": $('#projectStartDate').val(),
				"EndDate": $('#projectEndDate').val(),
				"Enabled": $('#projectActive').is(":checked")
			}
		}
		$.ajax(settings).done(function (response) {
		  validationError(response);
		  reload('/projects', {})
		});
	}
	
	configureSimulatorModal = function(){		
		$("#projectID").val(null);
		$("#projectName").val(null);
		$("#projectStartDate").val(null);
		$("#projectEndDate").val(null);
		$("#projectActive").prop('checked', false);	
		$("#projectTypeSimulator").val(null);
	}
</script>
<div class="col-sm-2">
</div>
<div class="col-sm-8">
	<table id="availabilityTable" class="table table-striped table-bordered">
		<thead id="availabilityTableHead">
			<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-10">Resource Name</th>
			<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Hours</th>
		</thead>
		<tbody id="availabilityTableBody">	
			{{$availBreakdownPerRange := .AvailBreakdownPerRange}}
			{{$ableResource := .AbleResource}}
			{{range $index, $resource := .Resources}}
				{{range $indexAble, $resourceAble := $ableResource}}
					{{if eq  $resource.ID $resourceAble}}
						{{$resourceAvailabilityInfo := index $availBreakdownPerRange $resource.ID}}
						<tr>
							<td class="col-sm-10" style="background-position-x: 1%;font-size:11px;text-align: -webkit-center; background-color: aliceblue;" onclick="showDetails($(this),{{$resourceAvailabilityInfo.ListOfRange}})">{{$resource.Name}} {{$resource.LastName}}</td>
							<td id="totalHours" class="col-sm-2" style="font-size:11px;text-align: -webkit-center; background-color: aliceblue;">{{$resourceAvailabilityInfo.TotalHours}}</td>
						</tr>
					{{end}}
				{{end}}
			{{end}}
		</tbody>
	</table>
</div>
<div class="col-sm-2">
</div>