<script>
		$(document).ready(function(){
			$('#datePicker').css("display", "none");
			$('#refreshButton').css("display", "none");
			$('#optionButton').css("display", "none");
		});
		
		reportProjectAssign = function(){
			var settings = {
				method: 'POST',
				url: '/reports/projectassign',
				headers: {
					'Content-Type': undefined
				},
				data: { 
				}
			}
			$.ajax(settings).done(function (response) {
				console.log(response);
				$('#reports').html(response)
			});
		}
		
		reportResourceAssign = function(){
			var settings = {
				method: 'POST',
				url: '/reports/resourceassign',
				headers: {
					'Content-Type': undefined
				},
				data: { 
				}
			}
			$.ajax(settings).done(function (response) {
				console.log(response);
				$('#reports').html(response)
			});
		}
</script>

<div>
	<br>
	<br>
	<table id="viewProjects" class="table table-striped table-bordered">
		<thead>
			<tr>
				<th>Report Name</th>			
				<th>Options</th>			
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Project Assign</td>
				<td><button class="buttonTable button2" id="projectAssign" onclick="reportProjectAssign()">Generate</button></td>
			</tr>
			<tr>
				<td>Resource Assign</td>
				<td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="projectAssign" onclick="reportResourceAssign()" data-dismiss="modal"> Generate</button></td>
			</tr>
		</tbody>
	</table>
	
	
	
	<br>

</div>


<div id="reports" style="height: 350px;">
	
</div>




