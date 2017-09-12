{{range $key, $resource := .Resources}}
	<option value={{$resource.ID}}>{{$resource.Name}} {{$resource.LastName}}</option>
{{end}}	