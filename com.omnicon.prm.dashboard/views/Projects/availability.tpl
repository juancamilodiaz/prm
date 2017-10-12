<!DOCTYPE html>
<html>

<head>
{{if .IsGet}}
  	<title>Status Projects</title>
  	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js">
	</script>
{{end}}
	<script>
		$(document).ready(function(){
			$('#backButton').css("display", "none");
			$('#refreshButton').css("display", "none");
			$('#buttonOption').css("display", "none");
			$('#datePicker').css("display", "none");
		});
	</script>
	<script>
		google.charts.load('current', {'packages':['gantt']});
	    google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			var data = new google.visualization.DataTable();
			
			data.addColumn('string', 'Task ID');
			data.addColumn('string', 'Project Name');
			data.addColumn('date', 'Start Date');
			data.addColumn('date', 'End Date');
			data.addColumn('number', 'Duration');
			data.addColumn('number', 'Percent Complete');
	      	data.addColumn('string', 'Dependencies');
	
			data.addRows([
			{{range $xx, $project := .Projects}}
					{{if (ne $xx 0)}}
						,
					{{end}}
					[{{$project.Name}}, {{$project.Name}}+{{$project.Lead}}, new Date({{$project.StartDate}}), new Date({{$project.EndDate}}), 0, {{$project.Percent}},""]
					
			{{end}}
			]);
			var options = {
		    	height: 375
		    };
	
	      	var chart = new google.visualization.Gantt(document.getElementById('chart_div'));
	      	chart.draw(data, options);
		}
	</script>
 </head>

<body id="home">

<div class="row">
		<div class="col-sm-6" style="padding-bottom: 10px;">				
			<table id="viewProjects" class="table table-striped table-bordered">
			<thead>
				<tr>
					<th class="col-sm-4"><p style="font-size:12px;text-align: -webkit-center">Name</p></th>
					<th class="col-sm-2"> <p style="font-size:12px;text-align: -webkit-center">Start Date</p></th>
					<th class="col-sm-2"><p style="font-size:12px;text-align: -webkit-center">End Date</p></th>
					<th class="col-sm-4"><p style="font-size:12px;text-align: -webkit-center">Leader</p></th>
				</tr>
			</thead>
			<tbody>
			 	{{range $key, $project := .Projects}}
				<tr>
					<td>{{$project.Name}}</td>
					<td>{{dateformat $project.StartDate "2006-01-02"}}</td>
					<td>{{dateformat $project.EndDate "2006-01-02"}}</td>
					<td>{{$project.Lead}}</td>
				</tr>
				{{end}}	
			</tbody>
			</table>
		</div>	
		<div class="col-sm-6" style="padding-bottom: 10px;">											
			<div id="panel-df-projectUnassign" class="panel panel-default">
				<div id="unassign" class="panel-heading">
					<p style="font-size:14px;text-align: -webkit-center;">Available hours per resource</p>
				</div>
				
				<table id="viewResourcesPerProjectUnassign" class="table table-striped table-bordered">
					<thead id="availabilityTableHead">
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-3">Resource Name</th>
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Monday</th>
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Tuesday</th>
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Wednesday</th>
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Thursday</th>
						<th style="font-size:12px;text-align: -webkit-center;" class="col-sm-1">Friday</th>
					</thead>
					<tbody id="unassignBody">
						{{$availBreakdown := .AvailBreakdown}}
						{{$dates := .Dates}}
						
						{{range $index, $resource := .Resources}}
						<tr draggable=false>
							
							{{range $rID, $mapAvail := $availBreakdown}}
								{{if eq $resource.ID $rID}}
									<td style="background-position-x: 1%;font-size:11px;text-align: -webkit-center;margin:0 0 0px;">{{$resource.Name}} {{$resource.LastName}}</td>
									{{range $index, $date := $dates}}
										{{$availDay := index $mapAvail $date}}
										{{if $availDay}}
											<td style="font-size:11px;text-align: -webkit-center;">{{$availDay}}</td>
										{{else}}
											<td style="font-size:11px;text-align: -webkit-center;"></td>
										{{end}}
									{{end}}
								{{end}}
							{{end}}
						</tr>
						{{end}}
					</tbody>
				</table>
			</div>														
		</div>
	</div>
	
	<div id="chart_div"></div>	

</body>
</html>