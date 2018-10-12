<script>
	$(document).ready(function(){
		$('.modal-trigger').leanModal();
		$('.tooltipped').tooltip();
		$('select').material_select();
		$('#viewTypes').DataTable({
			"iDisplayLength": 20,
			"bLengthChange": false,
			"columns":[
				null,
				null,
				{"searchable":false}
			]
		});
		$('#datePicker').css("display", "none");
		$('#backButton').css("display", "none");
		sendTitle("Types");
		$('#refreshButton').css("display", "inline-block");
		$('#refreshButton').prop('onclick',null).off('click');
		$('#refreshButton').click(function(){
			reload('/types',{});
		});
		
		$('#buttonOption').css("display", "inline-block");
		$('#buttonOption').attr("style", "display: padding-right: 0%");
		$('#buttonOption').html("New Type");
		$('#buttonOption').attr("data-toggle", "modal");
		$('#buttonOption').attr("data-target", "#typeModal");
		$('#buttonOption').attr("onclick","configureCreateModal()");
		
		$('#typesValue').on('change', function(){
			var row = "";
			if ($('#typesValue option:selected').attr("id") == ""){
				{{range $key, $types := .Types}}
					row += '<tr>' +
						'<td>{{$types.Name}}</td>' +
						'<td>{{$types.ApplyTo}}</td>' +
						'<td>' +
							'<button class="buttonTable button2" data-toggle="modal" data-target="#typeModal" onclick="'+ "configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')" +'" data-dismiss="modal">Update</button>' +
							'<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="'+$("#nameDelete").html("{{$types.Name}}")+ ';'+ $("#typeID").val({{$types.ID}}) + ';" data-dismiss="modal">Delete</button>' +
							'<button class="buttonTable button2" onclick="' + "getSkillsByType({{$types.ID}}, '{{$types.Name}}');" + '" data-dismiss="modal">Skills</button>' +
						'</td>' +
					'</tr>'	
				{{end}}	
			}else {	
				{{range $key, $types := .Types}}
						if($('#typesValue option:selected').attr("id") == {{$types.ApplyTo}}){
							row += '<tr>' +
								'<td>{{$types.Name}}</td>' +
								'<td>{{$types.ApplyTo}}</td>' +
								'<td>' +
									'<button class="buttonTable button2" data-toggle="modal" data-target="#typeModal" onclick="'+ "configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')" +'" data-dismiss="modal">Update</button>' +
									'<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="'+$("#nameDelete").html("{{$types.Name}}")+ ';'+ $("#typeID").val({{$types.ID}}) + ';" data-dismiss="modal">Delete</button>' +
									'<button class="buttonTable button2" onclick="' + "getSkillsByType({{$types.ID}}, '{{$types.Name}}');" + '" data-dismiss="modal">Skills</button>' +
								'</td>' +
							'</tr>'	
						}				
						
				{{end}}						
			}
			
			$('#viewTypes tbody').html(row);
		});	
	});
	
	configureCreateModal = function(){
		
		$("#typeID").val(null);
		$("#typeName").val(null);
		$("#typesTo").val(null);
		$(".select-dropdown").attr("disabled", false);
		$( ".mdi-navigation-arrow-drop-down" ).toggleClass( "disabled", false );
		
		$("#modalTitle").html("Create Type");
		$("#typeUpdate").css("display", "none");
		$("#typeCreate").css("display", "inline-block");
		
	}
	
	configureUpdateModal = function(pID, pName, pTypeTo){
		$("#typeID").val(pID);
		$("#typeName").val(pName);
		$("#typesTo").val(pTypeTo);
		$(".select-dropdown").attr("disabled", true);
		$( ".mdi-navigation-arrow-drop-down" ).toggleClass( "disabled", true );
		
		$("#modalTitle").html("Update Type");
		$("#typeCreate").css("display", "none");
		$("#typeUpdate").css("display", "inline-block");
	}

	createType = function(){
		if(typeof  $('#typesTo option:selected').attr("id") === "undefined"){
			var applyTo = "Project";
		}else{
		var applyTo = $('#typesTo option:selected').attr("id");
		}
		
		var settings = {
			method: 'POST',
			url: '/types/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#typeName').val(),
				"ApplyTo": applyTo
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/types', {});
		});
	}
	
	updateType = function(){
		var settings = {
			method: 'POST',
			url: '/types/update',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#typeID').val(),
				"Name": $('#typeName').val(),
				"ApplyTo": $('#typesTo option:selected').attr("id")
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/types', {});
		});
	}
	
	read = function(){
		var settings = {
			method: 'POST',
			url: '/types/read',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#typeName').val(),
			}
		}
		$.ajax(settings).done(function (response) {
		});
	}
	
	deleteType = function(){
		var settings = {
			method: 'POST',
			url: '/types/delete',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"ID": $('#typeID').val()
			}
		}
		$.ajax(settings).done(function (response) {
			validationError(response);
			reload('/types', {});
		});
	}
	
</script>
<!-- <button class="buttonHeader button2" data-toggle="collapse" data-target="#filters"> 
<span class="glyphicon glyphicon-filter"></span> Filter 
</button>-->

<div>
<div class="container">
	<div class="row">
	<div id="pry_add" class= "marginCard">
				<h4 >Types</h4>
				<a class="btn-floating btn-large waves-effect waves-light blue modal-trigger tooltipped" data-tooltip= "Create Type" href="#typeModal" onclick="configureCreateModal()"><i class="mdi-action-note-add large"></i></a>
			</div>
		<div class= "col s12 marginCard">
			
			<table id="viewTypes" class="display TableConfig " cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>Name</th>
						<th>Apply To</th>
						<th>Options</th>
					</tr>
				</thead>
				<tbody>
					{{range $key, $types := .Types}}
					<tr>
						<td>{{$types.Name}}</td>
						<td>{{$types.ApplyTo}}</td>
						<td>
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Update"  href="#typeModal"  onclick="configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')"><i class="mdi-editor-mode-edit"></i></a>	
							<a class='modal-trigger tooltipped' data-position="top" data-tooltip="Delete"  href="#confirmModal"  onclick="$('#nameDelete').html('{{$types.Name}}');$('#typeID').val({{$types.ID}});" data-dismiss="modal"><i class="mdi-action-delete"></i></a>	
							<a class='tooltipped' data-position="top" data-tooltip="Skills"  onclick="getSkillsByType({{$types.ID}}, '{{$types.Name}}');" ><i class="mdi-maps-local-library"></i></a>	
							
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
	<div id="typeModal" class="modal " >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title"></h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="typeID">
				<div class="input-field row">
					<div class="col s12 m7 l7">
						<input id="typeName" type="text" class="validate">
						<label  for="typeName"  class="active">Name</label>
					</div>	
					<!-- Select -->
					<div class="input-field col s12 m5 l5">
						<label  class= "active">Apply To</label>
						<select id = "typesTo">				
						{{range $index, $applyTo := .ListApplyTo}}
							<option id="{{$applyTo}}">{{$applyTo}}</option>
						{{end}}
						</select>
						
					</div>
	
					<!-- Close Select -->
				</div>
			</div>
			<div class="modal-footer">
				<a id="typeCreate" onclick="createType()" class="waves-effect waves-green btn-flat modal-action modal-close" >Create</a>
				<a id="typeUpdate" onclick="updateType()" class="waves-effect waves-blue btn-flat modal-action modal-close"  >Update</a>
       		 	<a class="waves-effect waves-red btn-flat modal-action modal-close">Cancel</a>
			</div>
	</div>
    
<!-- Modal Update -->


<!-- Materialize Modal Delete -->
<div id="confirmModal" class="modal" >
			<div class="modal-content">
				<h5 id="modalTitle" class="modal-title">Delete Confirmation</h5>
				<div class="divider CardTable"></div>
				<input type="hidden" id="skillID">
				Are you sure you want to remove <b id="nameDelete"></b> from types?
				<br>
				<li>The projects will lose this type assignment.</li>
				<li>The skills will lose this type assignment.</li>
				<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
			</div>
			<div class="modal-footer">
				<a onclick="deleteType()" class="waves-effect waves-green btn-flat modal-action modal-close" >Yes</a>
        		<a class="waves-effect waves-red btn-flat modal-action modal-close">No</a>
			</div>
</div>

<!-- Modal delete close -->