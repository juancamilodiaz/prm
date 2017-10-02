<script>
	$(document).ready(function(){
		$('#refreshButton').css("display", "none");
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').html("Set Skill");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#loadSkillModal");
		
	});
</script>

<p class="pull-right" style="padding-right: 0%;"> <label type="text" id="dates"/></p>
<table id="viewSkillsByType" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Skill</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $typeSkill := .TypeSkills}}
		<tr>
			<td>{{$typeSkill.Name}}</td>
			<td>
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
        <h4 id="modalTitle" class="modal-title">Select Skill</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="skillID">
		<div id="divSkillType" class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Skill"> Skill </label> 
             	<div class="col-sm-8">
	             	<select  id="skillId">
					{{range $key, $skill := .Skills}}
						<option value="{{$skill.ID}}-{{$skill.Name}}">{{$skill.Name}}</option>
					{{end}}
					</select>
              </div>    
          </div>
		
		
      </div>
      <div class="modal-footer">
        <button type="button" id="addSkill" class="btn btn-default" onclick="addSkillToType({{.TypeID}},$('#skillId').val(),$('#skillId').val())" data-dismiss="modal">Add</button>
      </div>
    </div>
    
  </div>
</div>