<script>
	$(document).ready(function(){
		$('#viewTrainings').DataTable({
			"columns":[
				null,
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Trainings");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/trainings',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Training");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#trainingModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
	});
	
	configureCreateModal = function(){
		
		$("#trainingID").val(null);
		$("#trainingName").val(null);
		
		$("#typeInput").show();
		$("#skillInput").show();
		
		$("#modalTitle").html("Create Training");
		$("#trainingCreate").css("display", "inline-block");
		$("#trainingUpdate").css("display", "none");		
	}
	
	configureUpdateModal = function(pID, pName, pTypeName, pSkillName){
		
		$("#trainingID").val(pID);
		$("#trainingName").val(pName);
		
		$("#typeInput").hide();
		$("#skillInput").hide();
		
		$("#modalTitle").html("Update Training");
		$("#trainingCreate").css("display", "none");
		$("#trainingUpdate").css("display", "inline-block");
	}

	createTraining = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/create',
			headers: {
				'Content-Type': undefined
			},
			data: {
				"TypeId": $('#typeValue option:selected').attr('id'),
				"SkillId": $('#skillValue option:selected').attr('id'),
				"Name": $('#trainingName').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/trainings', {});
		});
	}
	
	updateTraining = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#trainingID').val(),
				"Name": $('#trainingName').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/trainings', {});
		});
	}
	
	deleteTraining = function(){
		var settings = {
			method: 'POST',
			url: '/trainings/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#trainingID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/trainings', {});
		});
	}
	
	$('#typeValue').change(function() {
		$('#skillValue').html('<option id="">Skill...</option>');
        {{range $index, $typeSkill := .TypesSkills}}
			if ({{$typeSkill.TypeId}} == $('#typeValue option:selected').attr('id')) {
        		$('#skillValue').append('<option id="{{$typeSkill.SkillId}}">{{$typeSkill.Name}}</option>');
			}
        {{end}}
	});
	
</script>
<div>
<table id="viewTrainings" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Type Name</th>
			<th>Skill Name</th>
			<th>Training Name</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $training := .Trainings}}
		<tr>
			<td>{{$training.TypeName}}</td>
			<td>{{$training.SkillName}}</td>
			<td>{{$training.Name}}</td>
			<td>
				<button class="buttonTable button2" data-toggle="modal" data-target="#trainingModal" onclick="configureUpdateModal({{$training.ID}},'{{$training.Name}}', '{{$training.TypeName}}', '{{$training.SkillName}}')" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$training.Name}}');$('#trainingID').val({{$training.ID}});" data-dismiss="modal">Delete</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal fade" id="trainingModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title">Create/Update Training</h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="trainingID">
		<div class="row-box col-sm-12" style="padding-bottom: 1%;" id="typeInput">
		  <div class="form-group form-group-sm">
		     <label class="control-label col-sm-4 translatable" data-i18n="Select Type"> Select Type </label>
		     <div class="col-sm-8">
			 <select id="typeValue" style="width: 174px; border-radius: 8px;">
			    <option id="">Type...</option>
			    {{range $index, $type := .Types}}
			    <option id="{{$type.ID}}">{{$type.Name}}</option>
			    {{end}}
			 </select>
		     </div>
		  </div>
		</div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;" id="skillInput">
           <div class="form-group form-group-sm">
              <label class="control-label col-sm-4 translatable" data-i18n="Select Skill"> Select Skill </label>
              <div class="col-sm-8">
          <select id="skillValue" style="width: 174px; border-radius: 8px;">
             <option id="">Skill...</option>
          </select>
              </div>
           </div>
        </div>
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              <div class="col-sm-8">
              	<input type="text" id="trainingName" style="border-radius: 8px;">
        		</div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="trainingCreate" class="btn btn-default" onclick="createTraining()" data-dismiss="modal">Create</button>
        <button type="button" id="trainingUpdate" class="btn btn-default" onclick="updateTraining()" data-dismiss="modal">Update</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
    
  </div>
</div>
<div class="modal fade" id="confirmModal" role="dialog">
<div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Confirmation</h4>
      </div>
      <div class="modal-body">
        Are you sure you want to remove <b id="nameDelete"></b> from trainings?
		<br>
		<li>The resources will lose this training assignment.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="trainingDelete" class="btn btn-default" onclick="deleteTraining()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>