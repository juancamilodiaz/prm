<div class="container">
{{range $key, $resource := .Resources}}
	<div class="input-field col s12 m5 l5">
		<label class="active"> Name </label>
		<input type="text" id="showResourceName" value="{{$resource.Name}}" readonly >
	</div>
	<div class="input-field col s12 m5 l5">
		    <label class="active"> Last Name </label> 
			<input type="text" id="showResourceLastName" value="{{$resource.LastName}}" readonly>		
	</div>
	<div class="input-field col s12 m5 l5">
		    <label class="active">Email </label>
			<input type="text" id="showResourceEmail" value="{{$resource.Email}}" readonly>
	</div>
	<div class="input-field col s12 m5 l5">
		    <label class="active"> Enginer Rank </label> 
			<input type="text" id="showResourceRank" value="{{$resource.EngineerRange}}" readonly>
	</div>
	<div class="input-field col s12 m5 l5">
		<p>
		   
			<input type="checkbox" id="showResourceActive" {{if $resource.Enabled}}checked{{end}} disabled>
			<label class="active"> Active </label> 
		</p>
			<br/>
		  
	   </div>
	</div>
{{end}}
</div>
