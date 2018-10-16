<script src="/static/js/chartjs/Chart.min.js" > </script>
<script>
	var MyProject = {};
	var chart;
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();

		
function addDays(date, days) {
    var result = new Date(date);
    result.setDate(date.getDate() + days);
    return result;
}

// Simple function that accepts two parameters and calculates
// the number of hours worked within that range
function workingHoursBetweenDates(startDate, endDate, workHoursUpdate, isHoursPerDay) {  
    // Store minutes worked
    var hoursWorked = 0;

    // Validate input
    if (endDate < startDate) { return 0; }

    // Loop from your Start to End dates (by hour)
    var current = startDate;

    // Define work hours
    var workHours = 8;
	if (isHoursPerDay){
		workHours = parseFloat(workHoursUpdate);
	}
	if (endDate.getDate() == startDate.getDate()) { return workHours; }
	// Loop while currentDate is less than end Date (by minutes)
    while(current <= endDate){
		
		if (current.getDay() !== 6 && current.getDay() !== 5) {
			hoursWorked = hoursWorked + workHours;
		}
		current = addDays(current,1);
	}
	
    // Return the number of hours
    return hoursWorked;
}

		MyProject.table = $('#availabilityTable').DataTable({
			"bLengthChange": false,
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
			"dom": '<"col-sm-4"l><"col-sm-4"f><"col-sm-4"<"toolbar">><rtip>',
			initComplete: function(){
				var startDateCreate = new Date($("#projectStartDate").val());
				var endDateCreate = new Date($("#projectEndDate").val());
				var projectHours = workingHoursBetweenDates(startDateCreate, endDateCreate, 0, false);
		      	
				$("div.toolbar").html('<label>Project Duration (h): '+projectHours+'</label>');         
		   	}       
		});
		if (!$('#skillsActive').prop("checked")) {
			$('#compare').attr('disabled', 'disabled');
		}else{
			$('#compare').removeAttr('disabled', 'disabled');
		}		
				
		$('#availabilityTable tbody').on('click', 'td.details-control', function(){
			
		});
		
		$( window ).resize(function() {repaint();});
	});
	
	function repaint() {
		chart.update();
	}
	
	function showDetails(pObjBody, pListOfRange) {
        var tr = pObjBody.closest('tr');
        var row = MyProject.table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
            row.child.hide();
            tr.removeClass('shown');
			$(pObjBody).children('span').addClass('glyphicon-collapse-down');
			$(pObjBody).children('span').removeClass('glyphicon-expand');
        }
        else {
            // Open this row
            row.child( format(pListOfRange) ).show();
            tr.addClass('shown');
			$(pObjBody).children('span').addClass('glyphicon-expand');
			$(pObjBody).children('span').removeClass('glyphicon-collapse-down');
        }
    }
	
	/* Formatting function for row details - modify as you need */
	function format ( d ) {
	    // `d` is the original data object for the row
		var insert = '';
		for (index = 0; index < d.length; index++){
			insert += '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].StartDate+'</td>'+
	            '<td class="col-sm-5" style="font-size:12px;text-align: -webkit-center;">'+d[index].EndDate+'</td>'+
				'<td class="col-sm-2" style="font-size:12px;text-align: -webkit-center;">'+d[index].Hours+'</td>'+	            
	        '</tr>';
		}
	    return '<table border="0" style="width: 100%;margin-left: 6px;" class="table table-striped table-bordered  dataTable">'+insert+'</table>';
	}
</script>
<style>
td, th {
text-align:left;

}
</style>
	<div class="col s12" >	
		<div class="card-panel">
		<a class="modal-trigger btn waves-effect waves-light blue" href="#spiderModal" id="compare">Compare</a>
		<table id="availabilityTable" class="display" cellspacing="0" width="90%" >
			<thead id="availabilityTableHead">
				<th style="font-size:12px;text-align: -webkit-center;">Resource Name</th>
				<th style="font-size:12px;text-align: -webkit-center;">Hours</th>
			</thead>
			<tbody id="availabilityTableBody">
				{{$availBreakdownPerRange := .AvailBreakdownPerRange}}
				{{$ableResource := .AbleResource}}
				{{range $index, $resource := .Resources}}
					{{if $resource.Enabled}}
						{{range $resourceAble, $resourceSkillValue := $ableResource}}
							{{if eq  $resource.ID $resourceAble}}
								{{$resourceAvailabilityInfo := index $availBreakdownPerRange $resource.ID}}
								
								{{if $resourceAvailabilityInfo}}
								
									{{$totalHours := $resourceAvailabilityInfo.TotalHours}}
								
							
									{{if ne $totalHours 0.0}}
										
										<tr>
											<td class="col-sm-9" onclick="showDetails($(this),{{$resourceAvailabilityInfo.ListOfRange}})">
												<span class="glyphicon glyphicon-collapse-down" style="float:left;"></span>
												{{if gt $resourceSkillValue 3.0}}
													<img src="/static/img/skillUsers/user-green.png" class="pull-right"/>
												{{end}}
												{{if and (le $resourceSkillValue 3.0) (gt $resourceSkillValue 2.0)}}
													<img src="/static/img/skillUsers/user-yellow.png" class="pull-right"/>
												{{end}}
												{{if and (le $resourceSkillValue 2.0) (gt $resourceSkillValue 1.0)}}
													<img src="/static/img/skillUsers/user-orange.png" class="pull-right"/>
												{{end}}
												{{if and (le $resourceSkillValue 1.0) (gt $resourceSkillValue 0.0)}}
													<img src="/static/img/skillUsers/user-red.png" class="pull-right"/>
												{{end}}
												{{$resource.Name}} {{$resource.LastName}}
											</td>
											<td id="totalHours" class="col-sm-2" >{{$totalHours}}</td>
										</tr>
									{{end}}
								{{end}}
							{{end}}
						{{end}}
					{{end}}
				{{end}}
			</tbody>
		</table>
		</div>
	</div>

<!-- Modal 
<div class="modal" id="spiderModal">
    <div class="modal-content">
        <h5 class="modal-title" id="modalProjectTitle">Spider Diagram</h4>
      <div class="modal-body">
        <input type="hidden" id="projectID">
        <div class="chart-container-compare" id="chartjs-wrapper">
			<canvas id="chartjs-3" >
			</canvas>	
			<script>
			chart = new Chart(document.getElementById("chartjs-3"),
				{	"type":"radar",
					"data": {
						"labels": {{.ListProjectSkillsName}},
							"datasets":[
								{{$ableResource := .AbleResource}}
								{{$mapCompare := .MapCompare}}
								{{$listColors := .ListColor}}
								{"label":$('#projectName').val(),"data":{{.ListProjectSkillsValue}},"fill":true,"backgroundColor":"rgba(80, 169, 224, 0.2)","borderColor":"rgb(8, 91, 142)","pointBackgroundColor":"rgb(8, 91, 142)","pointBorderColor":"#ffffff","pointHoverBackgroundColor":"#fff","pointHoverBorderColor":"rgb(255, 99, 132)"},
								
								{{range $index, $resource := .ListToDraw}}	
									
											{{$listSkillsValue := index $mapCompare $resource.ID}}
											{{if (ne $index 0)}}
												,
											{{end}}
											{"label":"{{$resource.Name}}","data":{{$listSkillsValue}},"fill":false,"backgroundColor":"transparent","borderColor":"{{index $listColors $index}}","pointBackgroundColor":"{{index $listColors $index}}","pointBorderColor":"{{index $listColors $index}}","pointHoverBackgroundColor":"{{index $listColors $index}}","pointHoverBorderColor":"{{index $listColors $index}}"}
										
								{{end}}
							]
						},
					"options": {
						"elements": {
							"line":{"tension":0,"borderWidth":3}
						},
						"scale": {
					        "display": true,
							"ticks": {
								"max": 100,
								"min": 0,
								"beginAtZero":true,
								"stepSize": 20	
							}				
					    },
						legend: {
							display:true
						}
					}
				});
			</script>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>    
  </div>
</div>-->

<div id="spiderModal" class="modal" >
	<div class="modal-content">
		<h5  class="modal-title" id="modalProjectTitle">Spider Diagram</h5>
		<div class="divider CardTable"></div>
		<input type="hidden" id="projectID">
		<div class="chart-container-compare" id="chartjs-wrapper">
			<canvas id="chartjs-3" >
			</canvas>	
			<script>
			chart = new Chart(document.getElementById("chartjs-3"),
				{	"type":"radar",
					"data": {
						"labels": {{.ListProjectSkillsName}},
							"datasets":[
								{{$ableResource := .AbleResource}}
								{{$mapCompare := .MapCompare}}
								{{$listColors := .ListColor}}
								{"label":$('#projectName').val(),"data":{{.ListProjectSkillsValue}},"fill":true,"backgroundColor":"rgba(80, 169, 224, 0.2)","borderColor":"rgb(8, 91, 142)","pointBackgroundColor":"rgb(8, 91, 142)","pointBorderColor":"#ffffff","pointHoverBackgroundColor":"#fff","pointHoverBorderColor":"rgb(255, 99, 132)"},
								
								{{range $index, $resource := .ListToDraw}}	
									
											{{$listSkillsValue := index $mapCompare $resource.ID}}
											{{if (ne $index 0)}}
												,
											{{end}}
											{"label":"{{$resource.Name}}","data":{{$listSkillsValue}},"fill":false,"backgroundColor":"transparent","borderColor":"{{index $listColors $index}}","pointBackgroundColor":"{{index $listColors $index}}","pointBorderColor":"{{index $listColors $index}}","pointHoverBackgroundColor":"{{index $listColors $index}}","pointHoverBorderColor":"{{index $listColors $index}}"}
										
								{{end}}
							]
						},
					"options": {
						"elements": {
							"line":{"tension":0,"borderWidth":3}
						},
						"scale": {
							"display": true,
							"ticks": {
								"max": 100,
								"min": 0,
								"beginAtZero":true,
								"stepSize": 20	
							}				
						},
						legend: {
							display:true
						}
					}
				});
			</script>
		</div>
	</div>
	<div class="modal-footer">
		<a class="btn red white-text waves-effect waves-red btn-flat modal-action modal-close">Close</a>
	</div>
</div>