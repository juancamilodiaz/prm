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
	<button type="button" id="projectAssign" class="btn btn-default" onclick="reportProjectAssign()">Project Assign</button>
	<button type="button" id="projectAssign" class="btn btn-default" onclick="reportResourceAssign()">Resource Assign</button>
	<br>

</div>

<div id="reports" style="height: 350px;">
	
</div>




