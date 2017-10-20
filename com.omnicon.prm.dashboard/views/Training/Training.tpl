<script src="/static/js/chartjs/Chart.min.js">
</script>

<script>
	$(document).ready(function(){
		$('#datePicker').css("display", "none");
		$('#refreshButton').css("display", "none");
		$('#backButton').css("display", "none");
		$('#buttonOption').css("display", "none");
	});
	
	google.charts.load('current', {'packages':['gantt']});
    google.charts.setOnLoadCallback(drawChart);
		
	function drawChart() {
		var data = new google.visualization.DataTable();
		
		data.addColumn('string', 'Training ID');
		data.addColumn('string', 'Training Name');
		data.addColumn('date', 'Start Date');
		data.addColumn('date', 'End Date');
		data.addColumn('number', 'Duration');
		data.addColumn('number', 'Percent Complete');
      	data.addColumn('string', 'Dependencies');

		data.addRows([
		{{range $xx, $training := .TSkills}}
				{{if (ne $xx 0)}}
					,
				{{end}}
				[{{$training.SkillName}}, {{$training.SkillName}}, new Date({{$training.StartDate}}), new Date({{$training.EndDate}}), 0, {{$training.Progress}},""]
				
		{{end}}
		]);
		var options = {
	    	height: 375
	    };

      	var chart = new google.visualization.Gantt(document.getElementById('chart_div'));
      	chart.draw(data, options);
	}
</script>

<button class="buttonHeader button2" data-toggle="collapse" data-target="#filters">
<span class="glyphicon glyphicon-filter"></span> Filter 
</button>
<div id="filters" class="collapse">
   <div class="row">
      <div class="col-md-6">
         <div class="form-group">
            <label for="resourcesValue">Resources list:</label>
            <select class="form-control" id="resourcesValue">
               <option id="">All resources</option>
               {{range $index, $resource := .Resources}}
               <option id="{{$resource.ID}}">{{$resource.Name}} {{$resource.LastName}}</option>
               {{end}}
            </select>
         </div>
      </div>
      <div class="col-md-6">
         <div class="form-group">
            <label for="projectsValue">Training list:</label>
            <select class="form-control" id="projectsValue">
               <option id="">All training</option>
               {{range $index, $type := .Types}}
               <option id="{{$type.ID}}">{{$type.Name}}</option>
               {{end}}
            </select>
         </div>
      </div>
   </div>
</div>
<div class="col-sm-12">
   <br>
   <br>
	<table id="viewTraining" class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>Training Name</th>
				<th>Start Date</th>
				<th>End Date</th>
				<th>Duration</th>
				<th>Progress</th>
				<th>Test Result</th>
				<th>Result Status</th>
			</tr>
		</thead>
		<tbody>
		 	{{range $key, $tSkill := .TSkills}}
			<tr>
				<td>{{$tSkill.SkillName}}</td>
				<td>{{dateformat $tSkill.StartDate "2006-01-02"}}</td>
				<td>{{dateformat $tSkill.EndDate "2006-01-02"}}</td>
				<td>{{$tSkill.Duration}}</td>
				<td>{{$tSkill.Progress}}</td>
				<td>{{$tSkill.TestResult}}</td>
				<td>{{$tSkill.ResultStatus}}</td>
			</tr>
			{{end}}
		</tbody>
	</table>
	
	
</div>


<div class="col-sm-12">
	<div class="col-sm-6">
		<p>
		   	<div class="chart-container" id="chartjs-wrapper">
				<canvas id="chartjs">
				</canvas>
			
				<script>
					new Chart(document.getElementById("chartjs"),
					{	"type": "pie",
						"data": {
							"labels": {{.TStatus}},
							"datasets": [{ 
								"data": {{.TValues}},
								"backgroundColor":["rgb(255, 99, 132)","rgb(54, 162, 235)"]
								
							}]						
						}
						
					});
				</script>
		
			</div>
		</p>
	</div>
	<div id="chart_div" class="col-sm-6">
	</div>
</div>