<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewResourceInProjects').DataTable({
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
			reload('/projects/resources/ownAssignation',{
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

        
		$('#titlePag').html("My Tasks");
        
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
					<th>Project Names</th>
					<th>Start Date</th>
					<th>End Date</th>
					<th>Hours</th>
				</tr>
			</thead>
			<tbody>
				{{range $key, $resourceToProject := .ResourcesToProjects}}
				<tr>
					</div>
					<td>{{$resourceToProject.ProjectName}}</td>
					<td>{{dateformat $resourceToProject.StartDate "2006-01-02"}}</td>
					<td>{{dateformat $resourceToProject.EndDate "2006-01-02"}}</td>
					<td>{{$resourceToProject.Hours}}</td>
				</tr>
				{{end}}	
			</tbody>
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