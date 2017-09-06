<script>
	$(document).ready(function(){
		$('#viewResources').DataTable({

		});
	});
	function update(id){
		
	}
	
	function update(id){
		
	}
</script>
<div>
<table id="viewResources" class="table table-striped table-bordered">
	<thead>
		<tr>
			<th>Name</th>
			<th>Last Name</th>
			<th>Email</th>
			<th>Engineer Rank</th>
			<th>Enabled</th>
			<th>Options</th>
		</tr>
	</thead>
	<tbody>
	 	{{range $key, $resource := .Resources}}
		<tr>
			<td>{{$resource.Name}}</td>
			<td>{{$resource.LastName}}</td>
			<td>{{$resource.Email}}</td>
			<td>{{$resource.EngineerRange}}</td>
			<td>{{$resource.Enabled}}</td>
			<td><button class="BlueButton" data-toggle="modal" data-target="#myModal" onclick="update({{$resource.ID}})" >Update</button> <button onclick="delete({{$resource.ID}})" class="BlueButton">Delete</button></td>
		</tr>
		{{end}}	
	</tbody>
</table>
<div style="text-align:center;">
	<button class="BlueButton" data-toggle="modal" data-target="#myModal">Create</button>
</div>
</div>

<!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Create Resource</h4>
        </div>
        <div class="modal-body">
          <input type="hidden" id="resourceID">
          <div class="row-box col-sm-12">
          	<div class="form-group form-group-sm">
          		<label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
                <div class="col-sm-8">
                	<input type="text" id="resourceName">
          		</div>
            </div>
          </div>
          <div class="row-box col-sm-12">
          	<div class="form-group form-group-sm">
          		<label class="control-label col-sm-4 translatable" data-i18n="Last Name"> Last Name </label> 
                <div class="col-sm-8">
                	<input type="text" id="resourceLastName">
          		</div>
            </div>
          </div>
          <div class="row-box col-sm-12">
          	<div class="form-group form-group-sm">
          		<label class="control-label col-sm-4 translatable" data-i18n="Email"> Email </label> 
                <div class="col-sm-8">
                	<input type="text" id="resourceEmail">
          		</div>
            </div>
          </div>
          <div class="row-box col-sm-12">
          	<div class="form-group form-group-sm">
          		<label class="control-label col-sm-4 translatable" data-i18n="Enginer Rank"> Enginer Rank </label> 
                <div class="col-sm-8">
                	<select id="resourceRank"><option value="E1">E1</option><option value="E1">E2</option><option value="E1">E3</option><option value="E1">E4</option></select>
          		</div>
            </div>
          </div>
          <div class="row-box col-sm-12">
          	<div class="form-group form-group-sm">
          		<label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
                <div class="col-sm-8">
                	<input type="checkbox" id="resourceActive"><br/>
                </div>    
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Create</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Update</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </div>
      
    </div>
  </div>