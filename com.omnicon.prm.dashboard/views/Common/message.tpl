{{if compare .Type "Success"}}
<div class="alert alert-success alert-dismissable fade in">
<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
{{else if compare .Type "Warning"}}
<div class="alert alert-warning alert-dismissable fade in">
<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
{{else if compare .Type "Error"}}
<div class="alert alert-danger alert-dismissable fade in">
<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
{{else}}
<div class="alert alert-info alert-dismissable fade in">
<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
{{end}}
	<strong>{{ .Title }}</strong> {{ .Message }}
</div>