<script src="/static/js/chartjs/Chart.min.js" > </script>
<script>
	var MyProject = {};
	$(document).ready(function(){
		$('.tooltipped').tooltip();
		$('.modal-trigger').leanModal();
		MyProject.table = $('#availabilityTable').DataTable({
			"bPaginate": false,
			"bLengthChange": false,
			"bFilter": true,
			"bInfo": false,
			"bAutoWidth": false,
			"columns": [
				{"className":'details-control',"searchable":true},
				null
	        ],
			"columnDefs": [ {
			      "targets": [0,1],
			      "orderable": false
			    } ],
			responsive: true,
			"pageLength": 50,
			"searching": true,
			"paging": true,			
			"dom": '<"col-sm-4"l><"col-sm-4"f><"col-sm-4"<"toolbar">><rtip>',
			initComplete: function(){
		     // $("div.toolbar").html('<label>Hours by resource:{{.HoursByPerson}}</label><button type="button" data-toggle="modal" data-target="#spiderModal" class="pull-right buttonTable button2" id="compare" style="border-radius:8px;">Compare</button>');         
		   	}       
		});
		if (!$('#skillsActive').prop("checked")) {
			$('#compare').addClass('disabled', 'disabled');
			$("#compare").css("display", "none");
		}else{
			$('#compare').removeClass('disabled', 'disabled');
			$("#compare").css("display", "inline-block");
		}		
				
		$('#availabilityTable tbody').on('click', 'td.details-control', function(){
			
		});
	});
	
	function showDetails(pObjBody, pListOfRange) {
        var tr = pObjBody.closest('tr');
        var row = MyProject.table.row( tr );
 
        if ( row.child.isShown() ) {
            // This row is already open - close it
			row.child.hide();
            tr.removeClass('shown');
			$(pObjBody).children('i').addClass('fa-caret-square-right');
			$(pObjBody).children('i').removeClass('fa-caret-square-down');
			
        }
        else {
            // Open this row
            row.child( format(pListOfRange) ).show();
            tr.addClass('shown');
			$(pObjBody).children('i').addClass('fa-caret-square-down');
			$(pObjBody).children('i').removeClass('fa-caret-square-right');
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
</script>
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
										<td class="col-sm-9" style="background-position-x: 1%;font-size:11px;text-align:left background-color: aliceblue;" onclick="showDetails($(this),{{$resourceAvailabilityInfo.ListOfRange}})">
											<i class="fas fa-caret-square-right" style="margin-right: 10px;"></i>
											{{if gt $resourceSkillValue 3.0}}
												<img src="/static/img/skillUsers/user-green.png" class="pull-right"/>
										
											{{else if and (le $resourceSkillValue 3.0) (gt $resourceSkillValue 2.0)}}
												<img src="/static/img/skillUsers/user-yellow.png" class="pull-right"/>
											
											{{else if and (le $resourceSkillValue 2.0) (gt $resourceSkillValue 1.0)}}
												<img src="/static/img/skillUsers/user-orange.png" class="pull-right"/>
											
											{{else if and (le $resourceSkillValue 1.0) (gt $resourceSkillValue 0.0)}}
												<img src="/static/img/skillUsers/user-red.png" class="pull-right"/>
											{{else }}
												<img src="/static/img/skillUsers/user-green.png" class="pull-right"/>
											{{end}}
											{{$resource.Name}} {{$resource.LastName}}
										</td>
										<td id="totalHours" class="col-sm-2" style="font-size:11px;text-align: -webkit-center;">{{$totalHours}}</td>
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

<!-- Modal -->
<div class="modal" id="spiderModal">
    <div class="modal-content">
        <h5 class="modal-title" id="modalProjectTitle">Spider Diagram</h5>
			<div class="divider CardTable"></div>
        <input type="hidden" id="projectID">
        <div class="chart-container-compare" id="chartjs-wrapper">
			<canvas id="chartjs-3" >
			</canvas>	
			<script>
			new Chart(document.getElementById("chartjs-3"),
				{"type":"radar",
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
  </div>
</div>