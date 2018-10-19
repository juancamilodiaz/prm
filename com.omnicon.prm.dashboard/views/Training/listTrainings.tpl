<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewTrainings').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
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
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("href", "#trainingModal");
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
		$('select').material_select();
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
			$('#skillValue').material_select();
        {{end}}
	});
	
</script>


<div class ="container">
	<div class="row">
		<div class="col s12   marginCard">
			<div id="pry_add">
				<h4 id="titlePag"></h4>
				<a id="refreshButton" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Refresh"  ><i class="mdi-navigation-refresh large"></i></a>
				<a id="buttonOption" class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "New Training"><i class="mdi-action-note-add large"></i></a>
			</div>
			<table id="viewTrainings" class="display TableConfig " cellspacing="0" width="100%">
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
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Edit"  href="#trainingModal"  onclick="configureUpdateModal({{$training.ID}},'{{$training.Name}}', '{{$training.TypeName}}', '{{$training.SkillName}}')" ><i class="mdi-editor-mode-edit"></i></a>
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href='#confirmModal' onclick="$('#nameDelete').html('{{$training.Name}}');$('#trainingID').val({{$training.ID}});"><i class="mdi-action-delete"></i></a>
						</td>
					</tr>
					{{end}}	
				</tbody>
			</table>
		</div>	
	</div>
</div>


<!-- Modal -->
<!-- Materialize Modal Update -->
	<div id="trainingModal" class="modal overflowModal " >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Create/Update Training</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="trainingID">
				<div class="input-field row">
					<div class="col s12 m7 l7">
						<input id="trainingName" type="text" class="validate">
						<label  for="trainingName"  class="active">Name</label>
					</div>	
					<!-- Select -->
					<div class="input-field col s12 m5 l5" id="typeInput">
						<label  class= "active">Select Type</label>
						<select id="typeValue">
							<option id="">Type...</option>
							{{range $index, $type := .Types}}
							<option id="{{$type.ID}}">{{$type.Name}}</option>
							{{end}}
						</select>
					</div>
					<!-- Select2 -->

					<div class="input-field col s12 m5 l5" id="skillInput">
						<label  class= "active">Select Skill</label>
						<select id="skillValue" style="width: 174px; border-radius: 8px;">
            	 <option id="">Skill...</option>
          	</select>
					</div>
					<!-- Close Select -->
				</div>
			</div>
			<div class="modal-footer">
				<a id="trainingCreate" onclick="createTraining()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Create</a>
				<a id="trainingUpdate" onclick="updateTraining()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close"  >Update</a>
       		 	<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->




<!-- Materialize Modal Delete -->
<div id="confirmModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="skillID">
				Are you sure you want to remove <b id="nameDelete"></b> from trainings?
				<br>
				<li>The resources will lose this training assignment.</li>
			</div>
			<div class="modal-footer">
				<a onclick="deleteTraining()" class="btn green white-text waves-effect waves-light btn-flat modal-action modal-close" >Yes</a>
        		<a class="btn red white-text waves-effect waves-light btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal delete close -->