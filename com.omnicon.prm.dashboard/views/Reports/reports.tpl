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
				$('#reports').html(response);
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
				$('#reports').html(response);
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
            <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="projectAssign" onclick="reportProjectAssign();$('#titleReport').html('Report Projects Assign');" data-dismiss="modal">Generate</button></td>
         </tr>
         <tr>
            <td>Resource Assign</td>
            <td><button data-toggle="modal" data-target="#viewReport" class="buttonTable button2" id="resourceAssign" onclick="reportResourceAssign();$('#titleReport').html('Report Resources Assign');" data-dismiss="modal">Generate</button></td>
         </tr>
      </tbody>
   </table>
   <br>
</div>


<div class="modal fade" id="viewReport" role="dialog" style="border-radius:8px">
<div class="modal-dialog" style="width: 95%;height: 90%;padding: 0;">
   <!-- Modal content-->
   <div class="modal-content" style="height: 100%;">
      <div class="modal-header">
         <button type="button" class="close" data-dismiss="modal">&times;</button>
         <h4 id="titleReport" class="modal-title"></h4>
      </div>
      <div class="modal-body" style="height: 80%">
         <div id="reports" style="height: 100%;"/>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
         </div>
      </div>
   </div>
</div>





