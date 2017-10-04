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
						{{if ne $resourceAvailabilityInfo.TotalHours 0.0}}
							<tr>
								<td class="col-sm-10" style="background-position-x: 1%;font-size:11px;text-align: -webkit-center; background-color: aliceblue;" onclick="showDetails($(this),{{$resourceAvailabilityInfo.ListOfRange}})">{{$resource.Name}} {{$resource.LastName}}</td>
								<td id="totalHours" class="col-sm-2" style="font-size:11px;text-align: -webkit-center; background-color: aliceblue;">{{$resourceAvailabilityInfo.TotalHours}}</td>
							
							</tr>
						{{end}}
					{{end}}
				{{end}}
			{{end}}
		</tbody>
	</table>
</div>
<div class="col-sm-2">
</div>