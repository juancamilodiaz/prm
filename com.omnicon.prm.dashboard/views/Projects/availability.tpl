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
		var week=0;
		var data;
		var options;
		var chart;
		
		google.charts.load('current', {'packages':['gantt']});
	    google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			data = new google.visualization.DataTable();
			
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
					[{{$project.Name}}, {{$project.Name}}+{{$project.Lead}}, parseDate({{$project.StartDate}}), parseDate({{$project.EndDate}}), 0, {{$project.Percent}},""]
					
			{{end}}
			]);
			options = {
		    	height: 375
		    };
	
	      	chart = new google.visualization.Gantt(document.getElementById('chart_div'));
	      	chart.draw(data, options);
		}
		
		function repaint() {
			chart.draw(data, options);
		}
		
		$(document).ready(function(){
			$('#backButton').css("display", "none");
			$('#refreshButton').css("display", "none");
			$('#buttonOption').css("display", "none");
			$('#datePicker').css("display", "none");
			setWeek(0);
			$( window ).resize(function() {repaint();});
		});
		
		function setWeek(i) {
			week += i;
			$('.search-button').prop('disabled', true);
			var dateFrom= moment('{{.DateFrom}}').add(week*7, 'days');
			var dateTo= moment('{{.DateTo}}').add(week*7, 'days');
			$('#hoursDateFrom').html(dateFrom.format('YYYY-MM-DD'));
			$('#hoursDateTo').html(dateTo.format('YYYY-MM-DD'));
			
			var settings = {
				method: 'POST',
				url: '/dashboard/availablehours',
				headers: {
					'Content-Type': undefined
				},
				data: { 
					"dateFrom": dateFrom.format('YYYY-MM-DD')
				}
			}
			$.ajax(settings).done(function (response) {
				$("#viewResourcesPerProjectUnassign").html(response);
				$('.search-button').prop('disabled', false);
			});
		}
		
		// parse a date in yyyy-mm-dd format
		function parseDate(input) {
		  var parts = input.match(/(\d+)/g);
		  // new Date(year, month [, date [, hours[, minutes[, seconds[, ms]]]]])
		  return new Date(parts[0], parts[1]-1, parts[2]); // months are 0-based
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
					<p style="font-size:14px;text-align: -webkit-center;">
						Available hours per resource 
					</p>
					<p style="font-size:12px;text-align: -webkit-center;">
						<button onclick="setWeek(-1)" class="search-button"><i class="fa fa-caret-left" aria-hidden="true"></i></button>
						<label id="hoursDateFrom"></label> / <label id="hoursDateTo"></label>
						<button onclick="setWeek(1)" class="search-button"><i class="fa fa-caret-right" aria-hidden="true"></i></button>
					</p>
				</div>
				
				<table id="viewResourcesPerProjectUnassign" class="table table-striped table-bordered">
				</table>
			</div>														
		</div>
	</div>
	
	<div id="chart_div"></div>	

</body>
</html>