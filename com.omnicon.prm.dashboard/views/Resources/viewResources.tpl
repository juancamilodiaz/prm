{{range $key, $resource := .Resources}}
	<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	   <div class="form-group form-group-sm">
		  <label class="control-label col-sm-4 translatable" data-i18n="Name"> Name </label>
		  <div class="col-sm-8">
			 <input type="text" id="showResourceName" value="{{$resource.Name}}" readonly style="border-radius: 8px;">
		  </div>
	   </div>
	</div>
	<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	   <div class="form-group form-group-sm">
		  <label class="control-label col-sm-4 translatable" data-i18n="Last Name"> Last Name </label> 
		  <div class="col-sm-8">
			 <input type="text" id="showResourceLastName" value="{{$resource.LastName}}" readonly style="border-radius: 8px;">
		  </div>
	   </div>
	</div>
	<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	   <div class="form-group form-group-sm">
		  <label class="control-label col-sm-4 translatable" data-i18n="Email"> Email </label> 
		  <div class="col-sm-8">
			 <input type="text" id="showResourceEmail" value="{{$resource.Email}}" readonly style="border-radius: 8px;">
		  </div>
	   </div>
	</div>
	<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	   <div class="form-group form-group-sm">
		  <label class="control-label col-sm-4 translatable" data-i18n="Enginer Rank"> Enginer Rank </label> 
		  <div class="col-sm-8">
			 <input type="text" id="showResourceRank" value="{{$resource.EngineerRange}}" readonly style="border-radius: 8px;">
		  </div>
	   </div>
	</div>
	<div class="row-box col-sm-12" style="padding-bottom: 1%;">
	   <div class="form-group form-group-sm">
		  <label class="control-label col-sm-4 translatable" data-i18n="Active"> Active </label> 
		  <div class="col-sm-8">
			 <input type="checkbox" id="showResourceActive" {{if $resource.Enabled}}checked{{end}} disabled><br/>
		  </div>
	   </div>
	</div>
{{end}}
