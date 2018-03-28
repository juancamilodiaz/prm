<script>
	$(document).ready(function(){
		$('#viewTypes').DataTable({
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
		$('#buttonOptionIcon').html("add");
		$('#buttonOptionTooltip').html("Add new type");
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
		$("#typesTo").attr("disabled", false);
		
		$("#modalTitle").html("Create Type");
		$("#typeUpdate").css("display", "none");
		$("#typeCreate").css("display", "inline-block");
	}
	
	configureUpdateModal = function(pID, pName, pTypeTo){
		
		$("#typeID").val(pID);
		$("#typeName").val(pName);
		$("#typesTo").val(pTypeTo);
		$("#typesTo").attr("disabled", "disabled");
		
		$("#modalTitle").html("Update Type");
		$("#typeCreate").css("display", "none");
		$("#typeUpdate").css("display", "inline-block");
	}

	createType = function(){
		var settings = {
			method: 'POST',
			url: '/types/create',
			headers: {
				'Content-Type': undefined
			},
			data: { 
				"Name": $('#typeName').val(),
				"ApplyTo": $('#typesTo option:selected').attr("id")
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
<button class="mdl-button" data-toggle="collapse" data-target="#filters">
	<i class="material-icons">tune</i>
</button>
<div id="filters" class="collapse">
   <div class="row">
      <div class="col-md-6">
         <div class="form-group">
            <label for="typesValue">Types to:</label>
            <select class="form-control" id="typesValue">
               <option id="">All types</option>
               {{range $index, $applyTo := .ListApplyTo}}
               <option id="{{$applyTo}}">{{$applyTo}}</option>
               {{end}}
            </select>
         </div>
         <div class="form-group">
           
         </div>
      </div>
      <div class="col-md-6">
         <div class="form-group">
         </div>
         <div class="form-group">
         </div>
      </div>
   </div>
</div>
<div>
<table id="viewTypes" class="table table-striped table-bordered">
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
				<button class="buttonTable button2" data-toggle="modal" data-target="#typeModal" onclick="configureUpdateModal({{$types.ID}},'{{$types.Name}}','{{$types.ApplyTo}}')" data-dismiss="modal">Update</button>
				<button data-toggle="modal" data-target="#confirmModal" class="buttonTable button2" onclick="$('#nameDelete').html('{{$types.Name}}');$('#typeID').val({{$types.ID}});" data-dismiss="modal">Delete</button>
				<button class="buttonTable button2" onclick="getSkillsByType({{$types.ID}}, '{{$types.Name}}');" data-dismiss="modal">Skills</button>
			</td>
		</tr>
		{{end}}	
	</tbody>
</table>

</div>

<!-- Modal -->
<div class="modal fade" id="typeModal" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="modalTitle" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <input type="hidden" id="typeID">
        <div class="row-box col-sm-12" style="padding-bottom: 1%;">
        	<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
              	<div class="col-sm-8">
              		<input type="text" id="typeName" style="border-radius: 8px;">
        		</div>
          	</div>
        </div>
		<div class="row-box col-sm-12" style="padding-bottom: 1%;">        	
			<div class="form-group form-group-sm">
        		<label class="control-label col-sm-4 translatable" data-i18n="Apply To"> Apply To </label>
              	<div class="col-sm-8">
					<select id="typesTo" style="border-radius: 8px; width: 174px;">
		               {{range $index, $applyTo := .ListApplyTo}}
		               <option id="{{$applyTo}}">{{$applyTo}}</option>
		               {{end}}
		            </select>
        		</div>
          	</div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" id="typeCreate" class="btn btn-default" onclick="createType()" data-dismiss="modal">Create</button>
        <button type="button" id="typeUpdate" class="btn btn-default" onclick="updateType()" data-dismiss="modal">Update</button>
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
        Are you sure you want to remove <b id="nameDelete"></b> from types?
		<br>
		<li>The projects will lose this type assignment.</li>
		<li>The skills will lose this type assignment.</li>
		<li>The training and the training's assignations will lose this skill assignment and they will be eliminated.</li>
      </div>
      <div class="modal-footer" style="text-align:center;">
        <button type="button" id="typeDelete" class="btn btn-default" onclick="deleteType()" data-dismiss="modal">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>