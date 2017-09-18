<option value="">Please select an option</option>
{{range $key, $resource := .Resources}}
	<option value={{$resource.ID}}>{{$resource.Name}} {{$resource.LastName}}</option>
{{end}}	