<script>
	$(document).ready(function(){
		$('#viewSkillsByType').DataTable({
			"columns":[
				null,
				null,
				{"searchable":false}
			]
		});
		
		$('#backButton').css("display", "inline-block");
		$('#backButton').html("Types");
		$('#backButton').prop('onclick',null).off('click');
		$('#backButton').click(function(){
			reload('/types',{});
		}); 
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/types/skills',{
				"ID": {{.TypeID}},
				"Name": "{{.Title}}"
			});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("Set New Skill");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#loadSkillModal");
		$('#buttonOption').attr("onclick", "configureCreateTypeModal();");		
		
	});
	
	configureCreateTypeModal = function(){
		$("#skillId").removeAttr("disabled", "disabled");
		$("#skillId option:selected").val("");
		$("#skillId option:selected").text("Please select an option");
		$("#typeValueSkill").val("1");
		
		$("#modalTitleType").html("Create Skill to Type");
	}
	
	configureUpdateTypeModal = function(pSkillId, pValue){
		$("#skillId option:selected").val(pSkillId);
		$("#skillId option:selected").text(pSkillId.split("-")[1]);
		$("#skillId").attr("disabled", "disabled");
		$("#typeValueSkill").val(pValue);
		
		$("#modalTitleType").html("Update Skill to Type");
	}
	
</script>

<table id="viewSkillsByType" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Skill</th>
			<th>Value</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $typeSkill := .TypeSkills}}
		<tr>
			<td>{{$typeSkill.Name}}</td>
			<td>{{$typeSkill.Value}}</td>
			<td>
				<button data-toggle="modal" data-target="#loadSkillModal" class="buttonTable button2" onclick="configureUpdateTypeModal('{{$typeSkill.SkillId}}-{{$typeSkill.Name}}',{{$typeSkill.Value}})" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmUnassignModal" class="buttonTable button2"  onclick="$('#nameDelete').html('{{$typeSkill.Name}}');$('#typeSkillId').val({{$typeSkill.ID}});" data-dismiss="modal">Unassign</button>				
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

<div class="modal fade" id="confirmUnassignModal" role="dialog">
	<div class="modal-dialog">
    <!-- Modal content-->
    	<div class="modal-content">
      		<div class="modal-header">
        		<button type="button" class="close" data-dismiss="modal">&times;</button>
        		<h4 class="modal-title">Unassign Confirmation</h4>
      		</div>
      		<div class="modal-body">
				<input type="hidden" id="typeSkillId">
					Are you sure that you want to unassign <b id="nameDelete"></b> from Types?
      		</div>
			<div class="modal-footer" style="text-align:center;">
				<button type="button" id="resourceUnassign" class="btn btn-default" onclick="unassignTypeSkills({{.TypeID}}, $('#typeSkillId').val())" data-dismiss="modal">Yes</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">No</button>
			</div>
		</div>
	</div>
</div>


<!-- Modal -->
<div class="modal fade" id="loadSkillModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitleType" class="modal-title">Select Skill</h4>
      </div>
      <div class="modal-body">
		<div class="row-box col-sm-12">
			<div id="divSkillType" class="form-group form-group-sm">
	       		<label class="control-label col-sm-4 translatable" data-i18n="Skill"> Skill </label> 
	            	<div class="col-sm-8">
	             	<select  id="skillId">
					<option value="">Please select an option</option>
					{{range $key, $skill := .Skills}}
						<option value="{{$skill.ID}}-{{$skill.Name}}">{{$skill.Name}}</option>
					{{end}}
					</select>
	             </div>    
	        </div>
		</div>
		<div class="row-box col-sm-12">
			<div class="form-group form-group-sm">
				<label class="control-label col-sm-4 translatable" data-i18n="Value"> Value </label> 
				<div class="col-sm-8">
					<input type="number" id="typeValueSkill" min="1" max="100" value="1">
				</div>
			</div>
		</div>
		
      </div>
      <div class="modal-footer">
        <button type="button" id="addSkill" class="btn btn-default" onclick="addSkillToType({{.TypeID}},$('#skillId').val(),$('#typeValueSkill').val())" data-dismiss="modal">Add</button>
		<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>