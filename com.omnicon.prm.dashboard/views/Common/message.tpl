{{if compare .Type "Success"}}
<div class="alert alert-success">
{{else if compare .Type "Warning"}}
<div class="alert alert-warning">
{{else if compare .Type "Error"}}
<div class="alert alert-danger">
{{else}}
<div class="alert alert-info">
{{end}}
	<strong>{{ .Title }}</strong>{{ .Message }}
</div>