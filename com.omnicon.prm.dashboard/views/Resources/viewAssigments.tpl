<script>
	var Task = {};
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		Task.table = $('#viewResourceInProjects').DataTable({
			"iDisplayLength": 20,
			"bInfo": false,
			"bLengthChange": false
		});        
      
		$('#backButton').css("display", "inline-block");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		});
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/resources/allAssigments',{
				"ResourceId": {{.ResourceId}}
			});
		});

		
		$('.datepicker').pickadate({
			selectMonths: true,
			selectYears: 15,
			format: 'yyyy-mm-dd',
			showButtonPanel: false,
			formatSubmit: 'yyyy-mm-dd',
			container: 'body'
		});
        
		$('#titlePag').html("Assigments");
        
	});
	
		getDateToday = function(){	
		var time = new Date();
		var mm = time.getMonth() + 1; // getMonth() is zero-based
		var dd = time.getDate();
        var date =  [time.getFullYear(),
	          (mm>9 ? '' : '0') + mm,
	          (dd>9 ? '' : '0') + dd
	         ].join('-');
		return date;
	}
	
</script>

<div class="container" style="padding:15px;">
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag" ></h4>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>				
			</div>
		</div>
		
		<table id="viewResourceInProjects" class="display responsive-table" cellspacing="0" width="95%" >
			<thead>
				<tr>
					<th>Engineer</th>
					<th>Engineer Range</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Email</th>
				</tr>
			</thead>
			<tbody>
				{{$startDate := .StartDate}}
				{{$endDate := .EndDate}}
				{{$TotalHours := .TotalHours}}
				{{range $key, $resourcebyTask := .Resources}}
				
				{{ if ($resourcebyTask.TaskDetail) }}
				<tr>
					</div>
					<td style="text-align:center;" onclick="showDetail($(this), {{$resourcebyTask.TaskDetail}})"><span class="fas fa-caret-square-right" style="margin-top: 5px;float:left;"></span>{{ $resourcebyTask.Name}} {{ $resourcebyTask.LastName}}</td>
					<td>{{ $resourcebyTask.EngineerRange }}</td>
					<td>{{ $startDate}}</td>
					<td>{{ $endDate }}</td>
					<td>{{ $resourcebyTask.Email }}</td>
				</tr>
					{{end}}
					{{end}}
			</tbody>
			<tr>
					
				</tr>	
		</table>
	</div>
</div>
	<!-- Materialize Modal Update -->
	<div id="resourceProjectUpdateModal" class="modal " style = "overflow:visible" >
			<div class="modal-content">
				<h5 id="modalUpdateResourceProjectTitle" class="modal-title">Update Assign Resource</h5>
				<div class="divider CardTable"></div>
				
				<input type="hidden" id="resourceProjectUpdateId">
				<input type="hidden" id="projectUpdateId">
				<input type="hidden" id="resourceProjectIDUpdate">	
				<div class="input-field row">	
					<div class="input-field col s12">
						<input id="resourceProjectUpdateName" type="text"  class="validate">
						<label  for="resourceProjectUpdateName"  class="active">Resource Name</label>
					</div>

					<div class="input-field col s12 m6 ">
						<label for="resourceUpdateDateStartProject" class="active">Start Date:</label>
						<input id="resourceUpdateDateStartProject" type="date" class="datepicker">
					</div>

					<div class="input-field col s12 m6 ">
						<label for="resourceUpdateDateEndProject" class="active">End Date:</label>
						<input id="resourceUpdateDateEndProject" type="date" class="datepicker">
					</div>
					
					<div class="input-field col s12 m7 l7">
						<input id="resourceUpdateDateHoursProject" type="number"  class="validate">
						<label  for="resourceUpdateDateHoursProject"  class="active">Hours</label>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<a id="resourceProjectCreate" onclick="setResourceToProject($('#resourceProjectIDUpdate').val(), $('#resourceProjectUpdateId').val(), $('#projectUpdateId').val(), $('#resourceUpdateDateStartProject').val(), $('#resourceUpdateDateEndProject').val(), $('#resourceUpdateDateHoursProject').val(), false, 0, false)" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Set</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>

	<script>
		function showDetail(pObjBody, tDetails) {
		var tr = pObjBody.closest('tr');
        var row = Task.table.row( tr );

        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
			$(pObjBody).children('span').addClass('fa-caret-square-right');
			$(pObjBody).children('span').removeClass('fa-caret-square-remove');
        }
        else {
            // Open this row
            row.child( format(tDetails) ).show();
            tr.addClass('shown');
			$(pObjBody).children('span').addClass('fa-caret-square-down');
			$(pObjBody).children('span').removeClass('fa-caret-square-right');
        }
	}


		/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++) {
			
			insert += '<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].ProjectName+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].Task+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].Deliverable+'</td>'+
	            '<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Requirements+'</td>'+
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate.substring(0, 10)+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate.substring(0, 10) + '</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Hours+'</td>'+	            
				'<td class="col-sm-1" style="font-size:12px;text-align: -webkit-center;">'+d[index].Priority+'</td>'+	            
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].AdditionalComments+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].AssignatedByName+" " + d[index].AssignatedByLastName+'</td>'+					            
	        	'</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="centered highlight"><thead><tr><th>Project Name</th><th>Activity</th><th>Deliverable</th><th>Requirements</th><th>Start Date</th><th>End Date</th><th>Time</th><th>Priority</th><th>Additional Comments</th><th>Asigned By</th></tr></thead>'+insert+'</table>';
	}
	</script>