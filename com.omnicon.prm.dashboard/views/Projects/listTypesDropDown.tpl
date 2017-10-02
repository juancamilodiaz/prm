<option value="">Please select an option</option>
{{range $key, $types := .Types}}
	<option value={{$types.ID}}>{{$types.ID}} {{$types.Name}}</option>
{{end}}	