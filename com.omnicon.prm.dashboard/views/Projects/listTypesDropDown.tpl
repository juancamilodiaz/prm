{{range $key, $types := .Types}}
	<option value={{$types.ID}}>{{$types.ID}} {{$types.Name}}</option>
{{end}}	