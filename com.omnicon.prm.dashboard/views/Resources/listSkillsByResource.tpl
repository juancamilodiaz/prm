<script>
	$(document).ready(function(){
		$('#viewSkillsInResource').DataTable({

		});
		$('#titlePag').html("{{.Title}}")
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Resources");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/resources',{});
		}); 
	});
	
	configureUpdateSkillResourceModal = function(pSkillId, pName, pValue){
		$("#updateResourceSkillId").val(pSkillId);
		$("#updateResourceNameSkill").val(pName);
		$("#updateResourceValueSkill").val(pValue);
		$("#deleteResourceSkillId").val(pSkillId);
		
		$("#modalTitle").html("Update Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}
	
	configureDeleteSkillResourceModal = function(pSkillId){
		$("#deleteResourceSkillId").val(pSkillId);
		
		$("#modalTitle").html("Delete Skill to Resource");
		$("#resourceCreate").css("display", "none");
		$("#resourceUpdate").css("display", "inline-block");
	}

	
	setSkillToResource = function(resourceId, resourceName, value){
		var settings = {
			method: 'POST',
			url: '/resources/setskill',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ResourceId": resourceId,
				"SkillId": resourceName,
				"Value": value
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  reload('/resources/skills', {"ID": {{.ResourceId}},"ResourceName": {{.Title}}});
		});
	}
	
	deleteSkillToResource = function(resourceId, skillId){
		var settings = {
			method: 'POST',
			url: '/resources/deleteskill',
			headers: {
				'Content-Type': undefined
			},
			data: {	  
				"ResourceId": resourceId,
				"SkillId": skillId
			}
		}
		console.log(settings);
		$.ajax(settings).done(function (response) {
		  reload('/resources/skills', {"ID": {{.ResourceId}},"ResourceName": {{.Title}}});
		});
	}
</script>
<table id="viewSkillsInResource" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Value</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $skill := .Skills}}
		<tr>
			<td>{{$skill.Name}}</td>
			<td>{{$skill.Value}}</td>
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#updateResourceSkillModal" onclick="configureUpdateSkillResourceModal({{$skill.SkillId}},'{{$skill.Name}}',{{$skill.Value}})" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmDeleteSkillResourceModal" class="buttonTable button2" onclick="configureDeleteSkillResourceModal({{$skill.SkillId}});$('#nameDelete').html('{{$skill.Name}}');$('#skillID').val({{$skill.SkillId}});" data-dismiss="modal">Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="button button2" data-toggle="modal" data-target="#resourceSkillModal" onclick="configureCreateModal()">Set New Skill</button>
</div>
<!-- Modal -->
	<div class="modal fade" id="resourceSkillModal" role="dialog">
  		<div class="modal-dialog">
    		<!-- Modal content-->
    		<div class="modal-content">
      			<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			        <h4 id="modalResourceSkillTitle" class="modal-title"></h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="resourceIDSkills">
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Skill Name"> Skill Name </label>
          					<div class="col-sm-8">
          						<select id="resourceNameSkill">
									<option value="">Please select an option</option>
									<option value=50>Savigent</option>
								</select>
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Value"> Value </label> 
             				<div class="col-sm-8">
              					<input type="text" id="resourceValueSkill">
        					</div>
          				</div>
        			</div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="resourceSkillCreate" class="btn btn-default" onclick="setSkillToResource({{.ResourceId}}, $('#resourceNameSkill').val(),$('#resourceValueSkill').val())" data-dismiss="modal">Set</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			    </div>
    		</div>    
  		</div>
	</div>
	<!-- Modal -->
	<div class="modal fade" id="updateResourceSkillModal" role="dialog">
  		<div class="modal-dialog">
    		<!-- Modal content-->
    		<div class="modal-content">
      			<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal">&times;</button>
			        <h4 id="modalUpdateResourceSkillTitle" class="modal-title"></h4>
			    </div>
		    	<div class="modal-body">
					<input type="hidden" id="updateResourceSkillId">
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Skill Name"> Skill Name </label>
          					<div class="col-sm-8">
          						<input type="text" id="updateResourceNameSkill" disabled>
    						</div>
          				</div>
        			</div>
        			<div class="row-box col-sm-12">
        				<div class="form-group form-group-sm">
        					<label class="control-label col-sm-4 translatable" data-i18n="Value"> Value </label> 
             				<div class="col-sm-8">
              					<input type="text" id="updateResourceValueSkill">
        					</div>
          				</div>
        			</div>
      			</div>
      			<div class="modal-footer">
			        <button type="button" id="updateResourceSkill" class="btn btn-default" onclick="setSkillToResource({{.ResourceId}}, $('#updateResourceSkillId').val(), $('#updateResourceValueSkill').val())" data-dismiss="modal">Set</button>
			        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
			    </div>
    		</div>    
  		</div>
	</div>
	<div class="modal fase" id="confirmDeleteSkillResourceModal" role="dialog">
		<div class="modal-dialog">
	    	<!-- Modal content-->
		    <div class="modal-content">
	     		<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	        		<h4 class="modal-title">Delete Confirmation</h4>
	      		</div>
	      	<div class="modal-body">
				<input type="hidden" id="deleteResourceSkillId">
	      		Are you sure  yow want to remove <b id="nameDelete"></b> from <b>{{.Title}}</b>?
	      	</div>
	      	<div class="modal-footer" style="text-align:center;">
		        <button type="button" id="resourceSkillDelete" class="btn btn-default" onclick="deleteSkillToResource({{.ResourceId}}, $('#deleteResourceSkillId').val())" data-dismiss="modal">Yes</button>
		        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
	      	</div>
	    </div>
	</div>